const mongoose = require("mongoose");

const stretchingSessionSummarySchema = new mongoose.Schema(
  {
    userId: {
      type: String,
      required: true,
      trim: true,
    },
    averageRangeOfMotion: {
      type: Number,
      required: true,
    },
    duration: {
      type: Number,
      required: true,
    },
    exerciseData: [{
      exerciseType: String,
      rangeOfMotion: Number,
      goalDegrees: Number,
      maximumDegrees: Number,
      duration: Number
    }], 
    date: {
        type: Number,
        required: true,
    }
  },
  {
    timestamps: true,
  }
);

module.exports = mongoose.model("stretchingSessionSummary", stretchingSessionSummarySchema);
