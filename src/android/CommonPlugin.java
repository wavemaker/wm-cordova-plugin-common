/*
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
 */
package com.wavemaker.cordova.plugin;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaPluginPathHandler;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.Manifest;
import android.util.Log;

public class CommonPlugin extends CordovaPlugin {
    private static final String TAG = "WM_COMMON";

    CordovaPluginPathHandler pathHandler;
    /**
     * Constructor.
     */
    public CommonPlugin() {
        Log.d(TAG, "WaveMaker Common instance created");
    }

    /**
     * Executes the request and returns PluginResult.
     *
     * @param action            The action to execute.
     * @param args              JSONArry of arguments for the plugin.
     * @param callbackContext   The callback id used when calling back into JavaScript.
     * @return                  True if the action was valid, false if not.
     */
    public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
        if ("getPreference".equals(action)) {
            JSONObject options = args.getJSONObject(0);
            String name = options.getString("name");
            callbackContext.success(this.preferences.getAll().get("name"));
        } else {
            return false;
        }
        return true;
    }


    @Override
    public CordovaPluginPathHandler getPathHandler() {
        if (this.pathHandler == null) {
            boolean prefixToWWWFiles = this.preferences.getBoolean("prefixToWWWFiles", true);
            this.pathHandler = new CordovaPluginPathHandler(new FilePathHandler(this.cordova.getContext(), prefixToWWWFiles));
        }
        return this.pathHandler;
    }
}