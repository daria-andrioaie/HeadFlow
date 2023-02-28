// require('dotenv').config();
// const db = require('./config/db.js');
// db();
// var createError = require('http-errors');
// var express = require('express');
// var path = require('path');
// var cookieParser = require('cookie-parser');
// var logger = require('morgan');
// const port = 3000;

// // const authRouter = require('./routes/auth');

// var app = express();

// app.use(logger('dev'));
// app.use(express.json());
// app.use(express.urlencoded({ extended: false }));
// app.use(cookieParser());
// app.use(express.static(path.join(__dirname, 'public')));

// // app.use('/api/auth', authRouter);

// app.use(function (req, res, next) {
//     next(createError(404));
//   });
  
//   // error handler
//   app.use(function (err, req, res, next) {
//     // set locals, only providing error in development
//     res.locals.message = err.message;
//     res.locals.error = req.app.get('env') === 'development' ? err : {};
  
//     // render the error page
//     res.status(err.status || 500);
//     res.render('error');
//   });

// app.listen(port, () => {
//   console.log(`Example app listening at http://localhost:${port}`);
// });

//   module.exports = app;

const express = require("express");
const bodyParser = require("body-parser");

const userRoute = require("./route/user.route");
const otpRoute = require("./route/otp.route");

const path = require("path");
require("dotenv").config();

const app = express();

app.use(bodyParser.json());

app.use("/api/v1/user", userRoute);
app.use("/api/v1/otp", otpRoute);

module.exports = app;