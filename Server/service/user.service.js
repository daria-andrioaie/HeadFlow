const UserModel = require("../model/user.model");
const SessionModel = require("../model/session.model");
const jwt = require("jsonwebtoken");
const jwtKey = process.env.JWT_SECRET;
const { OAuth2Client } = require("google-auth-library");
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

const otpService = require("../service/otp.service");
const authorizationService = require("../service/authorization.service");

const signUp = async ({ username, phoneNumber }) => {
  if (typeof username === "undefined") {
    throw new Error("Username not provided.");
  }

  if (typeof phoneNumber === "undefined") {
    throw new Error("Phone number not provided.");
  }

  var existingUser = await UserModel.findOne({ phoneNumber: phoneNumber });
  if (existingUser) {
    throw new Error("An account already exists for the given phone number.");
  }

  existingUser = await UserModel.findOne({ username: username });
  if (existingUser) {
    throw new Error("An account with the given username already exists.");
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

const socialSignIn = async (socialToken) => {
  if (typeof socialToken === "undefined") {
    throw new Error("Social token not provided.");
  }

  const ticket = await client.verifyIdToken({
    idToken: socialToken,
    audience: process.env.GOOGLE_CLIENT_ID,
  });

  const payload = ticket.getPayload();
  const userEmail = payload.email;

  let existingUser = await UserModel.findOne({ username: userEmail });
  var dbUser = undefined;
  if (!existingUser) {
    const user = new UserModel({
      username: userEmail,
      status: "VERIFIED",
    });

    dbUser = await user.save();
  } else {
    dbUser = existingUser;
  }

  let token;
  try {
    token = jwt.sign({ userId: dbUser._id }, jwtKey, { expiresIn: "672h" });

    const session = new SessionModel({
      userId: dbUser._id,
      token: token,
    });
    await session.save();

    return { token: token, user: dbUser };
  } catch (err) {
    console.log(err);
    throw new Error("Error! Something went wrong.");
  }
};

const getUser = async (userId) => {
  let existingUser = await UserModel.findOne({ _id: userId }); 
  if(!existingUser) {
    throw new Error("There is no user with the given user id.")
  }

  return existingUser;
};

const logout = async (token) => {
  const userId = authorizationService.authorizeToken(token);
  await SessionModel.deleteOne({ userId: userId });

  return "Logout successful.";
};

module.exports = {
  signUp,
  login,
  socialSignIn,
  logout,
  getUser,
};
