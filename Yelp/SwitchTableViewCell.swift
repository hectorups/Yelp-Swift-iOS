//
//  SwitchTableViewCell.swift
//  Yelp
//
//  Created by Hector Monserrate on 21/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import UIKit

protocol  SwitchTableViewCellDelegate {
    func onSwitchChanged(on: Bool)
}

class SwitchTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var delegate : SwitchTableViewCellDelegate?
    
    @IBAction func onSwitchChanged(sender: AnyObject) {
        delegate?.onSwitchChanged(settingSwitch.on)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
