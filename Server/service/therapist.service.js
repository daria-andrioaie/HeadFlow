const CollaborationModel = require("../model/collaboration.model");
const UserModel = require("../model/user.model");
const StretchingSessionSummaryModel = require("../model/stretchingSessionSummary.model");
const PlannedStretchingSessionModel = require("../model/plannedStretchingSession.model");
const stretchService = require("../service/stretch.service");

const allCollaborations = async(therapistId) => {
        const collaborations = await CollaborationModel.find({ therapist: therapistId }).populate(['patient', 'therapist']); 
        return collaborations;
}

const sendInvitation = async(therapistId, patientId) => {
    const patient = await UserModel.findOne({ _id: patientId });
    if(typeof patient === undefined) {
        throw new Error("No patient with the given id.");
    }

    const collaboration = new CollaborationModel({
        therapist: therapistId,
        patient,
        status: "pending"
    });
    
    const savedCollaboration = await collaboration.save();
    const populatedCollaboration = await CollaborationModel.findOne( {
        _id: savedCollaboration._id
    }).populate(['patient', 'therapist']);

    return populatedCollaboration;
}

const searchPatient = async(therapistId, patientEmailAddress) => {
    let patient = await UserModel.findOne({ email: patientEmailAddress }); 
    if(!patient || patient.userType != 'patient') {
      throw new Error("no patient")
    }

    let collaborationWithPatient = await CollaborationModel.findOne({ patient: patient._id});

    if(!collaborationWithPatient) {
      return patient;
    } else if( collaborationWithPatient.therapist !== therapistId ) {
      throw new Error("no patient")
    } else if(collaborationWithPatient.status === 'pending') {
      throw new Error("pending collaboration")
    } else if(collaborationWithPatient.status === 'active') {
      throw new Error("active collaboration")
    } else {
      throw new Error("Eroneous collab with patient.")
    }
}

const getPatientSessionsHistory = async(therapistId, patientId) => {
  let collaborationWithPatient = await CollaborationModel.findOne({ patient: patientId, therapist: therapistId });

  if(!collaborationWithPatient || collaborationWithPatient.status !== "active") {
    throw new Error("The therapist does not have access to the data of the given patient.")
  }
  return StretchingSessionSummaryModel.find( { userId: patientId });
}

const getPlannedStretchingSessionOfPatient = async(therapistId, patientId) => {
  let collaborationWithPatient = await CollaborationModel.findOne({ patient: patientId, therapist: therapistId });

  if(!collaborationWithPatient || collaborationWithPatient.status !== "active") {
    throw new Error("The therapist does not have access to the data of the given patient.")
  }
  return await stretchService.getPlannedStretchingSessionOfPatient(patientId);
}

const savePlannedSessionForPatient = async(therapistId, patientId, exerciseData) => {
  let collaborationWithPatient = await CollaborationModel.findOne({ patient: patientId, therapist: therapistId });

  if(!collaborationWithPatient || collaborationWithPatient.status !== "active") {
    throw new Error("The therapist does not have access to the data of the given patient.")
  }
  let savedSession = await PlannedStretchingSessionModel.findOneAndUpdate(
    { userId: patientId },
    { exerciseData: exerciseData },
    { new: true}
    );
  return savedSession.exerciseData
}

module.exports = {
    allCollaborations,
    sendInvitation,
    searchPatient,
    getPatientSessionsHistory,
    getPlannedStretchingSessionOfPatient,
    savePlannedSessionForPatient
  };
  