const mongoose = require('mongoose')
function barrel(x, y, lane, itemAmount){
this.x = x,
this.y = y,
this.lane = lane,
this.itemAmount = itemAmount
}

const ItemDB = new mongoose.Schema({
    ItemName: {type:String},
    Amount: {type:Number},
    Barrel: {type: barrel}
})
module.exports = barrel;
module.exports = mongoose.model('ItemDB', ItemDB)