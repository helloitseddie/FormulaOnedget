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
        guard let schedule = self.userDefaults?.value(forKey: "scheduleApp") as? [Data] else { return }
        
        let containerHeight: Float = (100.0 * Float(schedule.count)) + 100 + (5.0 * Float(schedule.count - 1))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(containerHeight))
        
        labelView.frame.size = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        labelView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        labelView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        labelView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        labelView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        scrollView.isUserInteractionEnabled = true
        labelView.isUserInteractionEnabled = true
        labelView.translatesAutoresizingMaskIntoConstraints = false
        
        var labelContainer: UIView
        var labelBG: UIImageView
        var raceInfo: UIStackView
        
        var raceName: UILabel
        
        var isNextRace = true
        var offset: Float = 0
        
        var raceButt: UIButton
        
        var leftSection: UIStackView
        var middleSection: UIStackView
        var rightSection: UIStackView
        
        var timerView: UIView
        
        for raceRaw in schedule {
            guard let race = try? JSONDecoder().decode(ScheduleInfo.self, from: raceRaw) else { return }
            labelContainer = UIView()
            labelContainer.isUserInteractionEnabled = true
            labelContainer.translatesAutoresizingMaskIntoConstraints = false
            
            labelBG = UIImageView()
            labelBG.image = #imageLiteral(resourceName: "slotBG")
            
            timerView = UIView()
            
            raceButt = UIButton()
            raceButt.backgroundColor = .clear
            raceButt.tag = race.round - 1
            raceButt.addTarget(self, action: #selector(self.buttonClicked), for: .touchUpInside)
            
            raceName = UILabel()
                                 
            if checkDate("\(race.race.date)T\(race.race.time)") && isNextRace {
                raceName.textColor = #colorLiteral(red: 0.7961815596, green: 0.3117287159, blue: 0.08521645516, alpha: 1)
                offset = (Float(scrollView.contentSize.height) / Float(schedule.count) * Float(race.round))
                offset -= (Float(scrollView.frame.height / 2) + 50)
//                self.userDefaults?.setValue(formatRace(race), forKey: "schedule")
                
                labelContainer.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(200))
                labelContainer.heightAnchor.constraint(equalToConstant: CGFloat(200)).isActive = true
                labelBG.frame.size = CGSize(width: scrollView.contentSize.width - 20, height: CGFloat(200))
                
                timerView.backgroundColor = #colorLiteral(red: 0.7961815596, green: 0.3117287159, blue: 0.08521645516, alpha: 1)
                timerView.frame.size = CGSize(width: labelBG.frame.width, height: CGFloat(100))
                timerView.center.x = labelContainer.center.x
                timerView.center.y = labelContainer.center.y + 50
                
                raceButt.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(200))
                raceButt.center = labelContainer.center
                
                isNextRace = false
            } else {
                raceName.textColor = .black
                labelContainer.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(100))
                labelContainer.heightAnchor.constraint(equalToConstant: CGFloat(100)).isActive = true
                labelBG.frame.size = CGSize(width: scrollView.contentSize.width - 20, height: CGFloat(100))
                
                raceButt.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(100))
                raceButt.center = labelContainer.center
            }
            
            labelContainer.addSubview(labelBG)
            
            raceInfo = UIStackView()
            raceInfo.axis = .horizontal
            raceInfo.frame.size = CGSize(width: labelBG.frame.width, height: CGFloat(100))
            raceInfo.center.x = labelBG.center.x

            leftSection = UIStackView()
            leftSection.axis = .vertical
            leftSection.distribution = .fillEqually
            leftSection.spacing = 5
            leftSection.frame.size = CGSize(width: raceInfo.frame.width / 5, height: raceInfo.frame.height)

            middleSection = UIStackView()
            middleSection.frame.size = CGSize(width: raceInfo.frame.width * 0.6, height: labelBG.frame.height - 10)
            middleSection.axis = .vertical
            middleSection.spacing = -8
            middleSection.distribution = .fillEqually

            rightSection = UIStackView()
            rightSection.frame.size = CGSize(width: raceInfo.frame.width / 5, height: raceInfo.frame.height)

            // Left
            let round = UILabel()
            round.text = "  Round\n  \(race.round)"
            round.numberOfLines = 0
            round.frame.size = CGSize(width: leftSection.frame.width, height: raceInfo.frame.height / 4)
            round.widthAnchor.constraint(equalToConstant: leftSection.frame.width).isActive = true
            round.font = UIFont(name: "Formula1-Display-Regular", size: 14)
            round.textColor = .black
            round.textAlignment = .center
            round.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            round.layer.borderWidth = 5
            round.layer.cornerRadius = 8
            leftSection.addArrangedSubview(round)

            // Mid
            let raceLocale = UILabel()
            raceLocale.numberOfLines = 0
            raceLocale.text = "\(race.city), \(race.country)"
            raceLocale.frame.size = CGSize(width: middleSection.frame.width, height: 12.5)
            raceLocale.font = UIFont(name: "Formula1-Display-Regular", size: 14)
            raceLocale.textAlignment = .left
            raceLocale.sizeToFit()

            raceName.text = "\(race.raceName)"
            raceName.frame.size = CGSize(width: middleSection.frame.width, height: 18.5)
            raceName.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            raceName.adjustsFontSizeToFitWidth = true
            raceName.textAlignment = .left
            raceName.sizeToFit()

            let raceCircuit = UILabel()
            raceCircuit.numberOfLines = 0
            raceCircuit.text = race.circuitName
            raceCircuit.frame.size = CGSize(width: middleSection.frame.width, height: 12.5)
            raceCircuit.font = UIFont(name: "Formula1-Display-Regular", size: 14)
            raceCircuit.textAlignment = .left
            raceCircuit.sizeToFit()

            raceLocale.textColor = raceName.textColor
            raceCircuit.textColor = raceName.textColor
            
            middleSection.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            middleSection.layer.borderWidth = 5
            middleSection.layer.cornerRadius = 8

            middleSection.addArrangedSubview(raceLocale)
            middleSection.addArrangedSubview(raceName)
            middleSection.addArrangedSubview(raceCircuit)

            // Right
            let weekend = UILabel()
            let weekendText = getDates(startDay: "\(race.fp1.date)T\(race.fp1.time)", endDay: "\(race.race.date)T\(race.race.time)")
            let weekendArr = weekendText.components(separatedBy: " - ")
            weekend.text = "\(weekendArr[0])\n-\n\(weekendArr[1])"
            weekend.numberOfLines = 0
            weekend.frame.size = CGSize(width: rightSection.frame.width, height: raceInfo.frame.height)
            weekend.widthAnchor.constraint(equalToConstant: rightSection.frame.width).isActive = true
            weekend.frame.size = CGSize(width: rightSection.frame.width, height: raceInfo.frame.height)
            weekend.font = UIFont(name: "Formula1-Display-Regular", size: 14)
            weekend.textAlignment = .center
            weekend.sizeToFit()
            weekend.layer.borderColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            weekend.layer.borderWidth = 5
            weekend.layer.cornerRadius = 8
            rightSection.addArrangedSubview(weekend)

            raceInfo.addArrangedSubview(leftSection)
            raceInfo.addArrangedSubview(middleSection)
            raceInfo.addArrangedSubview(rightSection)
            raceInfo.center.x = labelContainer.center.x
            rightSection.trailingAnchor.constraint(equalTo: raceInfo.trailingAnchor, constant: 20).isActive = true

            labelContainer.addSubview(raceInfo)
            raceInfo.topAnchor.constraint(equalTo: labelContainer.topAnchor).isActive = true
            
            labelContainer.addSubview(timerView)
            labelContainer.addSubview(raceButt)
            labelView.addArrangedSubview(labelContainer)
            
            labelBG.center = labelContainer.center
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
            tempVal.append("\(getDay("\(time[1])")) \(getTime("\(time[1])T\(time[2])"))")
            formRace.append(tempVal)
            tempVal = []
        }
        
        tempVal.append("Race") // race times
        tempVal.append("\(getDay("\(race[6][0])")) \(getTime("\(race[6][0])T\(race[7][0])"))")
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
