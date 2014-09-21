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
    var category : YelpClient.Cagegory = YelpClient.Cagegory.Auto
    var term = ""
}