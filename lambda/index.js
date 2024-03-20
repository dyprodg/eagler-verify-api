const { Client } = require('pg');
const AWS = require('aws-sdk');

exports.handler = async (event, context) => {
  const { token } = event.queryStringParameters;
  if (!token) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: 'Token missing' })
    };
  }
  const secretsManager = new AWS.SecretsManager();
  const secretId = process.env.SECRET_ID;
  console.log(secretId)

  let secret;
  try {
    const data = await secretsManager.getSecretValue({ SecretId: secretId }).promise();
    console.log(data)
    const secretString = data.SecretString;
    console.log(secretString)
    const secret = JSON.parse(secretString);
    console.log(secret)
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