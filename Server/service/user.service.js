const UserModel = require("../model/user.model");
const SessionModel = require("../model/session.model");
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

  let existingUser = await UserModel.findOne({ phoneNumber: phoneNumber });
  if (existingUser) {
    throw new Error("An account already exists for the given phone number.");
  }

  const user = new UserModel({
    username,
    phoneNumber,
    status: "PENDING",
  });

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

const logout = async (token) => {
  const decodedToken = jwt.verify(token, jwtKey);
  let existingToken = await SessionModel.findOne({ token: token });
  if (!existingToken) {
    throw new Error("The token is invalid.");
  }

  await SessionModel.deleteOne({ token: token });
  return "Logout successful.";
};

module.exports = {
  signUp,
  login,
  logout,
};
