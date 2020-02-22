//
//  ViewController.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 20.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit
import WebKit

class ViewController: BaseVC,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,WKNavigationDelegate {
    
    @IBOutlet weak var viewTop: UIView!
    @IBOutlet weak var topScrollView: UIScrollView!
    @IBOutlet weak var lblDay: UILabel!
    
    @IBOutlet weak var pagerScrollView: UIScrollView!
    
    private var splash : SplashView?
    private var rowHtml : CGFloat = 0.0
    var topButtonName : [String] = []
    var btnSelected = UIButton()
    var topButtonList = [UIButton]()
    var tblView : [UITableView] = []
    var detailContenList : [DetailContenList.detailContenTypes:DetailContenList]?
    let screenFrame = UIScreen.main.bounds
    let statusBarFrame = UIApplication.shared.statusBarFrame
    
    var rowHeight : CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        splash = SplashView.show(VC: self)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if splash != nil {
            self.getHistoryHomePage()
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if detailContenList == nil {
                return 0
            }else {
                if tableView.tag == 0 {
                    return (detailContenList![.Events]?.DetailContents.count)!
                }else if tableView.tag == 1 {
                    return (detailContenList![.Deaths]?.DetailContents.count)!
                }else if tableView.tag == 2{
                    return (detailContenList![.Births]?.DetailContents.count)!
                }
                return 0
            }
            
            
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            
            if tableView.tag == 0 {
                let eventsCell = self.getCell(type: .Events, tableView: tableView, indexPath: indexPath)
                return eventsCell
                
            }else if tableView.tag == 1 {
                let deathsCell = self.getCell(type: .Deaths, tableView: tableView, indexPath: indexPath)
                return deathsCell
            }else if tableView.tag == 2 {
                let birthsCell = self.getCell(type: .Births, tableView: tableView, indexPath: indexPath)
                return birthsCell
            }
            
           return UITableViewCell.init()
        }
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return rowHeight
        }
    
    private func getCell (type:DetailContenList.detailContenTypes,tableView:UITableView, indexPath:IndexPath) -> UITableViewCell {
        let detailCell = dequeueCell( identifier: "detailCell", tableView: tableView) as? detailCell
        detailCell?.lblYear.text = detailContenList![type]?.DetailContents[indexPath.row].year
        let htmlStr = detailContenList![type]?.DetailContents[indexPath.row].html
        let data = Data(htmlStr!.utf8)
        if let attributedString = try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil) {
            detailCell?.textView.attributedText = attributedString
        }
        detailCell?.textView.font = UIFont.systemFont(ofSize: screenFrame.width * 0.04, weight: .medium)
        detailCell?.textView.textColor = UIColor.white
        detailCell?.textView.layer.cornerRadius = screenFrame.width * 0.016
        let height = detailCell?.textView.sizeThatFits(CGSize(width: (detailCell?.textView.frame.width)!, height: 0))
        rowHeight = height!.height + (detailCell?.lblYear.frame.height)! + 10
        return detailCell!
    }
    
    private func getHistoryHomePage(){
        API().getHistory { (data, error) in
            if error == nil {
                self.detailContenList = data
                self.setScreen()
                
                
                 
                self.lblDay.text = self.setDate(dateStr: (self.detailContenList![.History]?.DetailContents[0].date)!)
                for index in 0 ..< self.tblView.count{
                    self.tblView[index].reloadData()
                }
                self.splash!.removeFromSuperview()
                self.splash = nil
            }else{
                let message = "Sunucu üzerinden hata alındı.Hata: \(error!)"
                
                let alertController = UIAlertController(title: "Today In History App", message: message , preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "ÇIKIŞ", style: .cancel) {
                        UIAlertAction in
                        self.alertExit()
                }
                let reLoadAction = UIAlertAction(title: "Yeniden Dene", style: .default) {
                        UIAlertAction in
                        self.reLoadHomePage()
                }
                alertController.addAction(cancelAction)
                alertController.addAction(reLoadAction)
                    
                    
                let alertWindow = UIWindow(frame: UIScreen.main.bounds)
                alertWindow.rootViewController = UIViewController()
                alertWindow.makeKeyAndVisible()
                alertWindow.rootViewController?.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    func alertExit (){
        exit(0)
    }
    
    func reLoadHomePage (){
        self.getHistoryHomePage()
    }
    
    private func setScreen (){
        viewTop.frame = CGRect(x: 0, y: statusBarFrame.height, width: screenFrame.width, height: screenFrame.width * 0.21)
        pagerScrollView.frame = CGRect(x: 0, y:viewTop.frame.height + statusBarFrame.height , width: screenFrame.width, height: screenFrame.height - viewTop.frame.height - statusBarFrame.height )
                        
        topButtonName = ["Events","Deaths","Births"]
                        
        for index in 0 ..< 3 {
            let button = UIButton(frame: CGRect(x:15 + (index * Int(topScrollView.frame.width * 0.3)), y: 0, width: Int(topScrollView.frame.width * 0.3), height: Int(topScrollView.frame.width * 0.08)))
            button.frame = CGRect(x: button.frame.origin.x, y: topScrollView.frame.height / 2 - button.frame.height / 2, width: button.frame.width, height: button.frame.height)
            button.tag = index
            button.backgroundColor = UIColor .clear
            button.setTitleColor(UIColor(cgColor: colorFromARGB(hex: "B6BCC3").cgColor), for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: screenFrame.width * 0.04, weight: .medium)
            button.setTitle(topButtonName[index], for: .normal)
            button.addTarget(self, action: #selector(clickDay(_:)), for: .touchUpInside)
            button.layer.cornerRadius = screenFrame.width * 0.03
            topButtonList.append(button)
            topScrollView.addSubview(button)
                    
            let tbl = UITableView(frame: CGRect(x: pagerScrollView.frame.width * CGFloat(index), y: 0, width: pagerScrollView.frame.width, height: pagerScrollView.frame.height))
            tbl.tag = index
            tbl.backgroundColor = UIColor.clear
            tbl.dataSource=self
            tbl.delegate=self
            tbl.allowsSelection = false
            tblView.append(tbl)
                    
            pagerScrollView.addSubview(tbl)
        }
        topScrollView.contentSize = CGSize(width: topScrollView.frame.width + 15, height: 0)
        topScrollView.delegate = self
        
        
        pagerScrollView.contentSize = CGSize(width: pagerScrollView.frame.width * CGFloat(topButtonList.count), height: 0)
        
        pagerScrollView.delegate = self
        
        btnSelected = topButtonList[0]
        btnSelected.layer.backgroundColor = colorFromARGB(hex: "0C385B").cgColor
        btnSelected.setTitleColor(UIColor.white, for: .normal)
        
        
    }
    
    @objc private func clickDay(_ sender: UIButton) {
        
        btnSelected.backgroundColor = UIColor .clear
        btnSelected.setTitleColor(UIColor(cgColor: colorFromARGB(hex: "B6BCC3").cgColor), for: .normal)
        
        if abs(btnSelected.tag - sender.tag) == 1 {
            self.pagerScrollView.setContentOffset(CGPoint(x: pagerScrollView.frame.width * CGFloat(sender.tag) , y: 0), animated: true)
        } else {
            self.pagerScrollView.setContentOffset(CGPoint(x: pagerScrollView.frame.width * CGFloat(sender.tag) , y: 0), animated: false)
        }
        
        btnSelected = sender
        
        btnSelected.backgroundColor = self.colorFromARGB(hex: "0C385B")
        btnSelected.setTitleColor(UIColor.white, for: .normal)
    }
    
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView == pagerScrollView {
            
            let indexOfPage = scrollView.contentOffset.x / scrollView.frame.size.width
            
            self.selectedButton(btn: topButtonList[Int(indexOfPage)], hex: "0C385B", btnClear: btnSelected)
            
            if indexOfPage >= 3 {
                self.topScrollView.setContentOffset(CGPoint(x:25 , y: 0), animated: true)
            }else {
                self.topScrollView.setContentOffset(CGPoint(x:0 , y: 0), animated: true)
            }
        }
    }
    
    
    
    func selectedButton(btn:UIButton, hex:String, btnClear:UIButton) {
        btn.backgroundColor = colorFromARGB(hex: hex)
        btnClear.backgroundColor = UIColor .clear
        btnClear.setTitleColor(UIColor(cgColor: colorFromARGB(hex: "B6BCC3").cgColor), for: .normal)
        btnSelected = btn
        btnSelected.backgroundColor = colorFromARGB(hex: "0C385B")
        btnSelected.setTitleColor(UIColor.white, for: .normal)
    }
    
    private func setDate (dateStr:String) -> String{
        
        if dateStr != "" {
            let dateFormatterGet = DateFormatter()
            dateFormatterGet.dateFormat = "MM dd"
            let date = dateFormatterGet.date(from: dateStr)
            
            let localeTR = Locale(identifier: "tr_TR")
            var calendar = Calendar.current
            calendar.locale = localeTR
            let dayInt = calendar.component(.day, from: date!)
            let monthInt = calendar.component(.month, from: date!)
            let monthStr = calendar.monthSymbols[monthInt-1]
            return "\(dayInt) \(monthStr)  /  \(dateStr)"
        }else{
            return ""
        }
        
            
    }
        
    
}

