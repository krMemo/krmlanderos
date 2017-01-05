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
        if permisoCalendario {
            self.tabBar.items?[0].isEnabled = true
            self.selectedIndex = 0
        }
        else {
            self.tabBar.items?[0].isEnabled = false
            self.selectedIndex = 1
        }
        writeFiles()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
