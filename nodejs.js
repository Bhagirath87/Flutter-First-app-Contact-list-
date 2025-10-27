const express=require('express');
const mangoose=require('mongoose');

mangoose.connect('mongodb://localhost:27017/flutterapp');
const user=require('./models/user');
const app=express();

app.use(express.urlencoded({ extended: true }));
app.use(express.json());

const port=3000;

app.get("/getusers",async (req,res)=>{
    const users=await user.find();
    res.send(users);
})

app.get("/getusersf", async (req, res) => {
  try {
    const users = await user.find({}, { name: 1, number: 1, _id: 0 });
    // { field: 1 } means include; { _id: 0 } removes MongoDB ID
    res.json(users);
  } catch (err) {
    console.error(err);
    res.status(500).send("Error fetching users");
  }
});


app.post("/create",async(req,res)=>{
    const {name,number,email,address}=req.body;
    const u= await user.create({name,number,email,address});
    // console.log(u);
    // res.json(u)
    res.send("created");
})
app.listen(port,()=>{
    console.log("server is running on ",port);
})
