const FeedbackModel = require("../model/feedback.model");
const CollaborationModel = require("../model/collaboration.model");
const StretchingSessionSummaryModel = require("../model/stretchingSessionSummary.model");

const getFeedback = async (userId, sessionId) => {
  let feedbackRequestedByPatient = await FeedbackModel.findOne({
    patient: userId,
    session: sessionId,
  }).populate(['therapist']);
  if (feedbackRequestedByPatient) {
    return feedbackRequestedByPatient;
  }

  let feedbackRequestedByTherapist = await FeedbackModel.findOne({
    therapist: userId,
    session: sessionId,
  }).populate(['therapist']);
  if (feedbackRequestedByTherapist) {
    return feedbackRequestedByTherapist;
  }

  throw new Error("There is no feedback for the given session.");
};

const saveFeedback = async (therapistId, sessionId, message) => {
    // get the patientId of the session
    let session = await StretchingSessionSummaryModel.findById(sessionId);
    if(!session) {
        throw new Error("There is no session for the given id.");
    }

    let patientId = session.userId;

    // check that the therapist has an active collab with the patient
    let collaborationWithPatient = await CollaborationModel.findOne({ patient: patientId, therapist: therapistId });

    if(!collaborationWithPatient || collaborationWithPatient.status !== "active") {
      throw new Error("The therapist does not have access to the given session.")
    }

    //check if there already exists a feedback and update
    let updatedFeedback = await FeedbackModel.findOneAndUpdate({
      patient: patientId,
      session: sessionId,
      therapist: therapistId
    }, 
    {
        message: message
    },
    { new: true }).populate(['therapist']);

    if (!updatedFeedback) {
        const feedback = new FeedbackModel({
            therapist: therapistId,
            patient: patientId,
            session: sessionId,
            message: message,
            date: Date.now()
        });
        
        const savedFeedback = await feedback.save();
        const populatedFeedback = await FeedbackModel.findOne( {
            _id: savedFeedback._id
        }).populate(['therapist']);
    
        return populatedFeedback;
    } else {
        return updatedFeedback
    }
  };

module.exports = {
  getFeedback,
  saveFeedback
};
