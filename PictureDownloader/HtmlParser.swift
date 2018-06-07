//
//  HtmlParser.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 27.10.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.
//

import Cocoa

public class HtmlParser: NSObject
{
    public var startString:String = ""
    public var endString:String = ""
    public var filetypeString:String = ""
    public var removeCharactersFromStart = 0
    public var addCharactersAtEnd:Int = 0
    
    public func getImageArray(sourceParam:String) -> ([String])
    {
        var source = sourceParam
        
        var imageArray = [String]()
        var imageLink = self.getNextImageLink(sourceParam: source)
        
        while imageLink != nil
        {
            imageArray.append(imageLink!)
            
            // den Bekannten ImageLink aus dem Code entfernen
            if let imageLink = imageLink
            {
                source = source.replacingOccurrences(of: imageLink, with: "")
            }
            
            imageLink = self.getNextImageLink(sourceParam: source)
        }
      
        return imageArray
    }
    
    private func getNextImageLink(sourceParam:String) -> (String?)
    {
        var source = sourceParam
        
        // Anfang abschneiden
        var theRange = source.range(of: self.startString, options: NSString.CompareOptions.caseInsensitive)
        if theRange != nil
        {
            //source = source.substring(from: theRange!.lowerBound)
            source = String(source[theRange!.lowerBound...])
        }
        else
        {
            return nil;
        }
        
        // Ende abschneiden
        theRange = source.range(of:self.endString, options: NSString.CompareOptions.caseInsensitive)
        if theRange != nil
        {
            // source = source.substring(to: theRange!.lowerBound)
            source  = String(source[..<theRange!.upperBound])
        }
        else
        {
            return nil;
        }
        
        // Beliebige Anzahl von zeichem vom Start abscheiden
        // Eigene Methode aus HHSStringHelper
        source = source.substringRightFrom(characterCount: self.removeCharactersFromStart)
        
        return source
    }
    
    public func cutStringBetween(sourceParam:String, startString:String, endString:String) -> (String)
    {
        var source = sourceParam
        
        let startRange = source.range(of: startString, options: NSString.CompareOptions.caseInsensitive)
        if startRange != nil
        {
            //source = source.substring(from: startRange!.upperBound)
            source = String(source[startRange!.upperBound...])
            let endRange = source.range(of: endString, options: NSString.CompareOptions.caseInsensitive)
            if endRange != nil
            {
                //source = source.substring(to: endRange!.lowerBound)
                source  = String(source[..<endRange!.lowerBound])
                return source
            }
        }
        return ""
    }
    
    
}
