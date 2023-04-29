const express = require("express");

const therapistController = require("../controller/therapist.controller");

const router = express.Router();

router.get("/allCollaborations", therapistController.allCollaborations);
router.post("/sendInvitation", therapistController.sendInvitation);
router.post("/searchPatient", therapistController.searchPatient);
router.post("/patientSessionsHistory", therapistController.getPatientSessionsHistory);

module.exports = router;