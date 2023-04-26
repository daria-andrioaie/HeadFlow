const UserModel = require("../model/user.model");
const CollaborationModel = require("../model/collaboration.model");

const getCollaboration = async(patientId) => {
    const collaboration = await CollaborationModel.findOne({ patient: patientId }).populate(['patient', 'therapist']); 
    
    if(!collaboration) {
        throw new Error("no collaboration")
    }

    return collaboration;
}


const acceptInvitation = async(patientId, therapistId) => {
    const collaboration = await CollaborationModel.findOneAndUpdate( { therapist: therapistId, patient: patientId }, { status : "active"}, { new: true}).populate(['patient', 'therapist']);
    
    if(!collaboration) {
        throw new Error("no collaboration")
    }

    return collaboration;
}

module.exports = {
    getCollaboration,
    acceptInvitation
  };
  