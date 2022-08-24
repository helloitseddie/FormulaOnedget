//
//  ScheduleViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/23/22.
//

import UIKit

class ScheduleViewController: UIViewController {

    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    @IBOutlet weak var driverButt: UIButton!
    @IBOutlet weak var constButt: UIButton!
    @IBOutlet weak var scheduleButt: UIButton!
    @IBOutlet weak var plsButt: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverButt.imageView?.alpha = 0.5
        constButt.imageView?.alpha = 0.5
        scheduleButt.imageView?.alpha = 1
        plsButt.imageView?.alpha = 0.5
        
        let scheduleBrain = ScheduleBrain()
        scheduleBrain.getSchedule()
        
        setSchedule()
    }
    
    fileprivate func setSchedule() {
        guard let schedule = self.userDefaults?.value(forKey: "scheduleApp") as? [[[String]]] else { return }
        
        let containerHeight: Float = (100.0 * Float(schedule.count)) + (10.0 * Float(schedule.count))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(containerHeight))
        
        labelView.frame.size = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        labelView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        labelView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        labelView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        labelView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.isUserInteractionEnabled = true
        labelView.isUserInteractionEnabled = true
        
        var labelBG: UIImageView
        var butt: UIButton
        var isNextRace = true
        
        var offset: Float = 0
        
        for race in schedule {
            labelBG = UIImageView()
            labelBG.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(100))
            labelBG.image = #imageLiteral(resourceName: "slotBG")
            labelBG.isUserInteractionEnabled = true
            
            butt = UIButton()
            butt.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: CGFloat(100))
            butt.setTitle("\(race[0][0]). \(race[1][0])", for: .normal)
                                 
            if checkDate("\(race[6][0])T\(race[7][0])") && isNextRace {
                butt.setTitleColor(#colorLiteral(red: 0.7961815596, green: 0.3117287159, blue: 0.08521645516, alpha: 1), for: .normal)
                offset = (Float(scrollView.contentSize.height) / Float(schedule.count) * Float(Int(race[0][0])!))
                offset -= Float(scrollView.frame.height / 2)
                self.userDefaults?.setValue(formatRace(race), forKey: "schedule")
                isNextRace = false
            } else {
                butt.setTitleColor(.black, for: .normal)
            }
                                 
            butt.titleLabel?.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            butt.titleLabel?.textAlignment = .center
            butt.tag = Int(race[0][0])! - 1
            butt.isUserInteractionEnabled = true
            butt.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
            
            butt.center = labelBG.center
            labelBG.addSubview(butt)
            labelView.addArrangedSubview(labelBG)
        }
        
        scrollView.addSubview(labelView)
        
        if isNextRace {
            scrollView.contentOffset.y = CGFloat(scrollView.contentSize.height)
        } else {
            scrollView.contentOffset.y = CGFloat(offset)
        }
    }
    
    fileprivate func checkDate(_ date: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.date(from:date)!
        let todaysDate = Date()
        
        return todaysDate < dateObj
    }
    
    @objc func buttonClicked(sender: UIButton) {
        guard let schedule = self.userDefaults?.value(forKey: "scheduleApp") as? [[[String]]] else { return }
        
        let viewController = storyboard?.instantiateViewController(withIdentifier: "RaceView") as! RaceViewController
        let nc = UINavigationController(rootViewController: viewController)
        viewController.trackInfo = schedule[sender.tag]
        self.present(nc, animated: true, completion: nil)
    }
    
    fileprivate func formatRace(_ race: [[String]]) -> [[String]] {
        var formRace: [[String]] = []
        var tempVal: [String] = []
        
        formRace.append(race[0]) // round
        formRace.append([getDates(startDay: "\(race[2][1])T\(race[2][2])", endDay: "\(race[6][0])T\(race[7][0])")]) // week dates
        formRace.append(race[1]) // race
        
        for time in race[2...5] { // non-race times
            tempVal.append(getSession(time[0]))
            tempVal.append(getTime("\(time[1])T\(time[2])"))
            formRace.append(tempVal)
            tempVal = []
        }
        
        tempVal.append("Race") // race times
        tempVal.append(getTime("\(race[6][0])T\(race[7][0])"))
        formRace.append(tempVal)
        
        formRace.append(widgetImages(race[1][0])) // images
        
        return formRace
    }
    
    fileprivate func getDates(startDay: String, endDay: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let startDayObj = dateFormatter.date(from:startDay)!
        let endDayObj = dateFormatter.date(from:endDay)!
        
        dateFormatter.dateFormat = "LLLL"
        var startMonth = dateFormatter.string(from: startDayObj)
        var endMonth = dateFormatter.string(from: endDayObj)
        let index = startMonth.index(startMonth.startIndex, offsetBy: 3)
        startMonth = String(startMonth[..<index])
        endMonth = String(endMonth[..<index])
        
        let start = Calendar.current.dateComponents([.day], from: startDayObj).day!
        let end = Calendar.current.dateComponents([.day], from: endDayObj).day!
        
        return "\(startMonth) \(start) - \(endMonth) \(end)"
    }
    
    fileprivate func getSession(_ session: String) -> String {
        switch(session) {
        case "FirstPractice":
            return "FP1"
        case "SecondPractice":
            return "FP2"
        case "ThirdPractice":
            return "FP3"
        case "Qualifying":
            return "Q1"
        default:
            return "Sprint"
        }
    }
    
    fileprivate func getDay(_ date: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let dateObj = dateFormatter.date(from:date)!
        
        let day = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: dateObj) - 1]
        var formDay = String(day)
        let index = formDay.index(formDay.startIndex, offsetBy: 3)
        formDay = String(formDay[..<index])
        
        return formDay
    }
    
    fileprivate func getTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj = dateFormatter.date(from:time)!
        
        dateFormatter.dateFormat = "h:mm a z"
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: dateObj)
    }
    
    fileprivate func widgetImages(_ race: String) -> [String] {
        switch race {
        case "Bahrain Grand Prix":
            return ["bahraingp", "bahrain"]
        case "Saudi Arabian Grand Prix":
            return ["saudigp", "saudi"]
        case "Australian Grand Prix":
            return ["australia", "australiangp"]
        case "Emilia Romagna Grand Prix":
            return ["ergp", "italy"]
        case "Miami Grand Prix":
            return ["miamigp", "usa"]
        case "Spanish Grand Prix":
            return ["spanishgp", "spain"]
        case "Monaco Grand Prix":
            return ["monaco", "monaco"]
        case "Azerbaijan Grand Prix":
            return ["azerbaijangp", "azerbaijan"]
        case "Canadian Grand Prix":
            return ["canadiangp", "canada"]
        case "British Grand Prix":
            return ["britishgp", "britain"]
        case "Austrian Grand Prix":
            return ["austriangp", "austria"]
        case "French Grand Prix":
            return ["frenchgp", "france"]
        case "Hungarian Grand Prix":
            return ["hungariangp", "hungary"]
        case "Belgian Grand Prix":
            return ["belgiangp", "belgium"]
        case "Dutch Grand Prix":
            return ["dutchgp", "dutch"]
        case "Italian Grand Prix":
            return ["italiangp", "italy"]
        case "Singapore Grand Prix":
            return ["singaporegp", "singapore"]
        case "Japanese Grand Prix":
            return ["japanesegp", "japan"]
        case "United States Grand Prix":
            return ["usagp", "usa"]
        case "Mexico City Grand Prix":
            return ["mexicangp", "mexico"]
        case "Brazilian Grand Prix":
            return ["braziliangp", "brazil"]
        case "Abu Dhabi Grand Prix":
            return ["abudhabigp", "uae"]
        default:
            return []
        }
    }
    
}

// MARK - Navigation
extension ScheduleViewController {
    @IBAction func navigateToConstructor(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConstructorView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
    
    @IBAction func navigateToDriver(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
}
