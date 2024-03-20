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

  let secret;
  try {
    const data = await secretsManager.getSecretValue({ SecretId: secretId }).promise();
    const secretString = data.SecretString;
    secret = JSON.parse(secretString); 

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

  const connectionString = secret.POSTGRES_URL;
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
    await client.connect();
    console.log('Connected to the database!');
    const res = await client.query(
      'UPDATE "User" SET emailVerified = true, emailVerifiedToken = null WHERE emailVerifiedToken = $1',
      [token]
    );
  } catch (error) {
    console.error('Error initializing PG Client:', error);
    return {
      statusCode: 405,
      body: JSON.stringify({ message: 'Error initializing PG Client' })
    };
  } finally {
    await client.end();
  }

  return {
    statusCode: 200,
    body: JSON.stringify({ message: 'Email verified' })
  };
};
