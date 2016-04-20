//
//  LearnMoreViewController.swift
//  Tyler Voll Books
//
//  Created by Tyler V on 2/16/16.
//  Copyright © 2016 Tyler Voll. All rights reserved.
//

import UIKit

class LearnMoreViewController: UIViewController {

    @IBOutlet var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = NSURL(string: "http://tylervollbooks.com/search/node?keys=Lukewarm");
        
        let myURLRequest = NSURLRequest(URL: myURL!);
        myWebView.loadRequest(myURLRequest);
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func AurthoriBooks(sender: UIButton) {
        let url : NSURL = NSURL(string: "https://itunes.apple.com/us/author/tyler-voll/id961227652?mt=11")!
        if UIApplication.sharedApplication().canOpenURL(url) == true
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    //Displays the author's official page on the iBookstore.
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
