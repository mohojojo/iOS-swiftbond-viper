//
//  CarModel.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 04. 28..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import Bond
import Foundation

class CarViewModel {
    
    let results = MutableObservableArray<CarModel>([])
    let tempName = Observable<String?>("")

    init() {
    }
}
