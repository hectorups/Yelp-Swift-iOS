//
//  ViewController.swift
//  Yelp
//
//  Created by Hector Monserrate on 18/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UISearchBarDelegate,
                        UITableViewDelegate, FiltersViewControllerDelegate {
    var businesses = [Business]()

    @IBOutlet weak var businessesTableView: UITableView!
    var searchFilter = SearchFilter()
    let client = YelpClient()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        businessesTableView.delegate = self
        businessesTableView.dataSource = self
        businessesTableView.rowHeight = UITableViewAutomaticDimension
        businessesTableView.estimatedRowHeight = 100.0
        
        loadBusinesses()
        prepareSearchBar()
    }
    
    func loadBusinesses(append: Bool = false){
        let success = { (operation: AFHTTPRequestOperation!,
            responseObject: AnyObject!) -> Void in
            
            let json = JSON(responseObject)
            
            if !append {
                self.businesses = []
            }
            
            for (i, v) in json["businesses"] {
//                printltn(v)
                self.businesses.append(Business(fromJson: v))
            }
            
            self.businessesTableView.reloadData()
        }
        
        let failure = { (operation: AFHTTPRequestOperation!,
            error: NSError!) -> Void in
            println(error)
        }
        
        client.searchWithFilters(searchFilter, success: success, failure: failure)
    }
    
    
    func prepareSearchBar(){
        var searchBar = UISearchBar(frame: CGRectMake(0.0, 0.0, 300, 44.0))
        searchBar.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin
        searchBar.backgroundColor = UIColor.clearColor()
        searchBar.tintColor = ColorPalette.Red.get()
        searchBar.delegate = self
        self.navigationItem.titleView = searchBar
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filters", style: UIBarButtonItemStyle.Plain, target: self, action: "goToFilters")
        self.navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        
        var emptyView = UIView(frame: CGRectMake(0, 0, 40.0, 44.0))
        let rightHackItem = UIBarButtonItem(customView: emptyView)
        self.navigationItem.rightBarButtonItem = rightHackItem
        
    }
    
    func goToFilters() {
        println("Button clicked")
        var filtersController = self.storyboard?.instantiateViewControllerWithIdentifier("FiltersViewController") as FiltersViewController
        filtersController.searchFilter = searchFilter
        filtersController.delegate = self
        self.navigationController?.pushViewController(filtersController, animated: true)
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
    
    func applyFilters(updatedSearchFilter: SearchFilter) {
        println("apply filters")
        self.searchFilter = updatedSearchFilter
        loadBusinesses()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if countElements(searchText) > 3 {
            searchFilter.term = searchText
            loadBusinesses()
        }
        
        if countElements(searchText) == 0 && countElements(searchFilter.term) > 0 {
            searchFilter.term = ""
            loadBusinesses()
        }
    }

}

