const userService = require("../service/user.service");

const signUp = async (req, res) => {
  try {
    const user = await userService.signUp(req.body);
    res.status(200).send({ user });
  } catch (error) {
    console.log(error.message)
    res.status(404).send({ success: false, message: error.message });
  }
};

const login = async (req, res) => {
  try {
    const user = await userService.login(req.body);
    res.status(200).send({ user });

  } catch (error) {
    console.log(error.message)
    res.status(404).send({ success: false, message: error.message });
  }
};

module.exports = {
  signUp, login, 
};