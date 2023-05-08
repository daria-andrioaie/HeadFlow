const CollaborationModel = require("../model/collaboration.model");

const getCollaboration = async(patientId) => {
    const collaboration = await CollaborationModel.findOne({ patient: patientId }).populate(['patient', 'therapist']); 
    
    if(!collaboration || collaboration.status == "declined") {
        throw new Error("no collaboration")
    }

    return collaboration;
}

const respondToInvitation = async(patientId, therapistId, isInvitationAccepted) => {
    const collaborationStatus = isInvitationAccepted ? "active" : "declined";
    const collaboration = await CollaborationModel.findOneAndUpdate( { therapist: therapistId, patient: patientId }, { status : collaborationStatus}, { new: true}).populate(['patient', 'therapist']);
    
    if(!collaboration) {
        throw new Error("no collaboration")
    }

    return collaboration;
}

const interruptCollaboration = async(patientId) => {
    const collaboration = await CollaborationModel.findOneAndUpdate( { patient: patientId }, { status : "declined"}, { new: true}).populate(['patient', 'therapist']);
    
    if(!collaboration) {
        throw new Error("no collaboration")
    }

    return collaboration;
}

module.exports = {
    getCollaboration,
    respondToInvitation,
    interruptCollaboration
  };
  