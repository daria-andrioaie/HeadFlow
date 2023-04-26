const express = require("express");

const patientController = require("../controller/patient.controller");

const router = express.Router();
router.get("/getCollaboration", patientController.getCollaboration);
router.post("/acceptInvitation", patientController.acceptInvitation);

module.exports = router;