//
//  DetailViewController.swift
//  ermiasTableView
//
//  Created by Truc Truong on 27/04/15.
//  Copyright (c) 2015 Truc Truong. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var TextView: UITextView!
    var myText = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        TextView.text = myText
        
    }
}
