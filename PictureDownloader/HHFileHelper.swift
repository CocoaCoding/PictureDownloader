//
//  HHSFileHelper.swift
//  CollectionViewDemo
//
//  Created by Holger Hinzberg on 20.06.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.
//

import Foundation

public class HHFileHelper: NSObject
{
    class func getDocumentsDirectory() -> String
    {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentDirectory = paths[0] as String
        return documentDirectory
    }
    
    func checkIfFolderDoesExists(folder:String, doCreate:Bool) -> Bool
    {
        let isDir:UnsafeMutablePointer<ObjCBool>? = nil
        let exists = FileManager.default.fileExists(atPath: folder, isDirectory: isDir)
        
        if exists == false && doCreate == true
        {
            var error: NSError?
            do
            {
                try FileManager.default.createDirectory(atPath: folder, withIntermediateDirectories: true, attributes: nil)
            }
            catch let error1 as NSError
            {
                error = error1
            }
            
            if let error = error
            {
                    print(error.localizedDescription)
            }
        }
        return true
    }
    
    func copyItemAtPath(srcPath: String?, toPath dstPath: String?)
    {
        if let sourcePath = srcPath, let destinationPath = dstPath
        {
            let fileManager = FileManager.default
            do
            {
                try fileManager.copyItem(atPath: sourcePath, toPath: destinationPath)
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
    
    
    /*
    public func getDesktopUrl() -> NSURL
    {
        let desktopUrl = NSFileManager().URLsForDirectory(.DesktopDirectory, inDomains: .UserDomainMask).first as! NSURL
        return desktopUrl
    }
    
    public func getContentsOfDirectoryAtURL(directory:NSURL, withFileExtention extention:String ) -> [NSURL]
    {
        var content = [NSURL]()
        let files =  self.getContentsOfDirectoryAtURL(directory)
        
        for file in files
        {
            let a = file.pathExtension?.lowercaseString
            let b = extention.lowercaseString
            if (a == b)
            {
                content.append(file)
            }
        }
        return content
    }
    
    // Den kompletten Inhalt eines Verzeichnisses
    // Auch Ordner und verstecke Dateien
    public func getContentsOfDirectoryAtURL(directory:NSURL) -> [NSURL]
    {
        let fileManger = NSFileManager()
        var content = [NSURL]()
        
        let files =  try fileManger.contentsOfDirectoryAtURL(directory, includingPropertiesForKeys: nil, options: nil) as? [NSURL]
        if let files = files
        {
            for file in files
            {
                content.append(file)
            }
        }
        return content
    }
    
    // Alle Ordner unterhalb eines angegebenen Ordners holen
    // Funktioniert aus rekursiev mit Unterordnern
    public func getFolders(rootFolder:String) -> [NSURL]
    {
        var folderurl = NSURL(fileURLWithPath: rootFolder)
        var enumerator = getFolderEnumerator(folderurl!)

        var folders =  [NSURL]()
        
        while let url = enumerator?.nextObject() as? NSURL
        {
            folders.append(url)
        }
        return folders
    }
    
    private func getFolderEnumerator(directoryUrl:NSURL) -> NSDirectoryEnumerator?
    {
        let fileManger = NSFileManager()
        let keys = [NSURLIsDirectoryKey]
        
        let handler = {
            (url:NSURL!,error:NSError!) -> Bool in
            print(error.localizedDescription)
            print(url.absoluteString)
            return true
        }
        
        let enumarator = fileManger.enumeratorAtURL(
            directoryUrl, includingPropertiesForKeys:
            keys, options: NSDirectoryEnumerationOptions(), errorHandler:handler)
        
        return enumarator
    }
    */
}
