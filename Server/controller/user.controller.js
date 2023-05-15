const userService = require("../service/user.service");
const authorizationService = require("../service/authorization.service");
const cloudinary = require('cloudinary').v2;
const cloud_name = process.env.CLOUDINARY_CLOUD_NAME;
const api_key = process.env.CLOUDINARY_API_KEY;
const api_secret = process.env.CLOUDINARY_API_SECRET;
cloudinary.config({
  cloud_name: cloud_name,
  api_key: api_key,
  api_secret: api_secret
});


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

const editProfilePicture = async (req, res) => {
  if (!req.file) {
    res.status(400).send({ success: false, message: 'No file uploaded.' });
    return;
  }

  const bearerHeader = req.headers['authorization'];
  try {
    const userId = await authorizationService.authorizeToken(bearerHeader);
    const result = await cloudinary.uploader.upload(req.file.path)
    const user = await userService.editProfilePicture(userId, result.secure_url);
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
  editProfile,
  editProfilePicture
};
