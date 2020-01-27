//
//  Empty.swift
//  AnalyzeGPX
//
//  Created by Manfred on 22.01.20.
//  Copyright © 2020 Manfred Kern. All rights reserved.
//

import Cocoa

class Empty: NSView, LoadableView {
    
    var mainView: NSView?

    override init(frame frameRect: NSRect) {
        super.init(frame: NSRect.zero)
        
        if load(fromNIBNamed: "Empty") {
            // TOOD: some more init
        }
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
}
