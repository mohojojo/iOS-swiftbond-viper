//
//  ListCellViewModel.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 05. 02..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import Bond

class ListCellViewModel {

    let content: Observable<String>
    
    init(content: String) {
        self.content = Observable(content)
    }
}
