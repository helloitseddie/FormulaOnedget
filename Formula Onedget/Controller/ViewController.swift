//
//  ViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 6/2/22.
//

import UIKit
import WidgetKit
import SwiftSoup

class ViewController: UIViewController {

    @IBOutlet weak var p1Name: UILabel!
    @IBOutlet weak var p1Points: UILabel!
    @IBOutlet weak var p2Name: UILabel!
    @IBOutlet weak var p2Points: UILabel!
    @IBOutlet weak var p3Name: UILabel!
    @IBOutlet weak var p3Points: UILabel!
    

    @IBOutlet weak var c1Name: UILabel!
    @IBOutlet weak var c1Points: UILabel!
    @IBOutlet weak var c2Name: UILabel!
    @IBOutlet weak var c2Points: UILabel!
    @IBOutlet weak var c3Name: UILabel!
    @IBOutlet weak var c3Points: UILabel!
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let driverBrain = DriverBrain()
        driverBrain.getDrivers()
        setDrivers()
        
        let constructorBrain = ConstructorBrain()
        constructorBrain.getConstructors()
        setConstructors()
        
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    func setDrivers() {
        let p1NameData = userDefaults!.value(forKey: "p1FullName") as? String ?? "Eddie Briscoe"
        let p2NameData = userDefaults!.value(forKey: "p2FullName") as? String ?? "Carola Sague"
        let p3NameData = userDefaults!.value(forKey: "p3FullName") as? String ?? "Fede Diago"
        
        let p1PointsData = userDefaults!.value(forKey: "p1Points") as? String ?? "3"
        let p2PointsData = userDefaults!.value(forKey: "p2Points") as? String ?? "2"
        let p3PointsData = userDefaults!.value(forKey: "p3Points") as? String ?? "1"
        
        self.p1Name.text = p1NameData
        self.p1Points.text = p1PointsData
        self.p2Name.text = p2NameData
        self.p2Points.text = p2PointsData
        self.p3Name.text = p3NameData
        self.p3Points.text = p3PointsData
    }
    
    func setConstructors() {
        let c1NameData = userDefaults!.value(forKey: "c1Name") as? String ?? "Briscoe Cars"
        let c2NameData = userDefaults!.value(forKey: "c2Name") as? String ?? "Sague Cars"
        let c3NameData = userDefaults!.value(forKey: "c3Name") as? String ?? "Diago Cars"
        
        let c1PointsData = userDefaults!.value(forKey: "c1Points") as? String ?? "3"
        let c2PointsData = userDefaults!.value(forKey: "c2Points") as? String ?? "2"
        let c3PointsData = userDefaults!.value(forKey: "c3Points") as? String ?? "1"
        
        
        self.c1Name.text = c1NameData
        self.c1Points.text = c1PointsData
        self.c2Name.text = c2NameData
        self.c2Points.text = c2PointsData
        self.c3Name.text = c3NameData
        self.c3Points.text = c3PointsData
    }
}




