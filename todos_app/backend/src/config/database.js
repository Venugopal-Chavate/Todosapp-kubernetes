const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
const connectionString = `mongodb://username:password@${process.env.MONGO_URL}/todo`;
module.exports = mongoose.connect(connectionString);
