//
//  ListCellViewModel.swift
//  reactiveKitBond
//
//  Created by Mogyoródi Balázs on 2017. 05. 02..
//  Copyright © 2017. Mogyoródi Balázs. All rights reserved.
//

import Foundation
import Bond
import ObjectMapper

struct CarModel : Mappable {

    var type: Observable<String>?
    var color: Observable<UIColor>?
    var year: Observable<Int>?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        type       <- (map["type"], BindStringTransfrom())
        color     <- (map["color"], BindColorTransfrom())
        year     <- (map["year"], BindIntTransfrom())
    }
}

class BindStringTransfrom: TransformType {
    public typealias Object = Observable<String>
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Observable<String>? {
        return Observable(value as! String)
    }
    
    open func transformToJSON(_ value: Observable<String>?) -> String? {
        if let str = value {
            return str.value
        }
        return nil
    }
}

class BindIntTransfrom: TransformType {
    public typealias Object = Observable<Int>
    public typealias JSON = Int
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Observable<Int>? {
        return Observable(value as! Int)
    }
    
    open func transformToJSON(_ value: Observable<Int>?) -> Int? {
        if let num = value {
            return num.value
        }
        return nil
    }
}

class BindColorTransfrom: TransformType {
    public typealias Object = Observable<UIColor>
    public typealias JSON = String
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> Observable<UIColor>? {
        return Observable(UIColor.green)
    }
    
    open func transformToJSON(_ value: Observable<UIColor>?) -> String? {
        if let color = value {
            return color.value.accessibilityValue
        }
        return nil
    }
}

