const UserModel = require("../model/user.model");
const CollaborationModel = require("../model/collaboration.model");


const searchPatient = async(therapistId, patientEmailAddress) => {
    let patient = await UserModel.findOne({ email: patientEmailAddress }); 
    if(!patient || patient.userType != 'patient') {
      throw new Error("no patient")
    }

    let collaborationWithPatient = await CollaborationModel.findOne({therapistId: therapistId, patient: patient._id}).populate('patient');
    if(!collaborationWithPatient) {
      return patient;
    } else if(collaborationWithPatient.status === 'pending') {
      throw new Error("pending collaboration")
    } else if(collaborationWithPatient.status === 'active') {
      throw new Error("active collaboration")
    } else {
      throw new Error("Eroneous collab with patient.")
    }
}

module.exports = {
    searchPatient,
  };
  