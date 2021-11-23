//
//  TweetCell.swift
//  OpenTweet
//
//  Created by Vincent Ou on 11/20/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation
import UIKit
import AlamofireImage

class TweetCell: UITableViewCell {
    
    //Create subviews for tweet cell
    let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    let tweetText: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isUserInteractionEnabled = false
        textView.isScrollEnabled = false
        textView.backgroundColor = .clear
        return textView
    }()
    
    //Override tableviewcell init and add subviews we created
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImage)
        profileImage.widthAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15).isActive = true
        profileImage.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15).isActive = true
        
        
        addSubview(tweetText)
        tweetText.topAnchor.constraint(equalTo: self.topAnchor, constant: 5).isActive = true
        tweetText.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        tweetText.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        tweetText.leftAnchor.constraint(equalTo: profileImage.rightAnchor, constant: 5).isActive = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    var tweet: Any? {
            didSet {
                // Guard statement here to cast tweet
                guard let t = tweet as? Tweet else { return }
                
                //For changing date to MM/dd/yyyy format, but will not use this since tech challenge asks for iso8601
                let df = DateFormatter()
                df.locale = Locale(identifier: "en_US")
                df.dateFormat = "MM/dd/yyyy h:mm a"
                let date = df.string(from: t.date)
                
                //Removes the @ from the username
                var nickname = t.author
                nickname.remove(at: nickname.startIndex)
                
                // Create attributed text to store content
                // Add username
                let attributedText = NSMutableAttributedString(string: nickname, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18)])

                // Add date
                attributedText.append(NSAttributedString(string: " \(date) \n", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.gray]))
                
                // Add the message
                attributedText.append(NSAttributedString(string: t.content, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30)]))
                
                //Highlight mentions
                let content = attributedText.string as NSString
                let mentionRange = content.range(of: "@\\w+", options: .regularExpression, range: NSMakeRange(0,content.length))
                if mentionRange.length > 0 {
                    attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: mentionRange)
                }
                //Highlight https links
                let hyperlinkRange = content.range(of: "https?:/.*", options: .regularExpression, range: NSMakeRange(0,content.length))
                if hyperlinkRange.length > 0 {
                    attributedText.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: hyperlinkRange)
                }
            
                // Set tweet text subview text
                tweetText.attributedText = attributedText

                // Set user image with AlamoFireImage
                //Provide default twitter user image if there is no avatar url provided
                let imageURL = URL(string: t.avatar ?? "https://abs.twimg.com/sticky/default_profile_images/default_profile_400x400.png")
                profileImage.af.setImage(withURL: imageURL!)
            }
        }
    
}
