const StretchingSessionSummaryModel = require("../model/stretchingSessionSummary.model");
const PlannedStretchingSessionModel = require("../model/plannedStretchingSession.model");

const saveStretchSummary = async (userId, averageRangeOfMotion, duration, exerciseData, date) => {
  if (typeof averageRangeOfMotion === "undefined") {
    throw new Error("Range of motion not provided.");
  }

  if (typeof duration === "undefined") {
    throw new Error("Duration not provided.");
  }

  if (typeof exerciseData === "undefined") {
    throw new Error("Exercise data not provided.");
  }

  if (typeof date === "undefined") {
    throw new Error("Date not provided.");
  }

  if (averageRangeOfMotion > 1 || averageRangeOfMotion <= 0) {
    throw new Error("The average range of motion must be a value in (0, 1]");
  }

  let calculatedAverageRange = 0;
  let calculatedSumOfRanges = 0;
  let calculatedDuration = 0;

  exerciseData.forEach(exercise => {
    calculatedSumOfRanges += exercise.rangeOfMotion;
    calculatedDuration += exercise.duration;
  });

  calculatedAverageRange = calculatedSumOfRanges / exerciseData.length;

  if(calculatedAverageRange != averageRangeOfMotion) {
    throw new Error("The field average range of motion does do coincide with the average of each exercise.");
  }

  if(calculatedDuration != duration) {
    throw new Error("The field duration does do coincide with the sum of durations of each exercise.");
  }

  const stretchSummary = new StretchingSessionSummaryModel({
    userId,
    averageRangeOfMotion,
    duration,
    exerciseData: exerciseData,
    date: date,
  });

  const savedSummary = await stretchSummary.save();

  return savedSummary;
};

const getAllForUser = async (userId) => {
  return StretchingSessionSummaryModel.find({ userId: userId });
};

const getPlannedStretchingSessionOfPatient = async (userId) => {
  let session = await PlannedStretchingSessionModel.findOne({ userId: userId });

  if(!session) {
    const plannedSession = new PlannedStretchingSessionModel({
      userId,
      exerciseData: [{ exerciseType: "tiltToRight", goalDegrees: 45, maximumDegrees: 45, duration: 5 },
      { exerciseType: "tiltToLeft", goalDegrees: 45, maximumDegrees: 45, duration: 5 },
      { exerciseType: "tiltForward", goalDegrees: 45, maximumDegrees: 45, duration: 5 },
      { exerciseType: "tiltBackwards", goalDegrees: 45, maximumDegrees: 45, duration: 5 },
      { exerciseType: "rotateToRight", goalDegrees: 60, maximumDegrees: 60, duration: 5 },
      { exerciseType: "rotateToLeft", goalDegrees: 60, maximumDegrees: 60, duration: 5 }
    ]
    });
  
    const savedSession = await plannedSession.save();
  
    return savedSession.exerciseData;
  }

  return session.exerciseData
};

module.exports = {
  saveStretchSummary,
  getAllForUser,
  getPlannedStretchingSessionOfPatient
};
