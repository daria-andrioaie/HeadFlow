const mongoose = require("mongoose");

const collaborationSchema = new mongoose.Schema(
  {
    therapist: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
        trim: true,
    },
    patient: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'user',
      required: true,
      trim: true,
    },
    status: {
        type: String,
        required: true,
        trim: true,
    }
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("collaboration", collaborationSchema);