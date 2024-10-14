const express = require("express");
const cors = require('cors');
const mongoose = require("mongoose");
const port = 3001;
const routes = require("./routes");
const username = process.env.MONGO_USERNAME;
const password = process.env.MONGO_PASSWORD;
const uri = process.env.MONGODB_URI
main().catch((err) => console.log(err) && console.log(`Server is ${uri}${username}${password}`));

async function main() {
  console.log(`Server is ${uri}${username}${password}`);
  await mongoose.connect("mongodb://mongo-service:27017/todos", {
    useUnifiedTopology: true,
    useNewUrlParser: true,
  });
  const app = express();
  app.use(cors());
  app.use(express.json());
  app.use("/api", routes);

  app.listen(port, () => {
    console.log(`Server is listening on port: ${port}`);
    console.log(`Server is ${uri}${username}${password}`);
  });
}
