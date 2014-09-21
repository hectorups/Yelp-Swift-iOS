//
//  DropdownTableViewCell.swift
//  Yelp
//
//  Created by Hector Monserrate on 21/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

class DropdownTableViewCell: UITableViewCell {

    @IBOutlet weak var rightImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func selected() {
        rightImageView.hidden = false
        rightImageView.image = UIImage(named: "selected_filter")
    }
    
    func unSelected() {
        rightImageView.hidden = true
    }
    
    func condensed() {
        rightImageView.hidden = false
        rightImageView.image = UIImage(named: "expand_filter")
    }
    
    
    
}
