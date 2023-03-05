const UserModel = require("../model/user.model");
const OTPModel = require("../model/otp.model");

const jwt = require("jsonwebtoken");
const jwtKey = process.env.JWT_SECRET;

const otpService = require("../service/otp.service");

const signUp = async ({ username, phoneNumber }) => {
  if (typeof username === "undefined") {
    throw new Error("Username not provided.");
  }

  if (typeof phoneNumber === "undefined") {
    throw new Error("Phone number not provided.");
  }

  const user = new UserModel({
    username,
    phoneNumber,
    status: "PENDING",
  });

  let existingUser = await UserModel.findOne({ phoneNumber: phoneNumber });
  if (existingUser) {
    throw new Error("An account already exists for the given phone number.");
  }

  const savedUser = await user.save();
  const otpResponse = await otpService.sendOTP(username, phoneNumber);

  return savedUser;
};

const login = async ({ phoneNumber }) => {
  if (typeof phoneNumber === "undefined") {
    throw new Error("Phone number not provided.");
  }

  let existingUser = await UserModel.findOne({ phoneNumber: phoneNumber });
  if (!existingUser) {
    throw new Error("There is no user with the given phone number.");
  }

  const otpResponse = await otpService.sendOTP(
    existingUser.username,
    existingUser.phoneNumber
  );

  return existingUser;
};

module.exports = {
  signUp,
  login,
};
