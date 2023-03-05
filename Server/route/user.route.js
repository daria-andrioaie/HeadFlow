const express = require("express");

const userController = require("../controller/user.controller");

const router = express.Router();

router.post("/", userController.signUp);
router.post("/login", userController.login);
router.post("/logout", userController.logout);

module.exports = router;