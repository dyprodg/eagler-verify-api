const exec = require('child_process').exec;

exports.handler = async (event, context) => {
    try {
        const token = event.queryStringParameters && event.queryStringParameters.token;
        
        if (!token) {
            throw new Error('Token missing');
        }

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
        });

        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Token and secret successfully received' })
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 400,
            body: JSON.stringify({ message: 'Error processing the token' })
        };
    }
};