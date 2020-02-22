//
//  SplashView.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 22.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit

class SplashView: UIView {
    
    static func show(VC:ViewController) -> SplashView {
        let design = Bundle.main.loadNibNamed("SplashView", owner: nil, options: nil)?[0] as! UIView
        design.frame = UIScreen.main.bounds
        VC.view.addSubview(design)
        VC.view.bringSubviewToFront(design)
        return (design as! SplashView)
    }

}
