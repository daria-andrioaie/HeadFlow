// var createError = require('http-errors');
// var cookieParser = require('cookie-parser');
// const port = 3000;

// app.use(logger('dev'));
// app.use(express.json());
// app.use(express.urlencoded({ extended: false }));
// app.use(cookieParser());
// app.use(express.static(path.join(__dirname, 'public')));


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

require("dotenv").config();
const express = require("express");
const bodyParser = require("body-parser");
const logger = require('morgan');
const path = require("path");

// Routes
const userRoute = require("./route/user.route");
const otpRoute = require("./route/otp.route");
const stretchesRoute = require("./route/stretches.route");
const healthcheckRoute = require('./route/healthchecker.route')

const app = express();

app.use(bodyParser.json());
app.use(logger('dev'))

app.use("/api/v1/user", userRoute);
app.use("/api/v1/otp", otpRoute);
app.use("/api/v1/stretching", stretchesRoute);

app.use('/healthcheck', healthcheckRoute);

module.exports = app;