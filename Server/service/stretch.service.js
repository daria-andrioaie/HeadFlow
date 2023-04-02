const UserModel = require("../model/user.model");
const SessionModel = require("../model/session.model");
const jwt = require("jsonwebtoken");
const jwtKey = process.env.JWT_SECRET;
const { OAuth2Client } = require("google-auth-library");
const StretchModel = require("../model/stretch.model");
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

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

  const stretchSummary = new StretchModel({
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
  return StretchModel.find({ userId: userId });
};

module.exports = {
  saveStretchSummary,
  getAllForUser,
};
