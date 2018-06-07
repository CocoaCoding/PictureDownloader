//
//  WebsiteRepository.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 14.06.14.
//  Copyright (c) 2014 Holger Hinzberg. All rights reserved.
//

import Foundation

class WebsiteRepository
{
    var websites = [WebsiteRepositoryItem]()
    
    init()
    {
        var item = WebsiteRepositoryItem()
        item.identification = "http://www.playboyblog.com/wp-content";
        item.startString = "href=\'http://www.playboyblog.com/wp-content/uploads";
        item.endString = ".jpg";
        item.filetypeString = ".jpg";
        item.removeCharactersFromStart = 6;
        item.addCharactersAtEnd = 4
        websites.append(item)

        item = WebsiteRepositoryItem()
        item.identification = "http://www.centerfoldlist.com/feed/";
        item.startString = "href=\'http://www.centerfoldlist.com/galleries";
        item.endString = ".jpg";
        item.filetypeString = ".jpg";
        item.removeCharactersFromStart = 6;
        item.addCharactersAtEnd = 4;
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.identification = "http://www.babehub.com";
        item.startString = "href=\"http://cdn1.babehub.com/content";
        item.endString = ".jpg";
        item.filetypeString = ".jpg";
        item.removeCharactersFromStart = 6;
        item.addCharactersAtEnd = 4;
        websites.append(item)
        
        item = WebsiteRepositoryItem()
        item.identification = "http://pmatehunter.com";
        item.startString = "href=\"http://cdn1.pmatehunter.com/content";
        item.endString = ".jpg";
        item.filetypeString = ".jpg";
        item.removeCharactersFromStart = 6;
        item.addCharactersAtEnd = 4;
        websites.append(item)
        
    }
    
    func getItemForIdentification(ident:String) -> [WebsiteRepositoryItem]
    {
        var items = [WebsiteRepositoryItem]()
        
        for  item in self.websites
        {
            print(item.identification)
            
            if ident.caseInsensitiveContains(substring: item.identification)
            {
                items.append(item)
            }
        }
        return items;
    }
}
