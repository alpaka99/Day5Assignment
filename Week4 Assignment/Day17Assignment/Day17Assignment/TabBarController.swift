//
//  TabBarController.swift
//  Day17Assignment
//
//  Created by user on 6/5/24.
//

import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let vc1 = LottoViewController()
        let nav1 = UINavigationController(rootViewController: vc1)
        nav1.tabBarItem.title = "로또"
        nav1.tabBarItem.image = UIImage(systemName: "ticket.fill")
        
        setViewControllers([nav1], animated: true)
    }
    
    
}
