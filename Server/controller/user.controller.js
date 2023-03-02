const userService = require("../service/user.service");

const signUp = async (req, res) => {
  const user = await userService.signUp(req.body);
  
  console.log('/POST sign up user');
  res.status(200).send({ meta: 200, user });
};

module.exports = {
  signUp,
};