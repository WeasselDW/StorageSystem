const mongoose = require('mongoose');
const WebSocket = require('ws');
let keyfile  = require('./key.json')
const mongodbUri = keyfile.key

mongoose.connect(mongodbUri, {useNewUrlParser: true, useUnifiedTopology: true})

const db = mongoose.connection;

const wss = new WebSocket.Server({ port: 8080 });


db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    console.log("connected to tunngle")  
})

wss.on('connection', function connection(ws) {
    console.log("player connected")

});
