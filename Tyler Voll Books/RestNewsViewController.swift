

//
//  RestNewsViewController.swift
//  Tyler Voll Books
//
//  Created by Tyler V on 3/9/16.
//  Copyright © 2016 Tyler Voll. All rights reserved.
//

import UIKit


class RestNewsViewController: UIViewController {
    //Keeps count of the current article id being viewed. Set to 0 in order to not confuse with the earliest article node id available, which is 1.
    var changingNumber: Int = 0
    var fixedNumber: Int = 0
    var userId: Int = 0
    var type = "article"
    var numOfPosts = 0
    var forumIds = [Int]()
    
    var lastForumNumberTried: Int = 0
    
    func parseNid(json: JSON) {
        for result in json.arrayValue {
            let nid = Int(result["nid"][0]["value"].description)!
            numOfPosts += 1
            forumIds.append(nid)
            print(forumIds)
            
        }
    }

    @IBOutlet var articleTitle: UILabel!
    
    @IBOutlet var articleContent: UITextView!
    
    @IBOutlet var articleAuthor: UILabel!
    
    @IBOutlet var articleCommentCount: UILabel!
    
    @IBOutlet var nextArticle: UIButton!
    
    @IBOutlet var previousArticle: UIButton!
    
    @IBOutlet var articleDate: UILabel!
    
    @IBAction func swipeNext(sender: AnyObject) {
        self.toNextArticle(nextArticle)
        
    }
    
    @IBAction func swipePrevious(sender: AnyObject) {
        self.toPreviousArticle(previousArticle)
    }
    
    //These action controllers monitor the page number / article ID
    @IBAction func toNextArticle(sender: UIButton) {
        if changingNumber > 0 {
            changingNumber -= 1
            getEntityId(self.forumIds[changingNumber])
            self.viewDidLoad()
        }
    }
    
    @IBAction func toPreviousArticle(sender: UIButton) {
        if changingNumber <= numOfPosts - 1 {
            changingNumber += 1
            getEntityId(self.forumIds[changingNumber])
            self.viewDidLoad()
        }
    }
    
    func maintainButtons(){
        //Chooses whether or not to display the 'next' and or 'previous' buttons depending on the location of the page.
        if self.changingNumber > 0 && self.changingNumber < numOfPosts - 1{
            self.nextArticle.hidden = false
            self.previousArticle.hidden = false
        }else if self.changingNumber == self.fixedNumber{
            self.previousArticle.hidden = false
            self.nextArticle.hidden = true
        }else if changingNumber == numOfPosts - 1{
            self.nextArticle.hidden = false
            self.previousArticle.hidden = true
        }
    }
    
    func unixTimeConvertion(unixTime: Double) -> String {
        let time = NSDate(timeIntervalSince1970: unixTime)
        let dateFormatter = NSDateFormatter()
        dateFormatter.timeZone = NSTimeZone(name: "America/Chicago")
        dateFormatter.locale = NSLocale(localeIdentifier: NSLocale.systemLocale().localeIdentifier)
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.stringFromDate(time)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.changingNumber == 0 && numOfPosts == 0 {
            let url = "http://tylervollbooks.com/rest/views/news"
            request(.GET, url, parameters: ["title": self.articleTitle.text!]).responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        self.parseNid(json)
                        //Stores latest news id and a changeable nid in order to keep track of news article. Converted from String to Int
                        
                        getEntityId(self.changingNumber)
                        
                        self.articleTitle.text = json[0]["title"][0]["value"].description
                        
                        //Takes the content being pulled in from the website and removes HTML tags from its body.
                        if json[0]["body"][0]["value"] != nil{
                            let rawContent = json[0]["body"][0]["value"].description
                            let modContent = rawContent.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                            let spacingRemoval = modContent.stringByReplacingOccurrencesOfString("&nbsp;", withString: "", options: .RegularExpressionSearch, range: nil)
                            self.articleContent.text = spacingRemoval
                        }else{
                            self.articleContent.text = "There is no content for this post."
                        }
                        
                        
                        
                        self.articleCommentCount.text = json[0]["comment"][0]["comment_count"].description
                        
                        
                        //Figures which admin posted the content by their user id.
                        self.userId = Int(json[0]["uid"][0]["target_id"].description)!
                        self.findUsername()
                        
                        
                        //Configures a working time by converting the JSON timestamp from Drupal
                        let timeStamp = Double(json[0]["created"][0]["value"].description)!
                        self.articleDate.text = self.unixTimeConvertion(timeStamp)
                        
                        
                        //Calls MaintainButtons function to reorganize visible 'page changing' buttons on the UI
                        self.maintainButtons()
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }else if self.changingNumber >= self.fixedNumber{
            
            let url = "http://tylervollbooks.com/rest/views/news?nid=\(self.forumIds[changingNumber])"
            request(.GET, url, parameters: ["title": self.articleTitle.text!]).responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        //Stores latest news id and a changeable nid in order to keep track of news article. Converted from String to Int
                        
                        
                        self.articleTitle.text = json[0]["title"][0]["value"].description
                        
                        //Takes the content being pulled in from the website and removes HTML tags from its body.
                        if json[0]["body"][0]["value"] != nil{
                            let rawContent = json[0]["body"][0]["value"].description
                            let modContent = rawContent.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                            let spacingRemoval = modContent.stringByReplacingOccurrencesOfString("&nbsp;", withString: "", options: .RegularExpressionSearch, range: nil)
                            self.articleContent.text = spacingRemoval
                        }else{
                            self.articleContent.text = "There is no content for this post."
                        }
                        
                        
                        self.articleCommentCount.text = json[0]["comment"][0]["comment_count"].description
                        
                        //Figures which admin posted the content by their user id.
                        self.userId = Int(json[0]["uid"][0]["target_id"].description)!
                        self.findUsername()
                        
                        //Configures a working time by converting the JSON timestamp from Drupal
                        let timeStamp = Double(json[0]["created"][0]["value"].description)!
                        self.articleDate.text = self.unixTimeConvertion(timeStamp)
                        
                        //Calls MaintainButtons function to reorganize visible 'page changing' buttons on the UI
                        self.maintainButtons()
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }
        
        
        
        // Do any additional setup after loading the view.
        
    }
    
    func findUsername(){
        let url2 = "http://tylervollbooks.com/rest/views/usercheck?uid_raw=\(self.userId)"
        request(.GET, url2, parameters: ["name": self.articleAuthor.text!]).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.articleAuthor.text = json[0]["name"][0]["value"].description
                }
                
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
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

