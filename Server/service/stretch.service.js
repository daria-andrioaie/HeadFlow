const UserModel = require("../model/user.model");
const SessionModel = require("../model/session.model");
const jwt = require("jsonwebtoken");
const jwtKey = process.env.JWT_SECRET;
const { OAuth2Client } = require("google-auth-library");
const StretchModel = require("../model/stretch.model");
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

const saveStretchSummary = async (userId, averageRangeOfMotion, duration) => {
  if (typeof averageRangeOfMotion === "undefined") {
    throw new Error("Range of motion not provided.");
  }

  if (typeof duration === "undefined") {
    throw new Error("PDuration not provided.");
  }

  if (averageRangeOfMotion > 1 || averageRangeOfMotion <= 0) {
    throw new Error("The average range of motion must be a value in (0, 1]");
  }

  const stretchSummary = new StretchModel({
    userId,
    averageRangeOfMotion,
    duration,
    date: new Date(),
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
