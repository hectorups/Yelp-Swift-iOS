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
        case Relevance = 0, Distance, Rated
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init(baseURL: baseUrl, consumerKey: consumerKey, consumerSecret: consumerSecret)
        let oauthToken : BDBOAuthToken = BDBOAuthToken(token: accessToken, secret: tokenSecret, expiration: nil)
        requestSerializer.saveAccessToken(oauthToken)
    }
    
    func searchWithTerm(term: NSString, sort: Sort = Sort.Relevance, success: (operation: AFHTTPRequestOperation!,
        responseObject: AnyObject!) -> Void, failure: (operation: AFHTTPRequestOperation!,
        error: NSError!) -> Void) -> AFHTTPRequestOperation {
            let location = NSString(string: "San Francisco")
            let parameters = [
                "term": term,
//                "location": location,
                "ll": "37.770403,-122.403568",
                "sort": String(sort.hashValue)
            ]
            
            return GET("search", parameters: parameters, success: success, failure: failure)
    }
    
}