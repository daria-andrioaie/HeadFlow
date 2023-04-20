const collaborationsService = require("../service/collaboration.service");
const userService = require("../service/user.service");
const authorizationService = require("../service/authorization.service");

const allCollaborations = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const therapistId = await authorizationService.authorizeToken(bearerHeader);
    let therapist = await userService.getUser(therapistId);
    if (therapist.userType == "therapist") {
      const collaborations = await collaborationsService.allCollaborations(
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
      const collaboration = await collaborationsService.sendInvitation(
        therapistId,
        req.body.patientId
      );
      res.status(200).send({success: true, collaboration: collaboration});
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
};
