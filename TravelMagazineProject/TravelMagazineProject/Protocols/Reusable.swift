//
//  Reusable.swift
//  TravelMagazineProject
//
//  Created by user on 5/26/24.
//

import UIKit

protocol Reusable {
    static func getReuseIdentifier() -> String
}

extension Reusable {
    static func getReuseIdentifier() -> String {
        return String(describing: Self.self)
    }
}

extension UITableViewCell: Reusable {
    
}
