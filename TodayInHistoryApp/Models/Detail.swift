//
//  Detail.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 20.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit

class Detail: NSObject {

    
    var year : String?
    var text : String?
    var html : String?
    var noYearHtml : String?
    var urls : [linkModel]?
    
    var date : String?
    var url : String?

    init(item:[String:Any]) {
        super.init()
        
        self.year = item["year"] as? String
        self.text = item["text"] as? String
        self.html = item["html"] as? String
        self.noYearHtml = item["no_year_html"] as? String
        
        let linkArr  = item["links"] as? [[String:String]]
        
        self.urls = []
        
        for link in linkArr! {
            let model = linkModel(dict: link)
            self.urls?.append(model)
        }
    }
    
    init(history:[String:Any]) {
            super.init()
            self.date = history["date"] as? String
            self.url = history["url"] as? String
        }
    
   
}
