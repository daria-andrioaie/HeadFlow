const { CourierClient } = require("@trycourier/courier");

const otpGenerator = require("otp-generator");

const OTPModel = require("../model/otp.model");
const UserModel = require("../model/user.model");

require("dotenv").config();

const courier = CourierClient({
    authorizationToken: process.env.COURIER_TOKEN,
});

const sendOTP = async ( username, mobile ) => {
    try {
      const otp = otpGenerator.generate(4, {
        lowerCaseAlphabets: false, 
        upperCaseAlphabets: false,
        specialChars: false,
      });
  
      await addNewOTP(otp, 15, mobile, "PENDING");
      await sendVerificationMessage(
        {
          username,
          otp,
        },
        mobile
      );
      return {
        success: true,
        message: "OTP sent successfully",
      };
    } catch (error) {
      console.error(error);
      throw error;
    }
  };

  const reSendOTP = async (username, mobile) => {
    try {
        await rejectPendingOTP(mobile);
        return await sendOTP(username, mobile);
    } catch (error) {
        console.error(error);
        throw error;
    }
};

const verifyOTP = async (mobile, otp) => {
    try {
        const validOTP = await OTPModel.findOne({
            otp: otp,
            mobileNo: mobile,
            status: "PENDING",
            expireIn: { $gte: new Date().getTime() },
        });

        if (validOTP) {
            await OTPModel.updateOne(
                { _id: validOTP._id },
                { $set: { status: "CONFIRMED" } }
            );
            await UserModel.updateOne({ mobileNo: mobile }, { $set: { status: "VERIFIED" } });
            return {
                success: true,
                message: "User verified",
            };
        }
        throw new Error("Invalid OTP");
    } catch (error) {
        console.error(error);
        throw error;
    }
};

const sendVerificationMessage = (params, mobileNumber) => {
    return courier.send({
    message: {
        to: {
            data: params,
            phone_number: "+40767998715",
        },
        content: {
            title: "HeadFlow Verification",
            body: "Hi {{username}},\nYour verification code for HeadFlow is {{otp}}.",
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
  
  const addNewOTP = (otp, expirationTime, mobile, status) => {
    const otpModel = new OTPModel({
      otp: otp,
      expireIn: addMinutesToDate(new Date(), expirationTime),
      mobileNo: mobile,
      status: status,
    });
    return otpModel.save();
  };
  
  const rejectPendingOTP = (mobile) => {
    return OTPModel.updateMany(
      { mobile, status: "PENDING" },
      { $set: { status: "REJECTED" } }
    );
  };

module.exports = {
    sendOTP,
    reSendOTP,
    verifyOTP,
  };