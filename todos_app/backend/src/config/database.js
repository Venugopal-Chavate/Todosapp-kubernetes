const mongoose = require('mongoose');

mongoose.Promise = global.Promise;
const connectionString = `mongodb://${process.env.MONGO_URL || 'localhost'}/todo`;
module.exports = mongoose.connect(connectionString);
