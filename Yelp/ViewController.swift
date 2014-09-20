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
        businessesTableView.rowHeight = UITableViewAutomaticDimension
        businessesTableView.estimatedRowHeight = 100.0
        
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
        
        prepareSearchBar()
    }
    
    
    func prepareSearchBar(){
        var searchBar = UISearchBar(frame: CGRectMake(0.0, 0.0, 300, 44.0))
        searchBar.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.tintColor = ColorPalette.Red.get()
        self.navigationItem.titleView = searchBar
        
        var filterButton = UIButton(frame: CGRectMake(0, 0, 50.0, 44.0))
        filterButton.setTitle("Filters", forState: UIControlState.Normal)
        filterButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 14.0)
        filterButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        filterButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Highlighted)
        
        let leftHackItem = UIBarButtonItem(customView: filterButton)
        self.navigationItem.leftBarButtonItem = leftHackItem
        
        var emptyView = UIView(frame: CGRectMake(0, 0, 40.0, 44.0))
        let rightHackItem = UIBarButtonItem(customView: emptyView)
        self.navigationItem.rightBarButtonItem = rightHackItem
        
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

