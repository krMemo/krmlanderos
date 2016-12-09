//
//  MainTabBarController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 19/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit


class MainTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if permiso {
            self.tabBar.items?[0].isEnabled = true
            self.selectedIndex = 0
        }
        else {
            self.tabBar.items?[0].isEnabled = false
            self.selectedIndex = 1
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
