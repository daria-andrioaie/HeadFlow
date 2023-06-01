const mongoose = require("mongoose");

const feedbackSchema = new mongoose.Schema(
  {
    session: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'stretchingSessionSummary',
        required: true,
        trim: true,
    },
    patient: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'user',
      required: true,
      trim: true,
    },
    therapist: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'user',
        required: true,
        trim: true,
    },
    message: {
        type: String,
        required: true,
        trim: true,
    },
    date: {
        type: Number,
        required: true,
    }
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("feedback", feedbackSchema);