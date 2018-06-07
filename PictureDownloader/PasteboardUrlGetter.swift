//
//  PasteboardUrlGetter.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 26.10.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.
//

import Cocoa

public class PasteboardUrlGetter: NSObject
{
    public func getPastboardUrl() -> String
    {
        var returnString:String = ""
        let pasteboard = NSPasteboard.general
        
        if let text = pasteboard.pasteboardItems?[0].string(forType: NSPasteboard.PasteboardType(rawValue: "public.utf8-plain-text"))
        {
            returnString = text
        }
        return returnString
    }
}
