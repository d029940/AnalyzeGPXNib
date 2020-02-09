//
//  FilesOutlineView.swift
//  AnalyzeGPX
//
//  Created by Manfred on 07.02.20.
//  Copyright © 2020 Manfred Kern. All rights reserved.
//

import Cocoa

class FilesOutlineView: NSOutlineView {

    // Model
     var listOfVolumes = GarminGpxFiles.listOfVolumes
    
    // MARK: - Start up
    
    // Loading from NIB
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        // Connect delegates to outlineview
        dataSource = self
    }

    
    
    // MARK: - Methods
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


// MARK:- Extensions for NSTableView

extension FilesOutlineView: NSOutlineViewDataSource {
    
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        if item == nil {
            return listOfVolumes.count
        } else {
            return 0
        }
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return true
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        return listOfVolumes[index]
    }
    
    func outlineView(_ outlineView: NSOutlineView, objectValueFor tableColumn: NSTableColumn?, byItem item: Any?) -> Any? {
        let node = item as? GarminGpxFiles.VolumeEntry
        return node?.name
    }

}
