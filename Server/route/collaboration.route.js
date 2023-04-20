const express = require("express");

const collaborationController = require("../controller/collaboration.controller");

const router = express.Router();

router.get("/all", collaborationController.allCollaborations);
router.post("/sendInvitation", collaborationController.sendInvitation);


module.exports = router;