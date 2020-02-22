//
//  linkModel.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 21.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit

class linkModel: NSObject {
    
    var title : String?
    var urlStr : String?
    
    init(dict:[String:Any]) {
        
        self.title = dict["title"] as? String
        self.urlStr = dict["url"] as? String
        
    }

}
