//
//  ConstructorBrain.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 6/3/22.
//

import UIKit
import WidgetKit
import SwiftSoup

struct ConstructorBrain {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    func getConstructors() {
        if let url = URL(string: "https://ergast.com/api/f1/current/constructorStandings?limit=5") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleConstructors(data:response:error:))
            task.resume()
            task.suspend()
        }
    }
    
    func handleConstructors(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            
            do {
                let html: String = dataString!
                let doc: Document = try SwiftSoup.parse(html)
                let standings: Elements = try doc.select("ConstructorStanding")
                var constructor: Element
                var pos: Int = 1
                
                var c1NameData: String = ""
                var c1PointsData: String = ""
                var c2NameData: String = ""
                var c2PointsData: String = ""
                var c3NameData: String = ""
                var c3PointsData: String = ""
                var c4NameData: String = ""
                var c4PointsData: String = ""
                var c5NameData: String = ""
                var c5PointsData: String = ""
            
                for standing in standings {
                    pos = try Int(standing.attr("position"))!
                    constructor = try standing.select("Constructor").first()!
                    
                    switch (pos) {
                        case 1:
                            c1NameData = try constructor.select("Name").first()!.text()
                            c1PointsData = try standing.attr("points")
                        case 2:
                            c2NameData = try constructor.select("Name").first()!.text()
                            c2PointsData = try standing.attr("points")
                        case 3:
                            c3NameData = try constructor.select("Name").first()!.text()
                            c3PointsData = try standing.attr("points")
                        case 4:
                            c4NameData = try constructor.select("Name").first()!.text()
                            c4PointsData = try standing.attr("points")
                        case 5:
                            c5NameData = try constructor.select("Name").first()!.text()
                            c5PointsData = try standing.attr("points")
                        default:
                            print("Error")
                    }
                }
                
                DispatchQueue.main.async {
                    self.userDefaults?.setValue(c1NameData, forKey: "c1Name")
                    self.userDefaults?.setValue(c1PointsData, forKey: "c1Points")
                    self.userDefaults?.setValue(c2NameData, forKey: "c2Name")
                    self.userDefaults?.setValue(c2PointsData, forKey: "c2Points")
                    self.userDefaults?.setValue(c3NameData, forKey: "c3Name")
                    self.userDefaults?.setValue(c3PointsData, forKey: "c3Points")
                    self.userDefaults?.setValue(c4NameData, forKey: "c4Name")
                    self.userDefaults?.setValue(c4PointsData, forKey: "c4Points")
                    self.userDefaults?.setValue(c5NameData, forKey: "c5Name")
                    self.userDefaults?.setValue(c5PointsData, forKey: "c5Points")
                }
                
            } catch Exception.Error(_, let message) {
                print(message)
            } catch {
                print("error")
            }
            
        }
    }
}
