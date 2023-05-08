const mongoose = require("mongoose");

const plannedStretchingSessionSchema = new mongoose.Schema(
  {
    userId: {
      type: String,
      required: true,
      trim: true,
    },
    exerciseData: [{
      exerciseType: String,
      goalDegrees: Number,
      maximumDegrees: Number,
      duration: Number
    }],
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("plannedStretchingSession", plannedStretchingSessionSchema);
