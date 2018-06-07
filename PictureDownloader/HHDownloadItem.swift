//
//  HHSDownloadItemEX.swift
//  URLSessionTest
//
//  Created by Holger Hinzberg on 13.08.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Foundation

public class HHDownloadItem: NSObject
{
    public var isActiveForDownload:Bool = true
    public var imageUrl:String = ""
    public var imageName:String = ""
    // Pfad und Dateinamen vom gespeicherten Bild
    public var saveImagePath = ""
}
