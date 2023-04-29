const express = require("express");

const patientController = require("../controller/patient.controller");

const router = express.Router();
router.get("/getCollaboration", patientController.getCollaboration);
router.post("/respondToInvitation", patientController.respondToInvitation);
router.post("/interruptCollaboration", patientController.interruptCollaboration);

module.exports = router;