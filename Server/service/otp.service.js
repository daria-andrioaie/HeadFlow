const { CourierClient } = require("@trycourier/courier");

const otpGenerator = require("otp-generator");

const OTPModel = require("../model/otp.model");
const UserModel = require("../model/user.model");
const SessionModel = require("../model/session.model");

const jwt = require("jsonwebtoken");
const jwtKey = process.env.JWT_SECRET;

require("dotenv").config();

const courier = CourierClient({
  authorizationToken: process.env.COURIER_TOKEN,
});

const sendOTP = async (firstName, phoneNumber) => {
  const otp = otpGenerator.generate(4, {
    lowerCaseAlphabets: false,
    upperCaseAlphabets: false,
    specialChars: false,
  });

  await addNewOTP(otp, 15, phoneNumber, "PENDING");
  await sendVerificationMessage(
    {
      firstName,
      otp,
    },
    phoneNumber
  );
  return {
    success: true,
    message: "OTP sent successfully.",
  };
};

const reSendOTP = async (phoneNumber) => {
  await rejectPendingOTP(phoneNumber);
  const user = await UserModel.findOne({ phoneNumber: phoneNumber });

  return await sendOTP(user.firstName, phoneNumber);
};

const verifyOTP = async (phoneNumber, otp) => {
  if (typeof otp === "undefined") {
    throw new Error("Otp not provided.");
  }

  if (typeof phoneNumber === "undefined") {
    throw new Error("Phone number not provided.");
  }

  const validOTP = await OTPModel.findOne({
    otp: otp,
    phoneNumber: phoneNumber,
    status: "PENDING",
    expireIn: { $gte: new Date().getTime() },
  });

  if (validOTP) {
    await OTPModel.updateOne(
      { _id: validOTP._id },
      { $set: { status: "CONFIRMED" } }
    );
    await UserModel.updateOne(
      { phoneNumber: phoneNumber },
      { $set: { status: "VERIFIED" } }
    );
    const user = await UserModel.findOne({ phoneNumber: phoneNumber });

    let token;
    try {
      token = jwt.sign({ userId: user._id }, jwtKey, { expiresIn: "672h" });

      const session = new SessionModel({
        userId: user._id,
        token: token,
      })
      await session.save()

      return { token: token, user: user };
    } catch (err) {
      console.log(err);
      const error = new Error("Error! Something went wrong.");
    }
  }
  throw new Error("Invalid OTP.");
};

const sendVerificationMessage = (params, phoneNumber) => {
  return courier.send({
    message: {
      to: {
        data: params,
        phone_number: "+40767998715",
      },
      content: {
        title: "HeadFlow Verification",
        body: "Hi {{firstName}},\nYour verification code for HeadFlow is {{otp}}.",
      },
      routing: {
        method: "single",
        channels: ["sms"],
      },
    },
  });
};

const addMinutesToDate = (date, minutes) => {
  return new Date(date.getTime() + minutes * 60000);
};

const addNewOTP = (otp, expirationTime, phoneNumber, status) => {
  const otpModel = new OTPModel({
    otp: otp,
    expireIn: addMinutesToDate(new Date(), expirationTime),
    phoneNumber: phoneNumber,
    status: status,
  });
  return otpModel.save();
};

const rejectPendingOTP = (phoneNumber) => {
  return OTPModel.updateMany(
    { phoneNumber: phoneNumber, status: "PENDING" },
    { $set: { status: "REJECTED" } }
  );
};

module.exports = {
  sendOTP,
  reSendOTP,
  verifyOTP,
};
