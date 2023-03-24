const SessionModel = require("../model/session.model");
const jwt = require("jsonwebtoken");
const jwtKey = process.env.JWT_SECRET;

const authorizeToken = async (bearerHeader) => {
    if(typeof bearerHeader === 'undefined') {
        throw new Error("Authorization failed.");
      }
    
      const token = bearerHeader.split(" ")[1];
      if (!token) {
        throw new Error("Authorization failed.");
      }

    const decodedToken = jwt.verify(token, jwtKey);
  
    let existingToken = await SessionModel.findOne({ token: token });
    if (existingToken) {
      return existingToken.userId
    } else {
      throw new Error("Authorization failed.");
    }
  };


module.exports = {
  authorizeToken,
};
