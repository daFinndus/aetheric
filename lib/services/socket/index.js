const express = require('express');
var http = require('http');
const cors = require('cors');
const app = express();
const port = process.env.PORT || 3000;
var server = http.createServer(app);
var io = require('socket.io')(server);

app.use(express.json());
app.use(cors());

io.on('connection', (socket) => {
    console.log('A user connected.');
    console.log(socket.id, "has joined!");

    socket.on('/id', (data) => { console.log('Opened chat with:', data) });
    socket.on('/message', (data) => { console.log(data) });
});

app.route('/check').get((req, res) => {
    return res.json('Your app is working fine');
});

server.listen(port, "0.0.0.0", () => {
    console.log('Server is running on port: ' + port);
}); 