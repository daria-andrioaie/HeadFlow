const express = require("express");

const patientController = require("../controller/patient.controller");

const router = express.Router();
router.get("/getTherapist", patientController.getTherapist);

module.exports = router;