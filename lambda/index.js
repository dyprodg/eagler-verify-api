exports.handler = async (event, context) => {
    try {
        const token = event.queryStringParameters && event.queryStringParameters.token;
        
        if (!token) {
            throw new Error('Token missing');
        }
        
        console.log('Token:', token);
        return {
            statusCode: 200,
            body: JSON.stringify({ message: 'Token successfully received' })
        };
    } catch (error) {
        console.error('Error:', error);
        return {
            statusCode: 400,
            body: JSON.stringify({ message: 'Error processing the token' })
        };
    }
  };
  