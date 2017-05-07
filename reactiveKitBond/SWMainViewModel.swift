//
//  CarModel.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 04. 28..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import Bond
import Foundation

class SWMainViewModel {
    
    var persons = MutableObservableArray<Person>([])
    var twoWayText = Observable<Int?>(8)
    var viewWidth = Observable<CGFloat?>(40)
    var viewOrigin = Observable<CGPoint>(CGPoint(x: 100, y: 20))
    
    init() {
    }
}
