const stretchService = require("../service/stretch.service");
const authorizationService = require("../service/authorization.service");


const saveStretchSummary = async (req, res) => {
    const bearerHeader = req.headers['authorization'];
  try {
    const userId = await authorizationService.authorizeToken(bearerHeader);
    const { averageRangeOfMotion, duration } = req.body;
    const savedSummary = await stretchService.saveStretchSummary(userId, averageRangeOfMotion, duration);
    res.status(200).send({ success: true, stretchSummary: saveStretchSummary });
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

module.exports = {
  saveStretchSummary,
  getAllForUser,
};
