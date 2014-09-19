//
//  ViewController.swift
//  Yelp
//
//  Created by Hector Monserrate on 18/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var businesses = [Business]()

    @IBOutlet weak var businessesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessesTableView.delegate = self
        businessesTableView.dataSource = self
        
        var client = YelpClient()
        
        let success = { (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) -> Void in
            
            let json = JSON(responseObject)
            
            for (i, v) in json["businesses"] {
                println(v)
                self.businesses.append(Business(fromJson: v))
            }
            
            self.businessesTableView.reloadData()
        }
        
        let failure = { (operation: AFHTTPRequestOperation!,
            error: NSError!) -> Void in
                println(error)
        }
        
        client.searchWithTerm("restaurant", sort: YelpClient.Sort.Relevance, success: success, failure: failure)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = businessesTableView.dequeueReusableCellWithIdentifier("com.codepath.yelp.businesscell") as BusinessTableViewCell
        
        let business = businesses[indexPath.row]
        cell.updateCell(business, number: indexPath.row + 1)
        
        return cell
    }


}

