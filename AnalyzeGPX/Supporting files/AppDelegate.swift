//
//  AppDelegate.swift
//  AnalyzeGPX
//
//  Created by Manfred on 22.01.20.
//  Copyright © 2020 Manfred Kern. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var mainWindowController: MainWindowController?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Create Window Controller
        let mainWindowController = MainWindowController()
        
        // Put the window of the window controller on the screen
        mainWindowController.showWindow(self)
        
        // Set the property to point to the main window controller
        self.mainWindowController = mainWindowController
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

