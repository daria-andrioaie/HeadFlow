const mongoose = require("mongoose");

const sessionSchema = new mongoose.Schema(
  {
    userId: {
        type: String,
        required: true,
        trim: true,
    },
    token: {
      type: String,
      required: true,
      trim: true,
    },
  },
);

module.exports = mongoose.model("session", sessionSchema);