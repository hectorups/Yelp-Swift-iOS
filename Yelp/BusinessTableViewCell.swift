//
//  BusinessTableViewCell.swift
//  Yelp
//
//  Created by Hector Monserrate on 18/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import Foundation

class BusinessTableViewCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var rankingLabel: UILabel!
    @IBOutlet weak var rankingImageView: UIImageView!
    @IBOutlet weak var nameTextView: UITextField!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var categoriesLabel: UILabel!
    @IBOutlet weak var cellContentView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = UITableViewCellSelectionStyle.None
        
        // Configure the view for the selected state
    }
    
    func updateCell(business : Business, number: Int) {
        nameLabel.text = "\(number). \(business.name!)"
        if let distance = business.distance {
            distanceLabel.text = String(format: "%.2f km", Float(distance) / 1000)
        } else {
            distanceLabel.text = ""
        }
        

        
        var neightborhood = ""
        if business.neightborhood != nil {
            neightborhood = business.neightborhood!
        }
        
        
        addressLabel.text = business.fullAddress()
        
        var categoriesText = ""
        for category in business.categories {
            categoriesText +=  (categoriesText == "" ? "" : ", ") + category
        }
        categoriesLabel.text = categoriesText

        rankingImageView.setImageWithURL(NSURL(string: business.ratingImgURL!))
        
        thumbnailImageView.layer.cornerRadius = CGFloat(5)
        thumbnailImageView.layer.masksToBounds = true
        
        if let imageURL = business.imageURL {
            thumbnailImageView.setImageWithURLRequest(
                NSURLRequest(URL: NSURL(string: imageURL)),
                placeholderImage: nil,
                success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) in
                    self.thumbnailImageView.alpha = 0.0
                    self.thumbnailImageView.image = image
                    UIView.animateWithDuration(0.5, animations: {self.thumbnailImageView.alpha = 1.0})
                },
                failure: { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) in
                    println("Image failed to load")
            })
        }
    }
    
    override func setHighlighted(highlighted: Bool, animated: Bool) {

        if highlighted {
            contentView.backgroundColor = ColorPalette.Gray.get(alpha: 0.8)
        } else {
            contentView.backgroundColor = UIColor.whiteColor()
        }
    }
    
}