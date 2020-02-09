//
//  MainWindowController.swift
//  AnalyzeGPX
//
//  Created by Manfred on 22.01.20.
//  Copyright © 2020 Manfred Kern. All rights reserved.
//

import Cocoa

class MainWindowController: NSWindowController {
    
    override var windowNibName: NSNib.Name? {
        return "MainWindow"
    }
    
    // MARK: - Outlets
    @IBOutlet weak var mainSplitVoew: NSSplitView!
    @IBOutlet weak var gpxContentCustomView: NSView!
    @IBOutlet weak var filesOutlineView: FilesOutlineView!
    
    
    // MARK: - Views managed by this controller
    var devicesView: DevicesView?
    var gpxContentView: GpxContentView?
    

    // MARK: - Start up
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        gpxContentView = GpxContentView()
        gpxContentView?.add(toView: gpxContentCustomView)
    }
    
    // MARK: - Actions
    
    @IBAction func openGpxFile(_ sender: NSButton) {
        
        let openPanel = NSOpenPanel()
        openPanel.title = "Open Garmin GPX"
        openPanel.message = "Open Garmin gpx file"
        openPanel.allowsMultipleSelection = false
        openPanel.allowedFileTypes = ["gpx", "GPX"]
        if openPanel.runModal() == .OK {
            guard let filename = openPanel.urls.first else {
                // TDOD: Alert
                print("Failed to open gpx file")
                return
            }
            guard let gpxContentView = gpxContentView else { return }
            gpxContentView.fillTables(with: filename)
        }
    }
    
    @IBAction func loadDevice(_ sender: NSButton) {
        filesOutlineView.loadGarminDevices()
    }
    
    @IBAction func exit(_ sender: NSButton) {
        NSApp.terminate(self)
    }
}
