const mongoose=require('mongoose');

const userSchema=new mongoose.Schema({
    name:String,
    email:String,
    number:String,
    address:String,
});

const user=mongoose.model('userSchema',userSchema);
module.exports =user