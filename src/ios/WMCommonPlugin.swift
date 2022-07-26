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


import Foundation
@available(iOS 13, *)
@objc(WMCommonPlugin)
public class WMCommonPlugin: CDVPlugin {
    
    @objc
    public func execute(_ command: CDVInvokedUrlCommand) {
        let options = command.argument(at: 0) as! [String: NSObject];
        let service = options["service"] as! String;
        let operation = options["operation"] as! String;
        if (service == "DATE_PICKER") {
            if #available(iOS 14, *) {
                if (operation == "selectDate") {
                    WMDatePicker(cdvPlugin: self).selectDate(command: command);
                }
            }
        } else {
            let result = CDVPluginResult(status: CDVCommandStatus_INVALID_ACTION);
            self.commandDelegate.send(result, callbackId: command.callbackId);
        }
    }
}
