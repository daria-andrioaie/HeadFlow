const otpService = require("../service/otp.service");

const sendOTP = async (req, res) => {
  const { username, mobile } = req.body;
  const response = await otpService.sendOTP(username, mobile);

  console.log('/POST send OTP');
  res.status(200).send({ data: response });
};

const reSendOTP = async (req, res) => {
  const { username, mobile } = req.body;
  const response = await otpService.reSendOTP(username, mobile);

  console.log('/POST resend OTP');

  res.status(200).send({ data: response });
};

const verifyOTP = async (req, res) => {
  const { mobile, otp } = req.body;
  const response = await otpService.verifyOTP(mobile, otp);

  console.log('/POST send OTP');

  res.status(200).send({ data: response });
};

module.exports = {
  sendOTP,
  reSendOTP,
  verifyOTP,
};