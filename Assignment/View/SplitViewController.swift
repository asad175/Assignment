//
//  SplitViewController.swift
//  Assignment
//
//  Created by Asad Choudhary on 1/26/20.
//  Copyright © 2020 Asad Choudhary. All rights reserved.
//

import UIKit

class SplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.delegate = self
        self.preferredDisplayMode = .allVisible
    }
    

    func splitViewController(_ splitViewController: UISplitViewController,
        collapseSecondary secondaryViewController: UIViewController,
        onto primaryViewController: UIViewController) -> Bool {
        // Return true to prevent UIKit from applying its default behavior
        if let nv = secondaryViewController as? UINavigationController,
            let _ = nv.topViewController as? AccountViewController {
            return true // show left view
        }
        return false // show right view
    }

}
