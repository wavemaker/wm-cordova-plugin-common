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
import UIKit
import SwiftUI

public class WMDatePickerConfig {
    private static let _100Years: Double = 100 * 365 * 24 * 60 * 60;
    public var selectedDate = Date();
    public var mode = "DATE";
    public var minDate = Date().addingTimeInterval(-1 * _100Years);
    public var maxDate = Date().addingTimeInterval(_100Years);
    public var title = "Select Date";
}

struct DatePickerView: View {
    @State public var selectedDate: Date = Date();
    var minDate: Date = Date();
    var maxDate: Date = Date();
    var title = "Select Date";
    var mode = "DATE_TIME";
    var onComplete: ((_ type: String, _ date: Date?) -> ())? = nil;
    
    var body: some View {
        VStack{
            VStack{
                Text(title).font(.system(size: 16, weight: .bold, design: .default)).frame(maxWidth: .infinity, alignment: .leading)
                if (self.mode == "TIME") {
                    DatePicker(
                        self.title,
                        selection: $selectedDate,
                        in: self.minDate...self.maxDate,
                        displayedComponents: [.hourAndMinute]
                    )
                    .datePickerStyle(.wheel)
                } else {
                    if #available(iOS 14.0, *) {
                        DatePicker(
                            self.title,
                            selection: $selectedDate,
                            in: self.minDate...self.maxDate,
                            displayedComponents: self.mode == "DATE" ? [.date] : [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.graphical)
                    } else {
                        DatePicker(
                            self.title,
                            selection: $selectedDate,
                            in: self.minDate...self.maxDate,
                            displayedComponents: self.mode == "DATE" ? [.date] : [.date, .hourAndMinute]
                        )
                        .datePickerStyle(.wheel)
                    }
                }
                HStack(alignment: .center, spacing: 10, content: {
                    Button("Reset", action: {
                        (self.onComplete!)("RESET", nil);
                    }).frame(maxWidth: .infinity, alignment: .leading)
                    Button("Ok", action: {
                        (self.onComplete!)("OK", self.selectedDate);
                    }).frame(maxWidth: .infinity, alignment: .trailing)
                })
            }.frame(maxWidth: 320, alignment: .center).padding(16)
        }.background(Color(UIColor.systemBackground)).cornerRadius(8)
    }
}

public class WMDatePicker {
    var cdvPlugin: CDVPlugin;
    var onComplete: ((_ type: String, _ date: Date?) -> ())? = nil;
    
    init(cdvPlugin: CDVPlugin) {
        self.cdvPlugin = cdvPlugin;
    }
    
    @objc func onOutsideClick(_ sender: UITapGestureRecognizer? = nil) {
        self.onComplete?("CANCEL", nil);
    }
    
    @objc
    public func selectDate(command: CDVInvokedUrlCommand) {
        let options = command.argument(at: 0) as! [String: NSObject];
        let vc = cdvPlugin.viewController!;
        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light));
        visualEffectView.frame = vc.view.bounds;
        vc.view.addSubview(visualEffectView);
        let config = WMDatePickerConfig();
        if (options["selectedDate"] != nil) {
            config.selectedDate = Date(timeIntervalSince1970: (options["selectedDate"] as! Double) / 1000);
        }
        if ((options["minDate"]) != nil
            && (options["minDate"] as! Double) != 0) {
            config.minDate = Date(timeIntervalSince1970: (options["minDate"] as! Double) / 1000);
        }
        if (options["maxDate"] != nil
            && (options["maxDate"] as! Double) != 0) {
            config.maxDate = Date(timeIntervalSince1970: (options["maxDate"] as! Double) / 1000);
        }
        if (options["mode"] != nil) {
            config.mode = options["mode"] as! String;
        }
        if (options["title"] != nil) {
            config.title = options["title"] as! String;
        } else {
            if (config.mode == "TIME") {
                config.title = "Select Time";
            } else if (config.mode == "DATE_TIME") {
                config.title = "Select Date & Time";
            }
        }
        var viewToRemove: UIViewController? = nil;
        self.onComplete = {(type: String, date: Date?) in
            let result = CDVPluginResult(status: CDVCommandStatus_OK, messageAs: [
                    "type": type,
                    "date": (date?.timeIntervalSince1970 ?? 0) * 1000 as Any
                ]);
            viewToRemove?.view.removeFromSuperview();
            visualEffectView.removeFromSuperview();
            viewToRemove?.removeFromParent();
            self.cdvPlugin.commandDelegate.send(result, callbackId: command.callbackId);
        }
        let child = UIHostingController(rootView: DatePickerView(
            selectedDate: config.selectedDate,
            minDate: config.minDate,
            maxDate: config.maxDate,
            title: config.title,
            mode: config.mode,
            onComplete: {(type, date) in self.onComplete?(type, date)}
        ));
        viewToRemove = child;
        child.view.frame = CGRect(x: 0, y: 0, width: vc.view.frame.width, height: vc.view.frame.height);
        /*child.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onOutsideClick(_:))));*/
        child.view.backgroundColor = UIColor(white: 0.3, alpha: 0.3);
        vc.view.addSubview(child.view);
        vc.addChild(child);
    }
}
