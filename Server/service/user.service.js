const UserModel = require("../model/user.model");

const otpService = require("../service/otp.service");

const signUp = async ({ username, mobileNo, name }) => {
  try {
    const user = new UserModel({
      username,
      mobileNo,
      name,
      status: "PENDING",
    });

    const savedUser = await user.save();
    const otpResponse = await otpService.sendOTP(username, mobileNo, name);
    console.log(otpResponse.message);
    return savedUser;
  } catch (error) {
    console.error(error);
    throw error;
  }
};

module.exports = {
  signUp,
};