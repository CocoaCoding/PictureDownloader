//
//  MainViewController.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 17.01.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.

import Cocoa

class MainViewController: NSViewController, NSApplicationDelegate , NSUserNotificationCenterDelegate,
    HHFileDownloaderDelegateProtocol, NSTableViewDataSource, NSTableViewDelegate
{
    func downloadFileAsyncCompleted(fileLocation: String)
    {
        // Unused
    }
    
    @IBOutlet weak var progressLabel: NSTextField!
    @IBOutlet weak var progressIndicatior: NSProgressIndicator!
    @IBOutlet weak var tableView:NSTableView!
    
    var websiteRepo = WebsiteRepository()
    var clipboarcCheckTimer : Timer?
    var fileDownloader = HHFileDownloader()
    var urlGetter = PasteboardUrlGetter()
    var lastPasteboardUrl:String = ""
    var htmlSource:String = ""
    var downloadItemsArray = [HHDownloadItem]()
    var activeDownloadItemsArray = [HHDownloadItem]()
    var selectedItem:HHDownloadItem?
    var downloadIndex:Int = 0
    var originalArrayCount:Int = 0
    var isFirstTimerTick:Bool = true
    var previewWindowController:NSWindowController?
    var previewViewController:ImagePreviewViewController?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.view.window?.title = "Blah"
        
        // Do view setup here.
        
        self.progressLabel.stringValue = "Bereit"
        let folder:String = self.checkOrCreateSaveFolder()
        self.fileDownloader.delegate = self
        self.fileDownloader.downloadFolder = folder
        
        NSUserNotificationCenter.default.delegate = self
        
        self.clipboarcCheckTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(MainViewController.tick), userInfo: nil, repeats: true)
        self.clipboarcCheckTimer?.fire()
    }
    
    override func viewDidAppear()
    {
        super.viewDidAppear()
        //self.view.window?.title = "changed label"
    }
    
    // MARK:- Actions Methoden
    
    @IBAction func previewWindowButtonClicked(sender: AnyObject)
    {
        let storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        self.previewWindowController = storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "Preview")) as? NSWindowController
        self.previewWindowController?.showWindow(self)
        self.previewViewController = self.previewWindowController?.contentViewController as? ImagePreviewViewController
    }
    
    @IBAction func clearButtonClicked(sender: AnyObject)
    {
        self.originalArrayCount = 0
        self.downloadItemsArray.removeAll(keepingCapacity: true)
        self.activeDownloadItemsArray.removeAll(keepingCapacity: true)
        self.tableView.reloadData()
        self.showQueCount()
        self.showBadgeCount()
    }
    
    @IBAction func downloadButtonClicked(sender: AnyObject)
    {
        self.downloadIndex = 0
        let activeItems = self.activeDownloadItemsArray
        let itemsCount:Int = activeItems.count
        self.originalArrayCount = itemsCount
        
        if itemsCount > 0
        {
            self.progressIndicatior.maxValue = Double(itemsCount)
            self.progressIndicatior.minValue = 0
            self.progressIndicatior.doubleValue = 0
            self.progressLabel.stringValue = ""
            
            self.downloadNextItem()
        }
        else
        {
            self.progressLabel.stringValue = "Keine aktiven ausgewählten Bilder"
            self.progressIndicatior.doubleValue = 0
        }
    }
    
    @IBAction func tableColumCellClicked(sender: NSButtonCell)
    {
        // println(self.selectedItem?.imageName)
        if let item = self.selectedItem
        {
            item.isActiveForDownload = !item.isActiveForDownload
            self.copyToActiveDownloadItems()
            self.tableView.reloadData()
            self.showQueCount()
            self.showBadgeCount()
        }
    }
    
    // MARK:-
    
    func checkOrCreateSaveFolder() -> (String)
    {
        var folder:String = ""
        
        let imagePath = "imagepath"
        let defaults = UserDefaults.standard
        let data:AnyObject? = defaults.object(forKey: imagePath) as AnyObject
        if data != nil && data is String
        {
            folder = data as! String
        }
        else
        {
            folder = NSHomeDirectory()
            folder += "Desktop/Playboy"
        }
        
        let fileHelper = HHFileHelper()
        var _ = fileHelper.checkIfFolderDoesExists(folder: folder, doCreate: true)
        
        return folder
    }
    
    @objc func tick()
    {
        //let currentPasteboardUrl:String =  "http://www.playboyblog.com/2016/06/shawn-dillon-rocks-her-sweet-brown-bikini/"
        // Die aktuelle Url aus der Zwischenablage holen
       let currentPasteboardUrl:String = self.urlGetter.getPastboardUrl()
        
        // Url nicht leer und unterschiedlich zur letzten Zwischenablage?
        if !currentPasteboardUrl.isEmpty && currentPasteboardUrl != self.lastPasteboardUrl
        {
            NSSound.beep()
            self.lastPasteboardUrl = currentPasteboardUrl
            
            let validation = self.fileDownloader.validate(string: currentPasteboardUrl)
            if  validation.isValid == true
            {
                self.fileDownloader.downloadWebpageHtmlAsync(url: validation.url!)
            }
            else
            {
                if self.isFirstTimerTick == false
                {
                    let alert = NSAlert()
                    alert.messageText = "Invalid Data"
                    alert.informativeText = "\(currentPasteboardUrl) \ncould not be validated."
                    alert.runModal()
                }
            }
        }
        
        self.isFirstTimerTick = false
    }
    
    func downloadWebpageHtmlAsyncCompleted(htmlSource: String)
    {
        // Html Quelltext der url wurde herunter geladen
        if htmlSource.isEmpty
        {
            let alert = NSAlert()
            alert.messageText = "No HTML found"
            alert.informativeText = "No valid HTML source could be found on loaded URL"
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
        }
        else
        {
            self.htmlSource = htmlSource
            self.analyseFiles()
        }
    }
    
    func analyseFiles()
    {
        let items:[WebsiteRepositoryItem] = self.websiteRepo.getItemForIdentification(ident: self.htmlSource)
        
        if items.count == 0
        {
            let alert = NSAlert()
            alert.messageText = "Missing Information"
            alert.informativeText = "No matching Repository Items found for Page"
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
        }
        else
        {
            var found = false;
            
            for item in items
            {
                print("Matching Repository found \(item.identification)")
                
                let htmlParser = HtmlParser()
                htmlParser.startString = item.startString
                htmlParser.endString = item.endString
                htmlParser.filetypeString = item.filetypeString
                htmlParser.removeCharactersFromStart = item.removeCharactersFromStart
                htmlParser.addCharactersAtEnd = item.addCharactersAtEnd
                let imgArray = htmlParser.getImageArray(sourceParam: self.htmlSource)
                let pageTitle = htmlParser.cutStringBetween(sourceParam: self.htmlSource, startString: "<title>", endString: "</title>")
                
                if imgArray.count > 0
                {
                    createDownloadItems(pageTitle: pageTitle, imageArray: imgArray)
                    found = true
                    break
                }
            }
            
            if found == false
            {
                let alert = NSAlert()
                alert.messageText = "No pictures found!"
                alert.informativeText = "No picture links found on this page."
                alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            }
        }
    }
    
    
    private func createDownloadItems(pageTitle:String, imageArray:[String]) -> ()
    {
        var number = 1
        var analysedDownloadItemsArray = [HHDownloadItem]()
        
        for  imageLink in imageArray
        {
            let downloadItem = HHDownloadItem()
            downloadItem.isActiveForDownload = true
            downloadItem.imageUrl = imageLink
            downloadItem.imageName = "\(pageTitle) \(number).jpg"
            analysedDownloadItemsArray.append(downloadItem)
            number += 1
        }
        
        let itemsCount = analysedDownloadItemsArray.count
        if itemsCount > 0
        {
            // Dem globalen Array hinzufügen
            for item in analysedDownloadItemsArray
            {
                self.downloadItemsArray.append(item)
            }
            
            // Update View
            self.copyToActiveDownloadItems()
            self.tableView.reloadData()
            self.showQueCount()
            self.showBadgeCount()
            
            // Meldung im Notificationcenter anzeigen
            let notification = NSUserNotification()
            notification.title = pageTitle
            notification.informativeText = "\(itemsCount) neue Adressen hinzugefügt"
            notification.soundName = nil
            NSUserNotificationCenter.default.deliver(notification)
        }
    }
    
    func downloadNextItem() -> ()
    {
        let item = self.activeDownloadItemsArray.first
        if let downloadItem = item
        {
            let displayIndex:Int = downloadIndex + 1
            self.progressIndicatior.doubleValue = Double(displayIndex)
            
            print("Lade \(Int(self.progressIndicatior.doubleValue)) von \(Int(self.progressIndicatior.maxValue)) Bildern")
            print("\(downloadItem.imageUrl)")
            
            // Progressbartext
            self.progressLabel.stringValue = "Lade \(displayIndex) von \(self.originalArrayCount). \(downloadItem.imageName)"
            // Badge Icon
            let remaining = self.originalArrayCount - downloadIndex
            let doc =  NSApp.dockTile as NSDockTile
            doc.badgeLabel = "\(remaining)"
            
            // Item laden
            self.fileDownloader.downloadItemAsync(item: downloadItem)
        }
    }
    
    // Delegate Aufruf
    func downloadItemAsyncCompleted(item: HHDownloadItem)
    {
        print(item.saveImagePath)
        
        if (self.previewViewController != nil)
        {
            let image:NSImage? = NSImage(contentsOfFile: item.saveImagePath)
            self.previewViewController?.setImage(image: image)
        }
        
        self.downloadIndex += 1
        self.activeDownloadItemsArray = activeDownloadItemsArray.filter( { $0 != item } )
        self.downloadItemsArray = downloadItemsArray.filter( { $0 != item } )
        self.tableView.reloadData()
        
        let itemsCount = activeDownloadItemsArray.count
        if itemsCount > 0
        {
            self.downloadNextItem()
        }
        else
        {
            self.progressIndicatior.doubleValue = 0;
            
            let message = "Download abgeschlossen"
            let info = "\(self.downloadIndex) Bilder geladen"
            self.progressLabel.stringValue = message
            
            let notification = NSUserNotification()
            notification.title = message
            notification.informativeText = info
            notification.soundName = nil
            NSUserNotificationCenter.default.deliver(notification)
            
            // Badge entfernen
            let doc =  NSApp.dockTile as NSDockTile
            doc.badgeLabel = ""
        }
    }
    
    // MARK:- TableView Methoden
    
    func numberOfRows(in tableView: NSTableView) -> Int
    {
        return self.downloadItemsArray.count
    }
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any?
    {
        let item = self.downloadItemsArray[row]
        
        if let identifier = tableColumn?.identifier
        {
            if identifier.rawValue == "active"
            {
                return item.isActiveForDownload as AnyObject
            }
            else if identifier.rawValue == "name"
            {
                return item.imageName as AnyObject
            }
            else if identifier.rawValue == "url"
            {
                return item.imageUrl as AnyObject
            }
        }
        return "" as AnyObject
    }
    
    func tableView(_ tableView: NSTableView, shouldEdit tableColumn: NSTableColumn?, row: Int) -> Bool
    {
            return false
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool
    {
        if row >= 0
        {
            let item = self.downloadItemsArray[row]
            self.selectedItem = item
        }
        else
        {
            self.selectedItem = nil
        }
        return true
    }
    
    func copyToActiveDownloadItems()
    {
        self.activeDownloadItemsArray.removeAll(keepingCapacity: true)
        for item in self.downloadItemsArray
        {
            if item.isActiveForDownload
            {
                self.activeDownloadItemsArray.append(item)
            }
        }
    }
    
    func showQueCount()
    {
        // Den aktuellen Count der Warteschlange anzeigen
        let itemsCount = self.activeDownloadItemsArray.count
        self.progressLabel.stringValue = "\(itemsCount) Bilder in der Warteschlange"
    }
    
    func showBadgeCount()
    {
        let itemsCount = self.activeDownloadItemsArray.count
        if itemsCount > 0
        {
            let doc =  NSApp.dockTile as NSDockTile
            doc.badgeLabel = "\(itemsCount)"
        }
        else
        {
            let doc =  NSApp.dockTile as NSDockTile
            doc.badgeLabel = ""
        }
    }
    
    func downloadError(message: String)
    {
        print(message)
    }
    
}
