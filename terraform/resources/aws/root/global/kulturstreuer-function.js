async function handler(event) {
    const response = {
        statusCode: 301,
        statusDescription: 'Moved Permanently',
        headers:
            { "location": { "value":  "https://gz-toess.ch/kulturstreuer" } }
        }

    return response;
}
