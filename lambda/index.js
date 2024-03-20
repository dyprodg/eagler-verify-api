const { Client } = require('pg');
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
      body: JSON.stringify({ message: 'Error fetching secret' })
    };
  }
  if (!secret) {
    return {
      statusCode: 403,
      body: JSON.stringify({ message: 'Secret missing' })
    };
  }

  console.log(secret)
  
  const connectionString = secret.POSTGRES_URL
  if (!connectionString) {
    return {
      statusCode: 406,
      body: JSON.stringify({ message: 'Connection string missing' })
    };
  }

  const client = new Client({
    connectionString: connectionString
  });



    try {
            await client.connect((err) => {
                if (err) {
                console.error('Error connecting to the database:', err);
                } else {
                console.log('Connected to the database!');
                }
            });
            const res = await client.query(
                'UPDATE user SET email_verified = true, email_verified_token = null WHERE email_verified_token = $1',
                [token]
            );
            

    } catch (error) {
        console.error('Error initializing PG Client:', error);
        return {
        statusCode: 405,
        body: JSON.stringify({ message: 'Error initializing Prisma Client' })
        };
    } finally {
        await client.end();
    }

  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Email verified' })
  };
};