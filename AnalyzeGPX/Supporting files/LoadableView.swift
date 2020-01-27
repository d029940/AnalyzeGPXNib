//
//  LoadableView.swift
//
//  Created by Manfred Kern
//  Based on LoadableView.swift from https://www.appcoda.com/macos-custom-views/
//  Copyright © 2020 MK. All rights reserved.
//

import Cocoa


/** Loads a custom view from a NIB file
    Usage:
    1. Call load on nib file to load
    2. Add custom view from nib file to the parent view
 */
protocol LoadableView: class {
    
    /// Stores the (first) top level view in the nib file
    var mainView: NSView? { get set }
    
    /**
     Loads a nib file of a custom view
     
     - Parameter nibName: The name of the nib file to load
     - Returns: true if loaded successfully, otherwise false
     */
    func load(fromNIBNamed nibName: String) -> Bool
    
    /**
     Adds the the loaded custom view to its parent view
     - Parameter parentView: the view the loaded custom view should be added to
     */
    func add(toView parentView: NSView)
}

/// Default implementation for  LoadableView protocol
extension LoadableView where Self: NSView {
    
    func load(fromNIBNamed nibName: String) -> Bool {
        var nibObjects: NSArray?
        let nibName = NSNib.Name(stringLiteral: nibName)
        
        // Check if nib file exists and contains an NSView
        if Bundle.main.loadNibNamed(nibName, owner: self, topLevelObjects: &nibObjects) {
            guard let nibObjects = nibObjects else { return false }
            
            let viewObjects = nibObjects.filter { $0 is NSView }
            
            // It is possible, but bad practice to put non NSView controls directly on the canvas
            if viewObjects.count > 0 {
                guard let view = viewObjects[0] as? NSView else { return false }
                mainView = view
                self.addSubview(mainView!)
                
                // Resize custom view to fill the main view
                mainView?.translatesAutoresizingMaskIntoConstraints = false
                mainView?.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
                mainView?.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
                mainView?.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
                mainView?.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
                
                return true
            }
        }
        
        return false
    }
    
    func add(toView parentView: NSView) {
        parentView.addSubview(self)
        
        // Resize custom view to fill the parent view
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }
}
