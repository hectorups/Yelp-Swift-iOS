//
//  YelpClient.swift
//  Yelp
//
//  Created by Hector Monserrate on 18/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import Foundation

class YelpClient : BDBOAuth1RequestOperationManager {
    
    let baseUrl = NSURL(string: "http://api.yelp.com/v2/")
    let consumerKey = "t_K5cdIGNqK71AAncPHmxw"
    let consumerSecret = "vyHIZ4bEEyrmh_Lq8UPmYu0Rvdk"
    let accessToken = "dKVRn7jMu7ci1vBvNRpcJgsxmXyYJcl3"
    let tokenSecret = "eKi3M8SPHF67sra_jk0edvj_uoM"
    
    enum Sort: Int {
        case Relevance = 0, Distance, Rated, Count
        
        func toText() -> String {
            switch self {
            case .Distance:
                return "Distance"
            case .Rated:
                return "Rated"
            default:
                return "Relevance"
            }
        }
    }
    
    enum Distance : Int {
        case Auto = 0, Hundred, Thousand, FiveThousand, Count
        
        func toText() -> String {
            switch self {
            case .Hundred:
                return "100"
            case .Thousand:
                return "1000"
            case .FiveThousand:
                return "5000"
            default:
                return "Auto"
            }
        }
        
        func toMeters() -> Int {
            switch self {
            case .Hundred:
                return 100
            case .Thousand:
                return 1000
            case .FiveThousand:
                return 5000
            default:
                return 1000
            }
        }
    }
    
    enum Cagegory : Int {
        case Active = 0, Arts, Auto, BeautySvc, Education, EventServices,
        FinantialServices, Food, Health, HomeServices, HotelsTravel, LocalFlavor,
        LocalServices, MassMedia, Nightlive, Pets, Professional, PublicServicesGovt,
        RealState, ReligiousOrgs, Restaurants, Shopping, Count
        
        func toText() -> String {
            let dictionary = ["Active Live", "Arts", "Auto", "Beauty", "Education", "Event Services",
                "Finantial Services", "Food", "Health", "Home Services", "Hotels Travel", "Local Flavor",
                "Local Services", "Mass Media", "Nightlive", "Pets", "Professional", "Public Services",
                "Real State", "Religious Orgs", "Restaurants", "Shopping"]
            
            return dictionary[self.hashValue]
        }
        
        func toApiText() -> String {
            let dictionary = ["active", "arts", "auto", "beauty", "education", "eventervices",
                "finantialservices", "food", "health", "homeservices", "hotelstravel", "localflavor",
                "localservices", "massmedia", "nightlive", "pets", "professional", "publicservices",
                "realstate", "religiousorgs", "restaurants", "shopping"]
            
            return dictionary[self.hashValue]
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
        let oauthToken : BDBOAuthToken = BDBOAuthToken(token: accessToken, secret: tokenSecret, expiration: nil)
        requestSerializer.saveAccessToken(oauthToken)
    }
    
    func searchWithFilters(searchFilter: SearchFilter, limit: Int, offset: Int,
        success: (operation: AFHTTPRequestOperation!,
        responseObject: AnyObject!) -> Void, failure: (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void) -> AFHTTPRequestOperation {
            
            var parameters = [
                "term": searchFilter.term,
                "ll": "37.770403,-122.403568",
                "sort": String(searchFilter.sort.hashValue),
                "limit": "\(limit)",
                "offset": "\(offset)"
            ]
            
            if !searchFilter.categories.isEmpty {
                let categories = searchFilter.categories.map({ (category: YelpClient.Cagegory) -> String in
                    category.toApiText()
                })
                parameters["category_filter"] = ",".join(categories)
            }
            
            if searchFilter.deals {
                parameters["deals_filter"] = "true"
            }
            
            if searchFilter.distance != YelpClient.Distance.Auto {
                parameters["radius_filter"] = "\(searchFilter.distance.toMeters())"
            }
            
            println("search with params: \(parameters)")
            
            return GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}