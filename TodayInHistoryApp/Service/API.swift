//
//  API.swift
//  TodayInHistoryApp
//
//  Created by Dağhan KILIÇAY on 20.02.2020.
//  Copyright © 2020 Dağhan KILIÇAY. All rights reserved.
//

import UIKit

class API: NSObject {
    func getHistory(callback:@escaping([DetailContenList.detailContenTypes:DetailContenList]?, String?) -> Void){
        
        var request = URLRequest(url: URL(string: "\(Def.baseUrl)")!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
        var returnData : [DetailContenList.detailContenTypes:DetailContenList] = [:]
            if error == nil {
                DispatchQueue.main.async {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data!) as! Dictionary<String, Any>
                            
                        let historyList = DetailContenList.init()
                        let historyDetail = Detail(history:json)
                        historyList.DetailContents.append(historyDetail)
                        returnData[DetailContenList.detailContenTypes.History] = historyList
                        
                        if let data = json["data"] as? [String:[Any]] {
                                
                            for keys in data.keys {
                                if keys == "Events"{
                                    let eventList = DetailContenList.init()
                                    for detail in (data[keys])! {
                                        let eventDetail = Detail(item: detail as! [String : Any])
                                        eventList.DetailContents.append(eventDetail)
                                    }
                                    returnData[DetailContenList.detailContenTypes.Events] = eventList
                                                   
                                }else if keys == "Deaths" {
                                    let deathList = DetailContenList.init()
                                    for detail in (data[keys])! {
                                        let deathDetail = Detail(item: detail as! [String : Any])
                                        deathList.DetailContents.append(deathDetail)
                                    }
                                    returnData[DetailContenList.detailContenTypes.Deaths] = deathList
                                }else {
                                    let birthList = DetailContenList.init()
                                    for detail in (data[keys])!{
                                        let birthDetail = Detail(item: detail as! [String : Any])
                                        birthList.DetailContents.append(birthDetail)
                                    }
                                    returnData[DetailContenList.detailContenTypes.Births] = birthList
                                }
                            }
                            callback(returnData ,nil)
                        }else{
                            callback(nil,"Beklenmedik bir hata oluştu")
                        }
                    } catch {
                        callback(nil,error.localizedDescription)
                    }
                }
                    
            }else{
                callback(nil,error?.localizedDescription)
            }
        })
        task.resume()
    }
}
