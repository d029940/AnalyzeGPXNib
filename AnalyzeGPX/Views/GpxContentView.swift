//
//  GpxContentView.swift
//  AnalyzeGPX
//
//  Created by Manfred on 22.01.20.
//  Copyright © 2020 Manfred Kern. All rights reserved.
//

import Cocoa

class GpxContentView: NSView, LoadableView {
    
    // Confirm to Loadable protocol
    var mainView: NSView?

    // MARK: - Outlets
    @IBOutlet weak var tracksTableView: NSTableView!
    @IBOutlet weak var routesTableView: NSTableView!
    @IBOutlet weak var waypointsTableView: NSTableView!
    
    // MARK:- Model
    var garminGpx: GarminGpx?
    
    // MARK:- local variables
    private var tracksColumnTitle = ""
    private var routesColumnTitle = ""
    private var waypointsColumnTitle = ""

    
    // MARK: - Start up
    
    override init(frame frameRect: NSRect) {
        super.init(frame: NSRect.zero)
        
        guard load(fromNIBNamed: "GpxContentView") else { return }

        guard let mainView = mainView else { return }
        for view in mainView.subviews {
            print(view.identifier?.rawValue)
        }
        
        
        // Connect delegates to tableview
        tracksTableView.delegate = self
        tracksTableView.dataSource = self
        routesTableView.delegate = self
        routesTableView.dataSource = self
        waypointsTableView.delegate = self
        waypointsTableView.dataSource = self
        
        // Get title from columns stored in the nib
        tracksColumnTitle = tracksTableView.tableColumns[0].title
        routesColumnTitle = routesTableView.tableColumns[0].title
        waypointsColumnTitle = waypointsTableView.tableColumns[0].title
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

}

// MARK:- Extensions for NSTableView

extension GpxContentView: NSTableViewDataSource {
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        // There is only one column in the table
        let column = tableView.tableColumns[0]
        if tableView == tracksTableView {
            let count = garminGpx?.tracks.count ?? 0
                if count == 0 {
                    column.title = tracksColumnTitle
                } else {
                    column.title = "\(tracksColumnTitle) (\(count))"
                }
            return count
        }
        if tableView == routesTableView {
            let count = garminGpx?.routes.count ?? 0
            if count == 0 {
                column.title = routesColumnTitle
            } else {
                column.title = "\(routesColumnTitle) (\(count))"
            }
            return count
        }
        if tableView == waypointsTableView {
            let count = garminGpx?.waypoints.count ?? 0
            if count == 0 {
                column.title = waypointsColumnTitle
            } else {
                column.title = "\(waypointsColumnTitle) (\(count))"
            }
            return count
        }
        return 0
    }
}

extension GpxContentView: NSTableViewDelegate  {
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let element: String
        guard let garminGpx = garminGpx else { return nil }
        if tableView == tracksTableView {
            element = garminGpx.tracks[row]
        } else if tableView == routesTableView {
            element = garminGpx.routes[row]
        } else if tableView == waypointsTableView {
            element = garminGpx.waypoints[row]
        } else {
            return nil
        }
        
        let cellIdentifier = NSUserInterfaceItemIdentifier(rawValue: "cell")
        guard let cellView = tableView.makeView(withIdentifier: cellIdentifier,
                                                owner: self) as? NSTableCellView else {
            return nil
        }
        cellView.textField?.stringValue = element
        return cellView
    }
}
