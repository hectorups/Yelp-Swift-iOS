//
//  SearchFilter.swift
//  Yelp
//
//  Created by Hector Monserrate on 21/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import Foundation

struct SearchFilter {
    var distance : YelpClient.Distance = YelpClient.Distance.Auto
    var sort : YelpClient.Sort = YelpClient.Sort.Relevance
    var deals = false
    var categories = Array<YelpClient.Cagegory>()
    var term = ""
    
    func hasCategory(selectedCategory: YelpClient.Cagegory) -> Bool {
        return categories.reduce(false, combine: { (res: Bool, category: YelpClient.Cagegory) -> Bool in
            res || selectedCategory == category
        })
    }
    
    func categoryIndex(selectedCategory: YelpClient.Cagegory) -> Int? {
        var result: Int?
        for (index, category) in enumerate(categories) {
            if selectedCategory == category {
                result = index
                break
            }
        }
        
        return result
    }
}