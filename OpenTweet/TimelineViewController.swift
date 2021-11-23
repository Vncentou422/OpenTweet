//
//  ViewController.swift
//  OpenTweet
//
//  Created by Olivier Larivain on 9/30/16.
//  Copyright © 2016 OpenTable, Inc. All rights reserved.
//

import UIKit

class TimelineViewController: UITableViewController {
    
    let cellId = "cellId"
    var tweets = [Tweet]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        navigationItem.title = "Twitter Feed"
        // TableView register cells as TweetCell class
        tableView.register(TweetCell.self, forCellReuseIdentifier: cellId)
        // Populate tweets
        addTweet()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! TweetCell
        // Didset block in TweetCell will handle setting up views for UITableViewCell
        cell.tweet = tweets[indexPath.item]
        return cell;
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Create new VC to present modally
        let threadVC = TimelineViewController()
        threadVC.modalTransitionStyle = .coverVertical
        threadVC.modalPresentationStyle = .popover
        threadVC.disableUserInteraction()
        
        //Change tweet array to display replies or in reply to
        let cell = tableView.cellForRow(at: indexPath) as! TweetCell
        let clickedTweet = cell.tweet as! Tweet
        let id = clickedTweet.id
        let inReplyTo = clickedTweet.inReplyTo ?? ""
        threadVC.tweets = getReplies(clickedTweet: clickedTweet, id: id, inReplyTo: inReplyTo)
        
        //Present
        present(threadVC, animated: true, completion: nil)
    }

    // Read the provided JSON file
    private func readLocalFile(forName name: String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name,
                                                 ofType: "json"),
                let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    // Parse the provided JSON file
    private func parse(jsonData: Data) {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        if let decodedData = try? decoder.decode(Tweets.self, from: jsonData) {
            tweets = decodedData.timeline
        }
        else{
            print("Failed to parse JSON")
        }
    }
    
    private func addTweet(){
        let JSON = readLocalFile(forName: "timeline")!
        parse(jsonData: JSON)
    }
    
    private func disableUserInteraction(){
        tableView.isUserInteractionEnabled = false
    }
    
    // Populate new [Tweet] array with tweets in relation to replies
    private func getReplies(clickedTweet: Tweet, id : String, inReplyTo: String) -> [Tweet]{
        var retArr = [Tweet]()
        //Tweet is in reply to another tweet
        if (inReplyTo != ""){
            for tweet in tweets {
                if (tweet.id == inReplyTo){
                    retArr.append(tweet)
                    retArr.append(clickedTweet)
                    return retArr
                }
            }
        }
        //Tweet is the first tweet in the thread
        else{
            retArr.append(clickedTweet)
            for tweet in tweets{
                if (tweet.inReplyTo == id){
                        retArr.append(tweet)
                }
            }
        }
        return retArr
    }
    
    
}

