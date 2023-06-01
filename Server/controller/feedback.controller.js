const feedbackService = require("../service/feedback.service");
const userService = require("../service/user.service");
const authorizationService = require("../service/authorization.service");

const getFeedback = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const userId = await authorizationService.authorizeToken(bearerHeader);
    const sessionId = req.body.sessionId;

    if (typeof sessionId === undefined) {
      throw new Error("Session id was not provided.");
    }

    const feedback = await feedbackService.getFeedback(userId, sessionId);
    res.status(200).send({ success: true, feedback: feedback });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const saveFeedback = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const therapistId = await authorizationService.authorizeToken(bearerHeader);
    const sessionId = req.body.sessionId;
    const message = req.body.message;

    let therapist = await userService.getUser(therapistId);
    if (therapist.userType != "therapist") {
      throw new Error("There is no therapist with the given id.");
    }
    if (typeof sessionId === undefined) {
      throw new Error("Session id was not provided.");
    }
    if (typeof message === undefined) {
      throw new Error("Session id was not provided.");
    }

    const feedback = await feedbackService.saveFeedback(therapistId, sessionId, message);
    res.status(200).send({ success: true, feedback: feedback });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

module.exports = {
  getFeedback,
  saveFeedback,
};
