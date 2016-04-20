//
//  AboutMeViewController.swift
//  Tyler Voll Books
//
//  Created by Tyler V on 2/18/16.
//  Copyright © 2016 Tyler Voll. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    @IBOutlet var myWebView: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let myURL = NSURL(string: "http://tylervollbooks.com/aboutmemobile");
        
        let myURLRequest = NSURLRequest(URL: myURL!);
        myWebView.loadRequest(myURLRequest);
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
