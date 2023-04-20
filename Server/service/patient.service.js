const UserModel = require("../model/user.model");

const searchPatient = async(patientEmailAddress) => {
    let patient = await UserModel.findOne({ email: patientEmailAddress }); 
    if(!patient || patient.userType != 'patient') {
      throw new Error("no patient")
    }
  
    return patient;
}

module.exports = {
    searchPatient,
  };
  