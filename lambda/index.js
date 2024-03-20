const { PrismaClient } = require('@prisma/client');
const exec = require('child_process').exec;

exports.handler = async (event, context) => {
    try {
        // Get the secret from AWS Secrets Manager
        exec(`aws secretsmanager get-secret-value --secret-id ${process.env.SECRET_ID}`, (error, stdout, stderr) => {
            if (error) {
                console.error(`Error fetching secret: ${error}`);
                return;
            }
            const secret = JSON.parse(stdout).SecretString;
            if(!secret) {
                throw new Error('Secret missing');
            }

            try {
                const prisma = new PrismaClient({
                    datasources: {
                        db: {
                            url: secret.DATABASE_URL
                        }
                    }
                });
    
            } catch (error) {
                console.error('Error initializing Prisma Client', error);
                return {
                    statusCode: 400,
                    body: JSON.stringify({ message: 'Error initializing Prisma Client' })
                };
            }
            // Initialize Prisma Client with the database connection string

            // Use Prisma Client to connect to the database and perform operations
            // For example, to fetch all users:
            // const users = await prisma.user.findMany();
        });

        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Token and secret successfully received' })
        };
    } catch (error) {
        console.error('Error', error);
        return {
            statusCode: 400,
            body: JSON.stringify({ message: 'Error processing the token' })
        };
    }
};