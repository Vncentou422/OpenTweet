//
//  Tweet.swift
//  OpenTweet
//
//  Created by Vincent Ou on 11/20/21.
//  Copyright © 2021 OpenTable, Inc. All rights reserved.
//

import Foundation

struct Tweet : Codable{
    let id: String
    let author: String
    let content: String
    let avatar: String?
    let date: Date
    let inReplyTo: String?
    
}
