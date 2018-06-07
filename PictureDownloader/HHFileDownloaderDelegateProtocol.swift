//
//  HHSFileDownloaderEXDelegateProtocol.swift
//  URLSessionTest
//
//  Created by Holger Hinzberg on 13.08.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//

import Foundation

protocol  HHFileDownloaderDelegateProtocol
{
    func downloadWebpageHtmlAsyncCompleted(htmlSource:String)
    func downloadFileAsyncCompleted(fileLocation:String)
    func downloadItemAsyncCompleted(item:HHDownloadItem)
    func downloadError(message:String)
}
