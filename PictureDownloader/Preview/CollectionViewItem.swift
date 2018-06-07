//
//  CollectionViewItem.swift
//  PictureDesk
//
//  Created by Holger Hinzberg on 14.01.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Cocoa
class CollectionViewItem: NSCollectionViewItem
{
    var imageFile: ImageFile?
    {
        didSet
        {
            guard isViewLoaded else { return }
            if let imageFile = imageFile
            {
                imageView?.image = imageFile.thumbnail
                textField?.stringValue = imageFile.fileName
            }
            else
            {
                imageView?.image = nil
                textField?.stringValue = ""
            }
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor.white.cgColor
        view.layer?.borderColor = NSColor(red: 0.5, green: 0.5, blue: 1.0, alpha: 0.8).cgColor
        view.layer?.borderWidth = 0.0
    }
    
    override var isSelected: Bool
    {
        didSet
        {
            view.layer?.borderWidth = isSelected ? 2.0 : 0.0
        }
    }
    
}
