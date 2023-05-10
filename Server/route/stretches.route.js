const express = require("express");

const stretchController = require("../controller/stretch.controller");

const router = express.Router();

router.post("/save", stretchController.saveStretchSummary);
router.get("/allSessions", stretchController.getAllForUser);
router.get("/sessionsCount", stretchController.getSessionsCountForUser);
router.get("/plannedSession", stretchController.getPlannedSession);

module.exports = router;