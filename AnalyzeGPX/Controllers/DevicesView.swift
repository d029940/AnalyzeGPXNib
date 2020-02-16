//
//  DevicesViev.swift
//  AnalyzeGPX
//
//  Created by Manfred on 22.01.20.
//  Copyright © 2020 Manfred Kern. All rights reserved.
//

import Cocoa

// TODO: This class and corresponding XIB file no longer needed (since OutlineView)
class DevicesView: NSView, MKLoadableView {

    // MARK: - Conform to MKLoadable protocol
    var mainView: NSView?
    var nibName: String = "DevicesView"
    

    // MARK: - Outlets
    
    @IBOutlet weak var deviceListTableView: NSTableView!
    
    // MARK: - Start up
    override init(frame frameRect: NSRect) {
        super.init(frame: NSRect.zero)
        
        guard load() else { return }
        
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
        return GarminGpxFiles.allGpxFiles.count
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
            cellView.textField?.stringValue = GarminGpxFiles.allGpxFiles[row].path.absoluteString
            return cellView
        } else if col == "Name" {
            let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "name")
            guard let cellView = tableView.makeView(withIdentifier: cellIdentifier,
                                                    owner: self) as? NSTableCellView else {
                                                        return nil
            }
            cellView.textField?.stringValue = GarminGpxFiles.allGpxFiles[row].name
            return cellView
        } else {
            return nil
        }
    }
    
}

