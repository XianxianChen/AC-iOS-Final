//
//  Post.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import Foundation
struct Post: Codable {
    let imageURL: String
    let comment: String
    let userId: String?
    
    func toJosn() -> Any {
        let jsonData = try! JSONEncoder().encode(self)
        let object = try! JSONSerialization.jsonObject(with: jsonData, options: [])
        return object
    }
}
