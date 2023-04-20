const CollaborationModel = require("../model/collaboration.model");
const UserModel = require("../model/user.model");


const allCollaborations = async(therapistId) => {
        const collaborations = await CollaborationModel.find({ therapistId: therapistId }).populate('patient'); 
        return collaborations;
}

const sendInvitation = async(therapistId, patientId) => {
    const patient = await UserModel.findOne({ _id: patientId });
    if(typeof patient === undefined) {
        throw new Error("No patient with the given id.");
    }

    const collaboration = new CollaborationModel({
        therapistId,
        patient,
        status: "pending"
    });
    
    const savedCollaboration = await collaboration.save();

    return savedCollaboration;
}

module.exports = {
    allCollaborations,
    sendInvitation,
  };
  