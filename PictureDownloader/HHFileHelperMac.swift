//
//  HHSFileHelperMac.swift
//  SimpleDownloader
//
//  Created by Holger Hinzberg on 12.02.18.
//  Copyright © 2018 Holger Hinzberg. All rights reserved.
//

import Cocoa

class HHFileHelperMac: NSObject
{
    public func getDesktopUrl() -> URL
    {
        let paths = NSSearchPathForDirectoriesInDomains(.desktopDirectory, .userDomainMask, true)
        //let desktopUrl = FileManager.URLsForDirectory(.desktopDirectory, inDomains: .UserDomainMask).first as! NSURL
        return URL.init(fileURLWithPath: paths[0])
    }
}
