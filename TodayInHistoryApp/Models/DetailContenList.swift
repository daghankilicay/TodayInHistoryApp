//
//  DetailContenList.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 20.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit

class DetailContenList: NSObject {
    
    enum detailContenTypes : Int{
        case Events
        case Births
        case Deaths
        case History
    }
    
    var DetailContents : [Detail]
    
    
    override init() {
        //super.init()
        self.DetailContents = []
    }
}
