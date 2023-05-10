const stretchService = require("../service/stretch.service");
const authorizationService = require("../service/authorization.service");


const saveStretchSummary = async (req, res) => {
    const bearerHeader = req.headers['authorization'];
  try {
    const userId = await authorizationService.authorizeToken(bearerHeader);
    const { averageRangeOfMotion, duration, exerciseData, date } = req.body;
    const savedSummary = await stretchService.saveStretchSummary(userId, averageRangeOfMotion, duration, exerciseData, date);
    res.status(200).send({ success: true, message: "Saved successfully!" });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const getAllForUser = async (req, res) => {
    const bearerHeader = req.headers['authorization'];
  try {
    const userId = await authorizationService.authorizeToken(bearerHeader);
    const allStretches = await stretchService.getAllForUser(userId);
    res.status(200).send({ success: true, stretches: allStretches });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const getSessionsCountForUser = async (req, res) => {
  const bearerHeader = req.headers['authorization'];
try {
  const userId = await authorizationService.authorizeToken(bearerHeader);
  const allStretches = await stretchService.getAllForUser(userId);

  res.status(200).send({ success: true, count: allStretches.length });
} catch (error) {
  console.log(error.message);
  res.status(404).send({ success: false, message: error.message });
}
};

const getPlannedSession = async (req, res) => {
  const bearerHeader = req.headers['authorization'];
try {
  const userId = await authorizationService.authorizeToken(bearerHeader);
  const plannedSession = await stretchService.getPlannedStretchingSessionOfPatient(userId);

  res.status(200).send({ success: true, plannedSession: plannedSession });
} catch (error) {
  console.log(error.message);
  res.status(404).send({ success: false, message: error.message });
}
};

module.exports = {
  saveStretchSummary,
  getAllForUser,
  getSessionsCountForUser,
  getPlannedSession
};
