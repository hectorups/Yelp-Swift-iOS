//
//  ColorPalette.swift
//  Yelp
//
//  Created by Hector Monserrate on 19/09/14.
//  Copyright (c) 2014 CodePath. All rights reserved.
//

import Foundation

enum ColorPalette {
    case Red, Gray
    
    func get(alpha: CGFloat = 1.0) -> UIColor {
        
        switch self {
            case .Red:
                return UIColor(red: 212/255, green: 0.0, blue: 0.0, alpha: alpha)
            case .Gray:
                return UIColor(red: 232/256, green: 232/256, blue: 232/256, alpha: alpha)
        }
    }
}
