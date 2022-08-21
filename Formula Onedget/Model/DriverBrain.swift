//
//  DriverBrain.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 6/3/22.
//

import UIKit
import WidgetKit
import SwiftSoup

struct DriverBrain {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    func getDrivers() {
        if let url = URL(string: "https://ergast.com/api/f1/current/driverStandings?limit=5") {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url, completionHandler: handleDrivers(data:response:error:))
            task.resume()
            task.suspend()
        }
    }
        
    func handleDrivers(data: Data?, response: URLResponse?, error: Error?) {
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)

            do {
                let html: String = dataString!
                let doc: Document = try SwiftSoup.parse(html)
                let standings: Elements = try doc.select("DriverStanding")
                var driver: Element
                var pos: Int

                var p1NameData: String = ""
                var p1LastNameData: String = ""
                var p1PointsData: String = ""
                var p2NameData: String = ""
                var p2LastNameData: String = ""
                var p2PointsData: String = ""
                var p3NameData: String = ""
                var p3LastNameData: String = ""
                var p3PointsData: String = ""
                var p4LastNameData: String = ""
                var p4PointsData: String = ""
                var p5LastNameData: String = ""
                var p5PointsData: String = ""

                for standing in standings {
                    driver = try standing.select("Driver").first()!
                    pos = try Int(standing.attr("position"))!

                    if pos == 1 {
                        p1NameData = try driver.select("GivenName").first()!.text()
                        p1NameData += try " " + driver.select("FamilyName").first()!.text()
                        p1LastNameData = try driver.select("FamilyName").first()!.text()
                        p1PointsData = try standing.attr("points")
                    } else if (pos == 2) {
                        p2NameData = try driver.select("GivenName").first()!.text()
                        p2NameData += try " " + driver.select("FamilyName").first()!.text()
                        p2LastNameData = try driver.select("FamilyName").first()!.text()
                        p2PointsData = try standing.attr("points")
                    } else if (pos == 3) {
                        p3NameData = try driver.select("GivenName").first()!.text()
                        p3NameData += try " " + driver.select("FamilyName").first()!.text()
                        p3LastNameData = try driver.select("FamilyName").first()!.text()
                        p3PointsData = try standing.attr("points")
                    } else if (pos == 4) {
                        p4LastNameData = try driver.select("FamilyName").first()!.text()
                        p4PointsData = try standing.attr("points")
                    } else if (pos == 5) {
                        p5LastNameData = try driver.select("FamilyName").first()!.text()
                        p5PointsData = try standing.attr("points")
                    }

                }

                DispatchQueue.main.async {

                    self.userDefaults?.setValue(p1NameData, forKey: "p1FullName")
                    self.userDefaults?.setValue(p1LastNameData, forKey: "p1Name")
                    self.userDefaults?.setValue(p1PointsData, forKey: "p1Points")
                    self.userDefaults?.setValue(p2NameData, forKey: "p2FullName")
                    self.userDefaults?.setValue(p2LastNameData, forKey: "p2Name")
                    self.userDefaults?.setValue(p2PointsData, forKey: "p2Points")
                    self.userDefaults?.setValue(p3NameData, forKey: "p3FullName")
                    self.userDefaults?.setValue(p3LastNameData, forKey: "p3Name")
                    self.userDefaults?.setValue(p3PointsData, forKey: "p3Points")
                    self.userDefaults?.setValue(p4LastNameData, forKey: "p4Name")
                    self.userDefaults?.setValue(p4PointsData, forKey: "p4Points")
                    self.userDefaults?.setValue(p5LastNameData, forKey: "p5Name")
                    self.userDefaults?.setValue(p5PointsData, forKey: "p5Points")

                }
            } catch Exception.Error(_, let message) {
                print(message)
            } catch {
                print("error")
            }
            
        }
    }
}
