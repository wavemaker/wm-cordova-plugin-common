/*
*
* Licensed to the Apache Software Foundation (ASF) under one
* or more contributor license agreements.  See the NOTICE file
* distributed with this work for additional information
* regarding copyright ownership.  The ASF licenses this file
* to you under the Apache License, Version 2.0 (the
* "License"); you may not use this file except in compliance
* with the License.  You may obtain a copy of the License at
*
*   http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing,
* software distributed under the License is distributed on an
* "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
* KIND, either express or implied.  See the License for the
* specific language governing permissions and limitations
* under the License.
*
*/
    
var exec = require('cordova/exec');

///channel.createSticky('onCordovaInfoReady');
// Tell cordova channel to wait on the CordovaInfoReady event
//channel.waitForInitialization('onCordovaInfoReady');

/**
 * This represents the mobile device, and provides properties for inspecting the model, version, UUID of the
 * phone, etc.
 * @constructor
 */
function DatePicker () {

}

/**
 * Get device info
 *
 * @param {Function} successCallback The function to call when the heading data is available
 * @param {Function} errorCallback The function to call when there is an error getting the heading data. (OPTIONAL)
 */
DatePicker.prototype.selectDate = function(options, successCallback, errorCallback) {
    options && Object.keys(options).forEach(function(k) {
        if (!options[k]) {
            delete options[k];
        }
    });
    if (options.maxDate && options.minDate) {
        options.minDate = Math.min(options.minDate, options.maxDate);
    }
    exec(function(result) {
        if (result.type === 'CANCEL') {
            result.date = options.selectedDate;
        }
        result.date = result.date || undefined;
        successCallback && successCallback(result);
    }, errorCallback, 'WMCommonPlugin', 'execute', [Object.assign({
        service : "DATE_PICKER",
        operation : "selectDate"
    }, options)]);
};

module.exports = new DatePicker();
