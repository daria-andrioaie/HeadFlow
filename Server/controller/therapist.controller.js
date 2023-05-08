const therapistService = require("../service/therapist.service");
const userService = require("../service/user.service");
const authorizationService = require("../service/authorization.service");

const allCollaborations = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const therapistId = await authorizationService.authorizeToken(bearerHeader);
    let therapist = await userService.getUser(therapistId);
    if (therapist.userType == "therapist") {
      const collaborations = await therapistService.allCollaborations(
        therapistId
      );
      res.status(200).send(collaborations);
    } else {
      throw new Error("There is no therapist with the given id.");
    }
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const sendInvitation = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const therapistId = await authorizationService.authorizeToken(bearerHeader);
    let therapist = await userService.getUser(therapistId);
    if (therapist.userType == "therapist") {
      const collaboration = await therapistService.sendInvitation(
        therapistId,
        req.body.patientId
      );
      res.status(200).send(collaboration);
    } else {
      throw new Error("There is no therapist with the given id.");
    }
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const searchPatient = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const therapistId = await authorizationService.authorizeToken(bearerHeader);

    let therapist = await userService.getUser(therapistId);
    if (therapist.userType == "therapist") {
      const patient = await therapistService.searchPatient(therapistId, req.body.emailAddress);
      res.status(200).send(patient);
    } else {
      throw new Error("There is no therapist with the given id.");
    }
  } catch (error) {
    console.log(error.message);

    if (error.message === "no patient") {
      res
        .status(200)
        .send({
          success: false,
          message: "We couldn't find any patient with the given email address. Please check the spelling.",
          code: 200,
        });
    } else if (error.message === "pending collaboration") {
      res
        .status(200)
        .send({
          success: false,
          message: "You have a pending collaboration with this patient.",
          code: 200,
        });
    } else if (error.message === "active collaboration") {
      res
        .status(200)
        .send({
          success: false,
          message: "You already have an active collaboration with this patient.",
          code: 200,
        });
    } else {
      res.status(404).send({ success: false, message: error.message });
    }
  }
};

const getPatientSessionsHistory = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const therapistId = await authorizationService.authorizeToken(bearerHeader);
    const patientId = req.body.patientId;

    if(typeof patientId === undefined) {
      throw new Error("Patient id was not provided.");
    }

    let therapist = await userService.getUser(therapistId);

    if (therapist.userType == "therapist") {
      const allSessions = await therapistService.getPatientSessionsHistory(
        therapistId,
        patientId
      )
      res.status(200).send({ success: true, stretches: allSessions });
    } else {
      throw new Error("There is no therapist with the given id.");
    }
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const getPlannedStretchingSessionOfPatient = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const therapistId = await authorizationService.authorizeToken(bearerHeader);
    const patientId = req.body.patientId;

    if(typeof patientId === undefined) {
      throw new Error("Patient id was not provided.");
    }

    let therapist = await userService.getUser(therapistId);

    if (therapist.userType == "therapist") {
      const plannedSession = await therapistService.getPlannedStretchingSessionOfPatient(
        therapistId,
        patientId
      )
      res.status(200).send({ success: true, plannedSession: plannedSession });
    } else {
      throw new Error("There is no therapist with the given id.");
    }
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

module.exports = {
  allCollaborations,
  sendInvitation,
  searchPatient,
  getPatientSessionsHistory,
  getPlannedStretchingSessionOfPatient
};
