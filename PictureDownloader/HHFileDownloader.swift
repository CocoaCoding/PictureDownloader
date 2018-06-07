//
//  HHSFileDownloaderEX.swift
//  URLSessionTest
//
//  Created by Holger Hinzberg on 13.08.17.
//  Copyright © 2017 Holger Hinzberg. All rights reserved.
//
// https://www.raywenderlich.com/110458/nsurlsession-tutorial-getting-started

import Foundation

class HHFileDownloader: NSObject, URLSessionDownloadDelegate
{
    var delegate:HHFileDownloaderDelegateProtocol? // Delegate für Completion Handler
    
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask: URLSessionDataTask? // Für HTTP Get, HTML Source
    private var downloadTask:URLSessionDownloadTask? // Für File Download
    
    var downloadFolder = ""
    private var downloadFilename = "";
    private var downloadItem:HHDownloadItem?
    
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    // MARK: HTML Get Download
    
    public func downloadWebpageHtmlAsync(url:URL)
    {
       dataTask?.cancel()
        
        dataTask = defaultSession.dataTask(with: url)
        {
            data, response, error in
            
            if let error = error
            {
                print(error.localizedDescription)
            }
            
            if data != nil
            {
                let buffer = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                print(buffer ?? "Kein Buffer")
                
                if self.delegate != nil && buffer != nil
                {
                    DispatchQueue.main.async()
                        {
                            self.delegate?.downloadWebpageHtmlAsyncCompleted(htmlSource: buffer! as String)
                            () // Nicht in die gleiche Zeile wie der delegate-Aufruf
                            // Because delegate is optional type and can be nil, and every function or method
                            // in Swift must return value, for example Void!, (), you just need to add tuple () at the end of dispatch_async
                    }
                }
            }
        }
        dataTask?.resume()
    }
    
    // MARK: File Download
    
    public func downloadFileAsync(url:URL , downloadFolder:String , downloadFilename:String)
    {
       self.downloadFolder = downloadFolder
        self.downloadFilename = downloadFilename
        
        self.dataTask?.cancel()
        self.downloadItem = nil
        self.downloadTask = downloadsSession.downloadTask(with: url)
        self.downloadTask?.resume()
    }
    
    public func downloadItemAsync( item : HHDownloadItem)
    {
        self.downloadItem = item
        self.dataTask?.cancel()
        
        let url = NSURL(string: self.downloadItem!.imageUrl)
        if url != nil
        {
            downloadTask = downloadsSession.downloadTask(with: url! as URL)
            downloadTask?.resume()
        }
        else
        {
            let urlText = self.downloadItem?.imageUrl ?? "Item nil"
            self.delegate?.downloadError(message: urlText)
        }
    }
    
    // Completion Handler von NSURLSessionDownloadDelegate
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL)
    {
        // Dirketer Download über den Dateinamen
        if  self.downloadItem == nil
        {
            var fileLocation =  self.downloadFolder
            if self.downloadFolder.last != "/"
            {
                fileLocation += "/"
            }
            fileLocation += self.downloadFilename
            
            self.copyItemAtPath(srcPath: location.path, toPath: fileLocation)
            
            print("Finished downloading.")
            DispatchQueue.main.async()
            {
                    self.delegate?.downloadFileAsyncCompleted(fileLocation: fileLocation)
            }
        }
        else
        {
            // Download mit einem DownloadItem
            let urlText =  self.downloadFolder + "/" + self.downloadItem!.imageName
            self.downloadItem?.saveImagePath = urlText
            self.copyItemAtPath(srcPath: location.path, toPath: urlText)
            
            print("Finished downloading.")
            DispatchQueue.main.async()
                {
                    self.delegate?.downloadItemAsyncCompleted(item: self.downloadItem!)
            }
        }
    }
    
    
    func copyItemAtPath(srcPath: String?, toPath dstPath: String?)
    {
        if let sourcePath = srcPath, let destinationPath = dstPath
        {
            let fileManager = FileManager.default
            do
            {
               try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
                
                /*
                let fromURL = URL(fileURLWithPath: sourcePath)
                let toURL = URL(fileURLWithPath:destinationPath)
                try fileManager.copyItem(at: fromURL, to: toURL)
               */
            }
            catch let error as NSError
            {
                print("Could not copy \(dstPath ?? "Unknow Path") to disk: \(error.localizedDescription)")
            }
        }
        else
        {
            print("Filepath could not be unwrapped. Possible NULL")
        }
    }
    
    func validate(string:String?) -> (isValid:Bool, url:URL?)
    {
        guard let urlString = string else {return (false, nil)}
        guard let url = URL(string: urlString) else {return (false, nil)}
        return (true, url)
        /*
        let regEx = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
        let predicate = NSPredicate(format:"SELF MATCHES %@", argumentArray:[regEx])
        
        if predicate.evaluate(with: string) == true
        {
            return (true, url)
        }
        return (false, nil)
        */
    }
}
