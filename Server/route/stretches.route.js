const express = require("express");

const userController = require("../controller/stretch.controller");

const router = express.Router();

router.post("/save", userController.saveStretchSummary);
router.get("/", userController.getAllForUser);


module.exports = router;