const express = require("express");

const userController = require("../controller/user.controller");

const router = express.Router();

router.post("/signup", userController.signUp);
router.post("/login", userController.login);
router.post("/logout", userController.logout);
router.post("/social-sign-in", userController.socialSignIn);
router.post("/editProfile", userController.editProfile);
router.get("/", userController.getUser);

module.exports = router;