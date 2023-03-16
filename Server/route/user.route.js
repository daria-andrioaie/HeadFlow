const express = require("express");

const userController = require("../controller/user.controller");

const router = express.Router();

router.post("/", userController.signUp);
router.post("/login", userController.login);
router.post("/logout", userController.logout);
router.post("/social-sign-in", userController.socialSignIn);
router.post("/check-token", userController.checkToken);

module.exports = router;