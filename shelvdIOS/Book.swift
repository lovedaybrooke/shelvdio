//
//  Book.swift
//  shelvdIOS
//
//  Created by Kat Matfield on 04/01/2015.
//  Copyright (c) 2015 Kat Matfield. All rights reserved.
//

import Foundation

struct Book {

    var title: String
    var isbn: String
    var status: String
    var labelText: String
    var page: Int?
    var endDate: String?
    
    init(bookDict: NSDictionary) {
        title = bookDict["title"] as String
        isbn = bookDict["isbn"] as String
        status = bookDict["status"] as String
        labelText = ("\(self.title) (\(self.isbn))")
        
        if status == "unfinished" {
            var page = bookDict["page"] as? Int
            labelText += ": p\(page!)"
        } else if status == "finished" {
            endDate = bookDict["end_date"] as? String
            labelText += " finished on \(endDate!)"
            
        }

    }
    
    
}

struct ApiEndpoint {
    
    var url: String
    

    init(bookStatus: String) {
        var bookAPIUrls = [
            "unfinished": "http://shelvd.herokuapp.com/",
            "finished": "http://shelvd.herokuapp.com/finished"
        ]
        self.url = bookAPIUrls[bookStatus]!
    }
}