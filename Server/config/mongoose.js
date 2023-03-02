const mongoose = require("mongoose");

const DB_URL = process.env.DB_URL;

const connectionParams={
    useNewUrlParser: true,
    useUnifiedTopology: true 
}

module.exports = () => {

    return mongoose.connect(DB_URL, connectionParams)
        .then(() => {
            console.log(`MongoDB successfully connected`);
        })
        .catch(err => {
            console.error(`MongoDB failed to connect - ${err}`);
            throw new Error(err);
        })
}