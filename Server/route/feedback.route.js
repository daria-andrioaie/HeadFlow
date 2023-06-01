const express = require("express");

const feedbackController = require("../controller/feedback.controller");

const router = express.Router();

router.post("/getFeedback", feedbackController.getFeedback);
router.post("/", feedbackController.saveFeedback);

module.exports = router;