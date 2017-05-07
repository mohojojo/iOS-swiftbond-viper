//
//  CanvasUICollectionViewLayout.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 05. 07..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import Foundation
import UIKit

protocol CanvasLayoutDelegate {
    func collectionView(collectionView: UICollectionView, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    func collectionView(collectionView: UICollectionView, originForItemAtIndexPath indexPath: NSIndexPath) -> CGPoint
}

class CanvasUICollectionViewLayout : UICollectionViewLayout {
    
    // 1
    var delegate: CanvasLayoutDelegate!
    
    private var cache = [UICollectionViewLayoutAttributes]()
    
    // 4
    private var contentHeight: CGFloat  = 1000
    private var contentWidth: CGFloat = 1000
    
    override func prepare() {
        // 1
        if cache.isEmpty {
            // 3
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = NSIndexPath(item: item, section: 0)
                
                let itemSize = delegate.collectionView(collectionView: collectionView!, sizeForItemAtIndexPath: indexPath)
                let itemOrigin = delegate.collectionView(collectionView: collectionView!, originForItemAtIndexPath: indexPath)
                
                let frame = CGRect(origin: itemOrigin, size: itemSize)

                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath as IndexPath)
                attributes.frame = frame
                cache.append(attributes)
            }
        }
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        cache.removeAll()
        
        // Call prepare layout to repopulate the cache based on the new number of items
        prepare()
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in cache {
            layoutAttributes.append(attributes)
        }
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return cache.first { $0.indexPath == indexPath }
    }
}
