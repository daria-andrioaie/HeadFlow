const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    firstName: {
        type: String,
        required: true,
        trim: true,
    },
    lastName: {
      type: String,
      required: true,
      trim: true,
    },
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    phoneNumber: {
      type: String,
      unique: true,
      trim: true,
    },
    profilePicture: {
      type: String,
    },
    userType: {
      type: String,
      required: true,
      trim: true,
    },
    status: {
      type: String,
      required: true,
    },
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("user", userSchema);
