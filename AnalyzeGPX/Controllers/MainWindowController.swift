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
    @IBOutlet weak var tabView: NSTabView!
    
    // MARK:- Model
    let garminGpx = GarminGpx()
    
    // MARK: - Views managed by this controller
    var emptyView: Empty?
    var gpxContentView: GpxContentView?
    

    // MARK: - Start up
    
    override func windowDidLoad() {
        super.windowDidLoad()
        
        // Set up the Tab Views
        var index = tabView.indexOfTabViewItem(withIdentifier: "Devices")
        if index != NSNotFound {
            if let devicesTabView = tabView.tabViewItem(at: index).view {
                emptyView = Empty()
                emptyView?.add(toView: devicesTabView)
            }
        }
        index = tabView.indexOfTabViewItem(withIdentifier: "List of GPX files")
        if index != NSNotFound {
            if let listGpxTabView = tabView.tabViewItem(at: index).view {
                emptyView = Empty()
                emptyView?.add(toView: listGpxTabView)
            }
        }
        index = tabView.indexOfTabViewItem(withIdentifier: "GPX Content file")
        if index != NSNotFound {
            if let gpxContenTabView = tabView.tabViewItem(at: index).view {
                self.gpxContentView = GpxContentView()
                gpxContentView?.add(toView: gpxContenTabView)
            }
        }
    }
    
    // MARK: - Actions
    
    @IBAction func openGpxFile(_ sender: NSButton) {
        
            // clear current table view contents
            garminGpx.resetModel()
            
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
                
                do {
                    try garminGpx.parse(gpxFile: filename)
                } catch GarminGpx.ParseErrors.badFilename {
                    // TDOD: Alert
                    print("Failed to open gpx file")
                    return
                } catch {
                    // TDOD: Alert
                    print("Unknown error")
                }
                
                // if any table (trk, rte, wpt) is not empty switch to GPX content tab
                if garminGpx.tracks.count > 0 ||
                    garminGpx.routes.count > 0 ||
                    garminGpx.waypoints.count > 0  {
                    
                    let index = tabView.indexOfTabViewItem(withIdentifier: "GPX Content file")
                    if index != NSNotFound {
                        let gpxContentItem = tabView.tabViewItem(at: index)
                        
                        tabView.selectTabViewItem(at: index)
                        // TODO: error
                        if let contentView = gpxContentItem.view as? GpxContentView {
                            self.gpxContentView?.garminGpx = garminGpx
                            self.gpxContentView?.tracksTableView.reloadData()
                            self.gpxContentView?.routesTableView.reloadData()
                            self.gpxContentView?.waypointsTableView.reloadData()
                        }
                    }
                }
        }
    }
    
    @IBAction func loadDevice(_ sender: NSButton) {
    }
    
    @IBAction func exit(_ sender: NSButton) {
        NSApp.terminate(self)
    }
}
