//
//  ListCellViewModel.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 05. 02..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import Foundation
import Bond

struct Person {
    
    var name: Observable<String>?
    var created: Observable<Date>?
    var height: Observable<Int>?
}

enum SerializationError: Error {
    case missing(String)
    case invalid(String, Any)
}

extension Person {
    init(json: [String: Any]) throws {
        // Extract name
        guard let name = json["name"] as? String else {
            throw SerializationError.missing("name")
        }
        
        // Extract and validate eye color
        guard let created = json["created"] as? String else {
            throw SerializationError.missing("created")
        }
        
        let dateFor: DateFormatter = DateFormatter()
        dateFor.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        let date: Date? = dateFor.date(from: "\(created)")
        
        // Extract and validate birth date
        guard let height = json["height"] as? String else {
            throw SerializationError.missing("height")
        }
        
        // Initialize properties
        self.name = Observable(name)
        self.created = Observable(date!)
        self.height = Observable(Int(height)!)
    }
}



