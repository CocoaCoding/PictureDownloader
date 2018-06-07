//
//  ImagePreviewViewController.swift
//  PictureDownloaderSwift
//
//  Created by Holger Hinzberg on 17.05.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.
//

import Cocoa

class ImagePreviewViewController: NSViewController
{
    @IBOutlet var collectionView:NSCollectionView?
    
    public var imagesArray:[ImageInfo]!
    
    override func awakeFromNib()
    {
        if imagesArray == nil
        {
            self.imagesArray = [ImageInfo]()
        }
    }
    
    override func viewDidLoad()
    {
        let itemPrototype = self.storyboard?.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "colViewItem")) as! NSCollectionViewItem
        self.collectionView?.itemPrototype = itemPrototype
        super.viewDidLoad()
    }
    
    func setImage(image:NSImage?)
    {
        let img = ImageInfo()
        img.image = image
        // self.arrayController?.insert(img, atArrangedObjectIndex: 0)
    }
    
    func numberOfSections(in collectionView: NSCollectionView) -> Int
    {
        return 1 // imageDirectoryLoader.numberOfSections
    }
    
    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.imagesArray.count
    }
    
    func collectionView(_ itemForRepresentedObjectAtcollectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem
    {
        let item = collectionView?.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionViewItem"), for: indexPath)
        /*
        guard let collectionViewItem = item as? CollectionViewItem else {return item!}
        
        let imageFile = imagesArray![indexPath.section  ]
        collectionViewItem.imageFile = imageFile
        */
        return item!
    }
}
