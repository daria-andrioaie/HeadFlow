const userService = require("../service/user.service");
const authorizationService = require("../service/authorization.service");

const signUp = async (req, res) => {
  try {
    const user = await userService.signUp(req.body);
    res.status(200).send({ user });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const login = async (req, res) => {
  try {
    const user = await userService.login(req.body);
    res.status(200).send({ user });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const socialSignIn = async (req, res) => {
  try {
    const { socialToken } = req.body;
    const { token, user } = await userService.socialSignIn(socialToken);
  
    res.status(200).send({ success: true, token: token, user: user });
  } catch (error) {
    console.log(error.message)
    res.status(404).send({ success: false, message: error.message });
  }
}

const logout = async (req, res) => {
  const bearerHeader = req.headers['authorization'];
  try {
    const userId = await authorizationService.authorizeToken(bearerHeader);
    const message = await userService.logout(userId);
    res.status(200).send({ success: true, message: message });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const getUser = async (req, res) => {
  const bearerHeader = req.headers['authorization'];
  try {
    const userId = await authorizationService.authorizeToken(bearerHeader);
    const user  = await userService.getUser(userId);
    res.status(200).send({ success: true, user: user });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

const editProfile = async (req, res) => {
  const bearerHeader = req.headers['authorization'];
  try {
    const userId = await authorizationService.authorizeToken(bearerHeader);
    const { firstName, lastName, email } = req.body;
    const user  = await userService.editProfile(userId, firstName, lastName, email);
    res.status(200).send({ success: true, user: user });
  } catch (error) {
    console.log(error.message);
    res.status(404).send({ success: false, message: error.message });
  }
};

module.exports = {
  signUp,
  login,
  socialSignIn,
  logout,
  getUser,
  editProfile
};
