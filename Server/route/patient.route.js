const express = require("express");

const patientController = require("../controller/patient.controller");

const router = express.Router();

router.post("/search", patientController.searchPatient);

module.exports = router;