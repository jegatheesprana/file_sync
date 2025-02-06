#!/bin/bash
echo "Starting Node.js HTTP server with CORS..."

node -e "
const http = require('http');
const fs = require('fs');
const path = require('path');

const server = http.createServer((req, res) => {
    const filePath = path.join(__dirname, 'big_data', 'ans.txt');

    fs.readFile(filePath, (err, data) => {
        if (err) {
            res.writeHead(404, { 'Content-Type': 'text/plain' });
            res.end('Not Found');
        } else {
            res.writeHead(200, {
                'Content-Type': 'text/plain',
                'Access-Control-Allow-Origin': '*',  // Enable CORS
                'Access-Control-Allow-Methods': 'GET, OPTIONS',
                'Access-Control-Allow-Headers': '*'
            });
            res.end(data);
        }
    });
});

server.listen(8000, () => console.log('Server running at http://0.0.0.0:8000'));
"

echo "this is end"
