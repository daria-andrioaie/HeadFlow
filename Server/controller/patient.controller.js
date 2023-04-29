const patientService = require("../service/patient.service");
const userService = require("../service/user.service");
const authorizationService = require("../service/authorization.service");

const getCollaboration = async (req, res) => {
    const bearerHeader = req.headers["authorization"];
    try {
      const patientId = await authorizationService.authorizeToken(bearerHeader);

      let patient = await userService.getUser(patientId);
      if (patient.userType == "patient") {
        const collaboration = await patientService.getCollaboration(
          patientId
        );
        res.status(200).send(collaboration);
      } else {
        throw new Error("There is no patient with the given id.");
      }
    } catch (error) {
      console.log(error.message);

      if (error.message === "no collaboration") {
        res
          .status(200)
          .send({
            success: false,
            message: "The given patient does not collaborate with any therapist",
            code: 200,
          });
      } else {
        res.status(404).send({ success: false, message: error.message });
      }
    }
  };

  const respondToInvitation = async (req, res) => {
    const bearerHeader = req.headers["authorization"];
    try {
      const patientId = await authorizationService.authorizeToken(bearerHeader);

      const therapistId = req.body.therapistId;
      const isInvitationAccepted = req.body.acceptInvitation;
      console.log(req.body);

      if(typeof therapistId === undefined) {
        throw new Error("Therapist id was not provided.")
      }

      if(typeof isInvitationAccepted === undefined) {
        throw new Error("Invitation response was not provided.")
      }

      let patient = await userService.getUser(patientId);
      if (patient.userType == "patient") {
        const collaboration = await patientService.respondToInvitation(
          patientId,
          therapistId,
          isInvitationAccepted
        );
        res.status(200).send(collaboration);
      } else {
        throw new Error("There is no patient with the given id.");
      }
    } catch (error) {
      console.log(error.message);

      if (error.message === "no collaboration") {
        res
          .status(200)
          .send({
            success: false,
            message: "The given patient does not collaborate with any therapist",
            code: 200,
          });
      } else {
        res.status(404).send({ success: false, message: error.message });
      }
    }
  };

  const interruptCollaboration = async (req, res) => {
    const bearerHeader = req.headers["authorization"];
    try {
      const patientId = await authorizationService.authorizeToken(bearerHeader);

      let patient = await userService.getUser(patientId);
      if (patient.userType == "patient") {
        const collaboration = await patientService.interruptCollaboration(patientId);
        res.status(200).send(collaboration);
      } else {
        throw new Error("There is no patient with the given id.");
      }
    } catch (error) {
      console.log(error.message);
      res.status(404).send({ success: false, message: error.message });
    }
  };

module.exports = {
  getCollaboration,
  respondToInvitation,
  interruptCollaboration
  };
  