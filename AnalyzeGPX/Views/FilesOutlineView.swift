//
//  FilesOutlineView.swift
//  AnalyzeGPX
//
//  Created by Manfred on 07.02.20.
//  Copyright © 2020 Manfred Kern. All rights reserved.
//

import Cocoa

class FilesOutlineView: NSOutlineView {
    
    // MARK: - Propertiey
    
    // Model
    var listOfVolumes = GarminGpxFiles.listOfVolumes
    var listOfGpxFiles = GarminGpxFiles.listOfGpxFiles
    
    // MARK: - Start up
    
    // Loading from NIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Connect delegates to outlineview
        dataSource = self
        delegate = self
    }
    
    
    
    // MARK: - Methods
    
    /// Searches for all Garmin/GPX folder on all mounted volumes case-insensitively and add them to treeview view
    func loadGarminDevices() {
        var errors = [NSError]()
        listOfVolumes = GarminGpxFiles.loadGarminDevices(errors: &errors)
        if errors.count > 0 {
            var errMsg = ""
            for error in errors {
                if !errMsg.isEmpty { errMsg.append("\n") }
                errMsg.append(error.localizedDescription)
            }
            let alert = NSAlert()
            alert.informativeText = errMsg
            alert.runModal()
            return
        }
        self.reloadData()
    }
}


// MARK:- Extensions for NSOutlineView

extension FilesOutlineView: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            // Top level: list volumes (devices)
            return listOfVolumes.count
        }
        return listOfGpxFiles.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        if item is GarminGpxFiles.VolumeEntry {
            // Only the top level (volumes / devices) is expandable
            return listOfVolumes.count > 0
        }
        return false
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        if item == nil {
            return listOfVolumes[index]
        } else {
            return listOfGpxFiles[index]
        }
    }
    
    //    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
    //        let node = item as? GarminGpxFiles.VolumeEntry
    //        return node?.name
    //    }
    
}
extension FilesOutlineView: NSOutlineViewDelegate {
    
    
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var view: NSTableCellView?
        
        if tableColumn!.identifier.rawValue == "name" {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "name"), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                if let volume = item as? GarminGpxFiles.VolumeEntry {
                    textField.stringValue = volume.name
                } else if let url = item as? URL {
                    textField.stringValue = url.lastPathComponent
                }
            }
        }
        if tableColumn!.identifier.rawValue == "path" {
            view = outlineView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "path"), owner: self) as? NSTableCellView
            if let textField = view?.textField {
                if let volume = item as? GarminGpxFiles.VolumeEntry {
                    textField.stringValue = volume.path.absoluteString
                } else if let url = item as? URL {
                    textField.stringValue = url.absoluteString
                }
            }
        }
        
        return view
    }
    
    func outlineViewSelectionDidChange(_ notification: Notification) {
        guard let outlineView = notification.object as? NSOutlineView else {
            return
        }

        let selectedIndex = outlineView.selectedRow
        if let volume = outlineView.item(atRow: selectedIndex) as? GarminGpxFiles.VolumeEntry {
            listOfGpxFiles = GarminGpxFiles.listGpxFiles(for: volume.path)
            self.reloadData()
            outlineView.expandItem(outlineView.item(atRow: selectedIndex))
            return
        }
//        if let url = outlineView.item(atRow: selectedIndex) as? URL {
//            // --> Splitview Controller --> Mainview Controller
//            guard let parentVC = self.parent.parent as? MainWindowController else { return }
//            guard let vc = parentVC.gpxContentVC else { return }
//            vc.fillTables(with: url)
//        }
    }
}



