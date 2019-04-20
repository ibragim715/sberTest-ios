//
//  jsonDataModel.swift
//  sberTest
//
//  Created by Ибрагим on 19/04/2019.
//  Copyright © 2019 Ибрагим Мамадаев. All rights reserved.
//


import Foundation


struct Post {
    
    let id: String
    let lat: String
    let long: String
    
}


extension Post {
    
    init?(dict: NSDictionary) {
        guard
            let id = dict["Номер УС"] as? String,
            let lat = dict["lat"] as? String,
            let long = dict["long"] as? String
            else { return nil }
        
        self.id = id
        self.lat = lat
        self.long = long
    }
    
    
}
