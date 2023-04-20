const patientService = require("../service/patient.service");
const userService = require("../service/user.service");
const authorizationService = require("../service/authorization.service");

const searchPatient = async (req, res) => {
  const bearerHeader = req.headers["authorization"];
  try {
    const therapistId = await authorizationService.authorizeToken(bearerHeader);

    let therapist = await userService.getUser(therapistId);
    if (therapist.userType == "therapist") {
      const patient = await patientService.searchPatient(req.body.emailAddress);
      res.status(200).send(patient);
    } else {
      throw new Error("There is no therapist with the given id.");
    }
  } catch (error) {
    console.log(error.message);

    if (error.message === "no patient") {
      res
        .status(200)
        .send({
          success: false,
          message: "There is no patient with the given email address.",
          code: 200,
        });
    } else {
      res.status(404).send({ success: false, message: error.message });
    }
  }
};

module.exports = {
  searchPatient,
};
