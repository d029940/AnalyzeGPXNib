//
//  DevicesViev.swift
//  AnalyzeGPX
//
//  Created by Manfred on 22.01.20.
//  Copyright © 2020 Manfred Kern. All rights reserved.
//

import Cocoa

// TODO: This class and corresponding XIB file no longer needed (since OutlineView)
class DevicesView: NSView, LoadableView {
    
    // Confirm to Loadable protocol
    var mainView: NSView?
    
//    // Table model
//    typealias VolumeEntry = (path: String, name: String)
//    var listOfVolumes = [VolumeEntry]()
    
    // Model
     var listOfVolumes = GarminGpxFiles.listOfVolumes

    // MARK: - Outlets
    
    @IBOutlet weak var deviceListTableView: NSTableView!
    
    // MARK: - Start up
    override init(frame frameRect: NSRect) {
        super.init(frame: NSRect.zero)
        
        guard load(fromNIBNamed: "DevicesView") else { return }
        
        // Connect delegates to tableview
        deviceListTableView.delegate = self
        deviceListTableView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}


// MARK:- Extensions for NSTableView

extension DevicesView: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return listOfVolumes.count
    }
}

extension DevicesView: NSTableViewDelegate  {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        
        guard let col = tableColumn?.identifier.rawValue else { return nil }
        if col == "Path" {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "path")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier,
                                                    owner: self) as? NSTableCellView else {
                                                        return nil
            }
//            cellView.textField?.stringValue = listOfVolumes[row].path
            cellView.textField?.stringValue = listOfVolumes[row].path.absoluteString
            return cellView
        } else if col == "Name" {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "name")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier,
                                                    owner: self) as? NSTableCellView else {
                                                        return nil
            }
            cellView.textField?.stringValue = listOfVolumes[row].name
            return cellView
        } else {
            return nil
        }
    }
    
}

