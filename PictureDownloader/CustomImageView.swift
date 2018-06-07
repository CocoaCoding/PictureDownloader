//
//  CustomImageView.swift
//  CollectionViewDemo
//
//  Created by Holger Hinzberg on 20.06.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.
//

import Cocoa

class CustomImageView: NSImageView
{
    override func draw(_ dirtyRect: NSRect)
    {
        super.draw(dirtyRect)
        self.wantsLayer = true
        self.layer?.borderWidth = 0.0
        self.layer?.cornerRadius = 0.0
        self.layer?.masksToBounds = true
        self.layer?.borderColor = NSColor.red.cgColor
    }
}
