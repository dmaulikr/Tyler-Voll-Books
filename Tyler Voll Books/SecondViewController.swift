//
//  SecondViewController.swift
//  Tyler Voll Books
//
//  Created by Tyler V on 2/7/16.
//  Copyright © 2016 Tyler Voll. All rights reserved.
//

import UIKit

var entityId = 0

func getEntityId(incomingEntityId: Int){
    entityId = incomingEntityId
}

class SecondViewController: UIViewController {
    

    @IBOutlet var myWebView: UIWebView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let myURL = NSURL(string: "http://tylervollbooks.com/commentspage?entity_id=\(entityId)");
        
        let myURLRequest = NSURLRequest(URL: myURL!);
        myWebView.loadRequest(myURLRequest);
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    

}


class ThirdViewController: UIViewController {


    @IBAction func LukewarmiBooks(sender: UIButton) {
        let url : NSURL = NSURL(string: "https://itun.es/us/cUYs5.l")!
        if UIApplication.sharedApplication().canOpenURL(url) == true
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }

    @IBAction func LukewarmBarnesNoble(sender: UIButton) {
        let url : NSURL = NSURL(string: "http://www.barnesandnoble.com/w/lukewarm-tyler-voll/1120994395?ean=9781312777828")!
        if UIApplication.sharedApplication().canOpenURL(url) == true
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    @IBAction func LukewarmAmazon(sender: UIButton) {
        let url : NSURL = NSURL(string: "https://www.amazon.com/dp/1312777826/ref=cm_sw_r_cp_awd_wymXwbGM0Q5KM")!
        if UIApplication.sharedApplication().canOpenURL(url) == true
        {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
}

    



