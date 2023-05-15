const UserModel = require("../model/user.model");
const SessionModel = require("../model/session.model");

const jwt = require("jsonwebtoken");
const jwtKey = process.env.JWT_SECRET;
const { OAuth2Client } = require("google-auth-library");
const client = new OAuth2Client(process.env.GOOGLE_CLIENT_ID);

const otpService = require("../service/otp.service");

const signUp = async ({ firstName, lastName, email, phoneNumber, userType }) => {
  if (typeof firstName === "undefined") {
    throw new Error("First name not provided.");
  }

  if (typeof lastName === "undefined") {
    throw new Error("Last name not provided.");
  }

  if (typeof email === "undefined") {
    throw new Error("Email not provided.");
  }

  if (typeof phoneNumber === "undefined") {
    throw new Error("Phone number not provided.");
  }

  if (typeof userType === "undefined" || (userType !== "patient" && userType !== "therapist")) {
    throw new Error("User type not provided or not valid.");
  }

  var existingUser = await UserModel.findOne({ phoneNumber: phoneNumber });
  if (existingUser) {
    throw new Error("An account already exists for the given phone number.");
  }

  existingUser = await UserModel.findOne({ email: email });
  if (existingUser) {
    throw new Error("An account already exists for the given email.");
  }

  if(userType === "therapist" && firstName !== "Daria") {
    throw new Error("Sorry! We couldn't validate your medical license.");
  }

  const user = new UserModel({
    firstName,
    lastName,
    email,
    phoneNumber,
    userType: userType,
    status: "PENDING",
  });

  const savedUser = await user.save();
  const otpResponse = await otpService.sendOTP(firstName, phoneNumber);

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
    existingUser.firstName,
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

  let existingUser = await UserModel.findOne({ email: userEmail });
  var dbUser = undefined;
  if (!existingUser) {
    const user = new UserModel({
      firstName: payload.given_name,
      lastName: payload.family_name,
      phoneNumber: payload.phoneNumber,
      email: userEmail,
      status: "VERIFIED",
      userType: "patient"
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

const logout = async (userId) => {
  await SessionModel.deleteOne({ userId: userId });

  return "Logout successful.";
};

const editProfile = async (userId, firstName, lastName, email) => {
  if (typeof firstName === "undefined") {
    throw new Error("First name not provided.");
  }

  if (typeof lastName === "undefined") {
    throw new Error("Last name not provided.");
  }

  if (typeof email === "undefined") {
    throw new Error("Email not provided.");
  }

  var userWithSameEmail = await UserModel.findOne({ email: email });
  if (userWithSameEmail && userWithSameEmail._id != userId) {
    throw new Error("The email address is unavailable.");
  }

  const updatedUser = await UserModel.findOneAndUpdate( { _id: userId }, { firstName: firstName, lastName: lastName, email: email }, { new: true});

  return updatedUser;
};

const editProfilePicture = async (userId, pictureURL) => {
  const updatedUser = await UserModel.findOneAndUpdate(
    { _id: userId },
    { profilePicture: pictureURL },
    { new: true });

  if (!updatedUser) {
    throw new Error('There is no user with the given id.');
  }  
  return updatedUser;
};

module.exports = {
  signUp,
  login,
  socialSignIn,
  logout,
  getUser,
  editProfile,
  editProfilePicture
};