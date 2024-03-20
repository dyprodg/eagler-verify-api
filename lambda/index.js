const { PrismaClient } = require('@prisma/client');
const execAsync = require('child_process').exec;

exports.handler = async (event, context) => {
  const { token } = event.queryStringParameters;
  if (!token) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Token missing' })
    };
  }

  let secret;
  try {
    secret = await execAsync(`aws secretsmanager get-secret-value --secret-id ${process.env.SECRET_ID}`);
  } catch (error) {
    console.error(`Error fetching secret: ${error}`);
    return {
      statusCode: 401,
      body: JSON.stringify({ message: 'Secret missing' })
    };
  }

  let prisma;
  try {
    prisma = new PrismaClient({
      datasources: {
        db: {
          url: secret.DATABASE_URL
        }
      }
    });
  } catch (error) {
    console.error('Error initializing Prisma Client:', error);
    return {
      statusCode: 405,
      body: JSON.stringify({ message: 'Error initializing Prisma Client' })
    };
  }

  // Use Prisma Client to connect to the database and perform operations
  // For example, to fetch all users:
  // const users = await prisma.user.findMany();
};