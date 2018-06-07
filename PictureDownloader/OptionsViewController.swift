//
//  OptionsViewController.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 17.01.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.

import Cocoa

class OptionsViewController: NSViewController
{
    @IBOutlet var imagePathTextField: NSTextField!
    private var imagePathString = ""
    let imagePathKey = "imagepath"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do view setup here.
        let defaults = UserDefaults.standard
        let data:AnyObject? = defaults.object(forKey: imagePathKey) as AnyObject
        if data != nil && data is String
        {
            let path = data as! String
            self.imagePathTextField?.stringValue = path
            self.imagePathString = path
        }
    }
    
    @IBAction func pickerButtonClicked(sender: AnyObject)
    {
        let initDictectory = NSURL(fileURLWithPath: self.imagePathString)
        
        let openPanel = NSOpenPanel()
        openPanel.canChooseDirectories = true
        openPanel.canChooseFiles = false
        openPanel.canCreateDirectories = false
        openPanel.allowsMultipleSelection = false
        openPanel.directoryURL = initDictectory as URL
        
        openPanel.begin{ (result) -> Void in
            
         if result.rawValue == NSFileHandlingPanelOKButton
         {
            // Das ausgewählte Stammverzeichniss
            let rootPath = openPanel.urls[0] 
            let rootString = rootPath.path
            self.imagePathTextField?.stringValue = rootString
            
            let defaults = UserDefaults.standard
            defaults.set(rootString, forKey: self.imagePathKey)
            }
        }
    }
    
}
