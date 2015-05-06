//
//  NewEntryViewController.swift
//  ermiasTableView
//
//  Created by Truc Truong on 27/04/15.
//  Copyright (c) 2015 Truc Truong. All rights reserved.
//

import UIKit


protocol EntryDelegate{
    func userDidFinish(controller:NewEntryViewController,entry:String)
}


class NewEntryViewController: UIViewController,UITextViewDelegate {
    
   var delegate:EntryDelegate?

    @IBOutlet weak var TextView: UITextView!
    var myText = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TextView.text = myText
        self.TextView.delegate = self
        
        // Let's begin edit the document
        
    }
    
    override func viewDidAppear(animated: Bool) {
        TextView.becomeFirstResponder()
    
    }
    @IBAction func saveButtonPressed(sender: AnyObject) {
        // Grab the text
        var myText = TextView.text
        // Send to observers
        //self.navigationController?.popToRootViewControllerAnimated(true)
        
        if(self.delegate != nil){
            delegate?.userDidFinish(self, entry: myText)
        }

        
    }
}
