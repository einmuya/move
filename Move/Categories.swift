//
//  Categories.swift
//  Move
//
//  Created by einmuya on 7/29/17.
//  Copyright © 2017 Crafted. All rights reserved.
//

import UIKit

class Categories{
    
    // MARK: Properties
    var categoryId: Int
    var createdDate: Int
    var updatedDate: Int
    var categoryTitle: String
    var categoryImage: String
    
    
    
    init(categoryId: Int, createdDate: Int, updatedDate: Int, categoryTitle: String, categoryImage: String){
        
        // Initialize stored properties
        self.categoryId = categoryId
        self.createdDate = createdDate
        self.updatedDate = updatedDate
        self.categoryTitle = categoryTitle
        self.categoryImage = categoryImage
        
    }
}
