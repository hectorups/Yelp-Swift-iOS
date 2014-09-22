//
//  FiltersViewController.swift
//  Yelp
//
//  Created by Hector Monserrate on 20/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

protocol FiltersViewControllerDelegate {
    func applyFilters(searchFilter: SearchFilter)
}

class FiltersViewController: UIViewController, UITableViewDataSource,
                    SwitchTableViewCellDelegate, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    var delegate: FiltersViewControllerDelegate?
    var expandedSections = [Int: Bool]()
    var selectedValues = [Int: Int]()
    var searchFilter = SearchFilter()
    
    let MAX_CATEGORIES = 4
    
    enum FilterType : Int {
        case Distance = 0, Sort, Deals, Category, Count
        
        func toTitle() -> String {
            switch self {
            case .Distance:
                return "Distance"
            case .Sort:
                return "Sort"
            case .Deals:
                return "Deals"
            case .Category:
                return "Category"
            default:
                return ""
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sections
        for index in 1...FilterType.Count.hashValue {
            selectedValues[index] = 0
        }
        
        // Navigation Bar
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Plain, target: self, action: "onCancelButton")
        navigationItem.leftBarButtonItem?.tintColor = UIColor.whiteColor()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search", style: UIBarButtonItemStyle.Plain, target: self, action: "onSearchButton")
        navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        title = "Filters"
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: ColorPalette.White.get()]

        
        
        // Table View
        tableView.dataSource = self
        tableView.delegate = self
        
    }
    
    func onSearchButton(){
        println("on search")
        navigationController?.popViewControllerAnimated(true)
        self.delegate?.applyFilters(self.searchFilter)
        
    }
    
    func onCancelButton(){
        navigationController?.popViewControllerAnimated(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func isSectionExpanded(section: Int) -> Bool {
        if let value = expandedSections[section] {
            return value
        } else {
            return false
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return FilterType.Count.hashValue
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let filterType = FilterType.fromRaw(section)!
        switch filterType {
        case .Distance:
            if isSectionExpanded(section) {
                return YelpClient.Distance.Count.hashValue
            }
        case .Sort:
            if isSectionExpanded(section) {
                return YelpClient.Sort.Count.hashValue
            }
        case .Deals:
            return 1
        case .Category:
            if isSectionExpanded(section) {
                return YelpClient.Cagegory.Count.hashValue
            } else {
                return MAX_CATEGORIES + 1
            }
        default:
            NSException(name: NSInvalidArgumentException, reason: "invalid section \(section)", userInfo: nil).raise()
        }
        
        return 1
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return FilterType.fromRaw(section)?.toTitle()
    }
    
    func reusableTableCell(identifier: String) -> UITableViewCell {
        var possibleCell = tableView.dequeueReusableCellWithIdentifier(identifier) as UITableViewCell?
        if possibleCell == nil {
            let topLevelObjects = NSBundle.mainBundle().loadNibNamed(identifier, owner: self, options: nil)
            possibleCell = topLevelObjects.first as UITableViewCell?
        }
        
        return possibleCell!
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        let filterType = FilterType.fromRaw(section)!
        
        if filterType == FilterType.Deals {
            let switchCell = reusableTableCell("SwitchTableViewCell") as SwitchTableViewCell
            switchCell.settingSwitch.on = searchFilter.deals
            switchCell.delegate = self
            return switchCell
        } else if( filterType == FilterType.Category
            && !isSectionExpanded(section)
            && row == MAX_CATEGORIES ){
            return reusableTableCell("MoreCategoriesTableViewCell")
        }
        
        let cell = reusableTableCell("DropdownTableViewCell") as DropdownTableViewCell

        var cellText: String?
        var selected = false
        
        switch filterType {
        case .Distance:
            if isSectionExpanded(section) {
                cellText = YelpClient.Distance.fromRaw(row)?.toText()
                if row == searchFilter.distance.hashValue {
                    cell.selected()
                } else {
                    cell.unSelected()
                }
            } else {
                cellText = searchFilter.distance.toText()
            }
        case .Sort:
            if isSectionExpanded(section) {
                cellText = YelpClient.Sort.fromRaw(row)?.toText()
                if row == searchFilter.sort.hashValue {
                    cell.selected()
                } else {
                    cell.unSelected()
                }
            } else {
                cellText = searchFilter.sort.toText()
            }
        case .Category:
            cellText = YelpClient.Cagegory.fromRaw(row)?.toText()
            if searchFilter.hasCategory(YelpClient.Cagegory.fromRaw(row)!){
                cell.selected()
            } else {
                cell.unSelected()
            }
        default:
            NSException(name: NSInvalidArgumentException, reason: "invalid section \(section)", userInfo: nil).raise()
        }
        
        cell.titleLabel.text = cellText!
        
        if !isSectionExpanded(section) && filterType != FilterType.Category {
            cell.condensed()
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        let filterType = FilterType.fromRaw(section)!
        
        var willExpand = false
        
        if filterType == FilterType.Category {
            willExpand = row == MAX_CATEGORIES && !isSectionExpanded(section)
        } else {
            willExpand = !isSectionExpanded(section)
        }
        
        if willExpand {
            expandedSections[section] = true
        } else {
            switch filterType {
            case .Distance:
                searchFilter.distance = YelpClient.Distance.fromRaw(row)!
            case .Sort:
                searchFilter.sort = YelpClient.Sort.fromRaw(row)!
            case .Category:
                let selectedCategory = YelpClient.Cagegory.fromRaw(row)!
                if let index = searchFilter.categoryIndex(selectedCategory) {
                    searchFilter.categories.removeAtIndex(index)
                } else {
                    searchFilter.categories.append(selectedCategory)
                }
            default:
                println()
            }
            
            if filterType != FilterType.Category {
                expandedSections[section] = false
            }
        }
        
        tableView.reloadSections(NSIndexSet(index: section), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    func onSwitchChanged(on: Bool) {
        searchFilter.deals = on
    }
    

}
