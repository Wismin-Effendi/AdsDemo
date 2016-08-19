//
//  UpgradeViewController.swift
//  IAPDemo
//
//  Created by Hesham Abd-Elmegid on 8/18/16.
//  Copyright © 2016 CareerFoundry. All rights reserved.
//

import UIKit

class UpgradeViewController: UIViewController {
    
    @IBOutlet weak var priceLabel: UILabel!
    override func viewDidLoad() {
        UpgradeManager.sharedInstance.priceForUpgrade { (price) in
            self.priceLabel.text = "$\(price)"
        }
    }

    @IBAction func doneButtonTapped(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func upgradeButtonTapped(sender: AnyObject) {
        UpgradeManager.sharedInstance.upgrade()
    }
    
    @IBAction func restorePurchasesButtonTapped(sender: AnyObject) {
        UpgradeManager.sharedInstance.restorePurchases()
    }
    
}