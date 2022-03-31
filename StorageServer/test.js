const mongoose = require('mongoose');
let keyfile  = require('./key.json')

const mongodbUri = keyfile.key
mongoose.connect(mongodbUri, {useNewUrlParser: true, useUnifiedTopology: true})

const db = mongoose.connection;

db.on('error', console.error.bind(console, 'connection error:'));
db.once('open', function() {
    console.log("connected to tunngle")  



    
})
