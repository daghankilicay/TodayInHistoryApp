//
//  BaseVC.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 20.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    
    var progress : ProgressView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return.lightContent
    }
    
    func showProgress() {
        progress = ProgressView.showProgress()
    }
    
     func hideProgress() {
        progress?.removeFromSuperview()
    }
    
    func dequeueCell(identifier:String, tableView:UITableView) -> UITableViewCell {
            var cell = tableView.dequeueReusableCell(withIdentifier:identifier)
        if cell == nil {
                tableView.register(UINib(nibName: identifier, bundle: nil), forCellReuseIdentifier: identifier)
                cell = tableView.dequeueReusableCell(withIdentifier: identifier)
            }
            return cell!
    }
    func colorFromARGB(hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor (
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

}
