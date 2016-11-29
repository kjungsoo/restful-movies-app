//
//  DetailViewController.swift
//  RIP
//
//  Created by Brian Hill on 11/22/16.
//  Copyright © 2016 cs197. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!

    @IBOutlet weak var productIDlabel: UILabel!
    
    @IBOutlet weak var ratingsLabel: UILabel!
    
    
    var reviewer: [String] = []
    var ratings: [String:Int] = [:]
    var review_text: [String:String] = [:]
    var product_name: String = "0767026128"

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = self.detailDescriptionLabel {
                label.text = detail
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: String? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }


}

