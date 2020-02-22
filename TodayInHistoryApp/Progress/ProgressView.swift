//
//  ProgressView.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 21.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit

class ProgressView: UIView {

    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    static func showProgress() -> ProgressView {
        
        let design = Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)?[0] as! ProgressView
        design.frame = UIScreen.main.bounds
        let window = UIApplication.shared.keyWindow
        window?.addSubview(design)
        window?.bringSubviewToFront(design)
        design.indicator.startAnimating()
        
         return design
    }

}
