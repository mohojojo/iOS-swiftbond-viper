//
//  PersonCollectionViewCell.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 05. 07..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import UIKit
import ReactiveKit
import Bond

class PersonCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var personName: UILabel!
    
}

extension ReactiveExtensions where Base: UICollectionViewCell {
    var width: Bond<CGFloat?> {
        return bond { view, width in
            view.frame.size.width = width!
        }
    }
    
    var origin: Bond<CGPoint?> {
        return bond { view, origin in
            view.frame.origin = origin!
        }
    }
}
