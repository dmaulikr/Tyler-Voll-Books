//
//  RestNewsViewController.swift
//  Tyler Voll Books
//
//  Created by Tyler V on 3/9/16.
//  Copyright © 2016 Tyler Voll. All rights reserved.
//

import UIKit

var viewAll = true
var baseUrl = ""
var changingUrl = ""

class RestForumViewController: UIViewController {
    //Keeps count of the current article id being viewed. Set to 0 in order to not confuse with the earliest article node id available, which is 1.
    var changingForumNumber: Int = 0
    var fixedForumNumber: Int = 0
    var userId: Int = 0
    var url = ""
    var type = "forum"
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
    //Tries to validate a URL to see if it is sending JSON data before sending it through a page.
    /*
     Obtain IDs
     Function searches top ten most recent topics, storing their IDs into an array.
     Use a changing number and a fixed number in order to control where in the array you are.
     Use certain array value to pinpoint what topic the user would like to view.
     */

    
    @IBOutlet var topicTitle: UILabel!
    
    @IBOutlet var topicContent: UITextView!
    
    @IBOutlet var topicAuthor: UILabel!
    
    @IBOutlet var topicCommentCount: UILabel!
    
    @IBOutlet var nextTopic: UIButton!
    
    @IBOutlet var previousTopic: UIButton!
    
    @IBOutlet var topicDate: UILabel!
    
    @IBAction func swipeNext(sender: AnyObject) {
        self.toNextTopic(nextTopic)
        
    }
    
    @IBAction func swipePrevious(sender: AnyObject) {
        self.toPreviousTopic(previousTopic)
    }
    
    //These action controllers monitor the page number / article ID
    @IBAction func toNextTopic(sender: UIButton) {
        if changingForumNumber > 0 {
            changingForumNumber -= 1
            getEntityId(self.forumIds[changingForumNumber])
            self.viewDidLoad()
        }
    }
    
    @IBAction func toPreviousTopic(sender: UIButton) {
        if changingForumNumber <= numOfPosts - 1 {
            changingForumNumber += 1
            getEntityId(self.forumIds[changingForumNumber])
            self.viewDidLoad()
        }
    }
    
    func maintainButtons(){
        //Chooses whether or not to display the 'next' and or 'previous' buttons depending on the location of the page.
        if self.changingForumNumber > 0 && self.changingForumNumber < numOfPosts - 1{
            self.nextTopic.hidden = false
            self.previousTopic.hidden = false
        }else if self.changingForumNumber == self.fixedForumNumber && numOfPosts > 1{
            self.previousTopic.hidden = false
            self.nextTopic.hidden = true
        }else if self.changingForumNumber == self.fixedForumNumber && numOfPosts == 1{
            self.previousTopic.hidden = true
            self.nextTopic.hidden = true
        }else if changingForumNumber == numOfPosts - 1{
            self.nextTopic.hidden = false
            self.previousTopic.hidden = true
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
        if self.changingForumNumber == 0 && numOfPosts == 0 {
            if viewAll == true
            {
                url = "http://tylervollbooks.com/rest/views/newforums"
            }
            else
            {
                url = baseUrl
            }
            request(.GET, url, parameters: ["title": self.topicTitle.text!]).responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        self.parseNid(json)
                        //Stores latest news id and a changeable nid in order to keep track of news article. Converted from String to Int
                        
                        getEntityId(self.changingForumNumber)
                        
                        self.topicTitle.text = json[0]["title"][0]["value"].description
                        
                        //Takes the content being pulled in from the website and removes HTML tags from its body.
                        if json[0]["body"][0]["value"] != nil{
                            let rawContent = json[0]["body"][0]["value"].description
                            let modContent = rawContent.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                            let spacingRemoval = modContent.stringByReplacingOccurrencesOfString("&nbsp;", withString: "", options: .RegularExpressionSearch, range: nil)
                            self.topicContent.text = spacingRemoval
                        }else{
                            self.topicContent.text = "There is no content for this post."
                        }

                        
                        
                        self.topicCommentCount.text = json[0]["comment_forum"][0]["comment_count"].description
                        
                        
                        //Figures which admin posted the content by their user id.
                         self.userId = Int(json[0]["uid"][0]["target_id"].description)!
                        self.findUsername()

                        
                        //Configures a working time by converting the JSON timestamp from Drupal
                        let timeStamp = Double(json[0]["created"][0]["value"].description)!
                        self.topicDate.text = self.unixTimeConvertion(timeStamp)
                        
                        
                        //Calls MaintainButtons function to reorganize visible 'page changing' buttons on the UI
                        self.maintainButtons()
                    }
                case .Failure(let error):
                    print("Request failed with error: \(error)")
                }
            }
        }else if self.changingForumNumber >= self.fixedForumNumber{
            if viewAll == true
            {
                 url = "http://tylervollbooks.com/rest/views/newforums?nid=\(self.forumIds[changingForumNumber])"
            }
            else
            {
                 url = changingUrl + "\(self.forumIds[changingForumNumber])"
            }
            request(.GET, url, parameters: ["title": self.topicTitle.text!]).responseJSON { response in
                switch response.result {
                case .Success:
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                        //Stores latest news id and a changeable nid in order to keep track of news article. Converted from String to Int

                        
                        self.topicTitle.text = json[0]["title"][0]["value"].description
                        
                        //Takes the content being pulled in from the website and removes HTML tags from its body.
                        if json[0]["body"][0]["value"] != nil{
                            let rawContent = json[0]["body"][0]["value"].description
                            let modContent = rawContent.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
                            let spacingRemoval = modContent.stringByReplacingOccurrencesOfString("&nbsp;", withString: "", options: .RegularExpressionSearch, range: nil)
                            self.topicContent.text = spacingRemoval
                        }else{
                            self.topicContent.text = "There is no content for this post."
                        }
                        
                        
                        self.topicCommentCount.text = json[0]["comment_forum"][0]["comment_count"].description
                        
                        //Figures which admin posted the content by their user id.
                        self.userId = Int(json[0]["uid"][0]["target_id"].description)!
                        self.findUsername()
                        
                        //Configures a working time by converting the JSON timestamp from Drupal
                        let timeStamp = Double(json[0]["created"][0]["value"].description)!
                        self.topicDate.text = self.unixTimeConvertion(timeStamp)
                        
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
        let url2 = ""//Enter the URL of your REST export that will compare User IDs in order to pull in a Username"
        request(.GET, url2, parameters: ["name": self.topicAuthor.text!]).responseJSON { response in
            switch response.result {
            case .Success:
                if let value = response.result.value {
                    let json = JSON(value)
                    self.topicAuthor.text = json[0]["name"][0]["value"].description
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

class ForumBoardsViewController: UITableViewController{
    
    @IBAction func board1() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums1"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums1?nid="
    }
    
    @IBAction func board2() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums2"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums2?nid="
    }
    
    @IBAction func board3() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums3"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums3?nid="
    }
    
    @IBAction func board4() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums4"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums4?nid="
    }
    
    @IBAction func board5() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums5"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums5?nid="
    }
    
    @IBAction func board6() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums6"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums6?nid="
    }
    
    @IBAction func board7() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums7"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums7?nid="
    }
    
    @IBAction func board8() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums8"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums8?nid="
    }
    
    @IBAction func board9() {
        viewAll = false
        baseUrl = "http://tylervollbooks.com/rest/views/newforums9"
        changingUrl = "http://tylervollbooks.com/rest/views/newforums9?nid="
    }
    
    
}
