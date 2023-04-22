const UserModel = require("../model/user.model");
const CollaborationModel = require("../model/collaboration.model");

const getTherapist = async(patientId) => {
    const collaboration = await CollaborationModel.findOne({ patient: patientId }).populate(['patient', 'therapist']); 
    
    if(!collaboration) {
        throw new Error("no therapist")
    }

    return collaboration;
}

module.exports = {
    getTherapist
  };
  