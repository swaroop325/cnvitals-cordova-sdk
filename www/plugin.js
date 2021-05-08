
var exec = require('cordova/exec');

var PLUGIN_NAME = 'CNVitals';

var CNVitals = {
  getVitals: function (successCallback, failureCallback, phrase) {
    exec(successCallback, failureCallback, PLUGIN_NAME, "getVitals", [phrase]);
  },
};

module.exports = CNVitals;
