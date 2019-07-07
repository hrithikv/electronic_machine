var http = require("http");

http.createServer(function (request, response) {
   response.writeHead(100, {'Content-Type': 'text'});
   response.end('Welcome \n');
}).listen(8080);

console.log('Server running at http://127.0.0.1:8080/');
