//
//  RaceViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/23/22.
//

import UIKit

class RaceViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var raceLabel: UILabel!
    @IBOutlet weak var weekendLabel: UILabel!
    
    @IBOutlet weak var trackImage: UIImageView!
    @IBOutlet weak var flagImage: UIImageView!
 
    @IBOutlet weak var timeView: UIStackView!
    
    var trackInfo: [[String]] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageHeight = flagImage.frame.height
        let imageWidth = flagImage.frame.width
        
        switch trackInfo[1][0] {
        case "Bahrain Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "bahraingp")
            flagImage.image = #imageLiteral(resourceName: "bahrain")
        case "Saudi Arabian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "saudigp")
            flagImage.image = #imageLiteral(resourceName: "saudi")
        case "Australian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "australiangp")
            flagImage.image = #imageLiteral(resourceName: "australia")
        case "Emilia Romagna Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "ergp")
            flagImage.image = #imageLiteral(resourceName: "italy")
        case "Miami Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "miamigp")
            flagImage.image = #imageLiteral(resourceName: "usa")
        case "Spanish Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "spanishgp")
            flagImage.image = #imageLiteral(resourceName: "spain")
        case "Monaco Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "monacogp")
            flagImage.image = #imageLiteral(resourceName: "monaco")
        case "Azerbaijan Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "azerbaijangp")
            flagImage.image = #imageLiteral(resourceName: "azerbaijan")
        case "Canadian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "canadiangp")
            flagImage.image = #imageLiteral(resourceName: "canada")
        case "British Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "britishgp")
            flagImage.image = #imageLiteral(resourceName: "britain")
        case "Austrian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "austriangp")
            flagImage.image = #imageLiteral(resourceName: "austria")
        case "French Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "frenchgp")
            flagImage.image = #imageLiteral(resourceName: "france")
        case "Hungarian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "hungariangp")
            flagImage.image = #imageLiteral(resourceName: "hungary")
        case "Belgian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "belgiangp")
            flagImage.image = #imageLiteral(resourceName: "belgium")
        case "Dutch Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "dutchgp")
            flagImage.image = #imageLiteral(resourceName: "dutch")
        case "Italian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "italiangp")
            flagImage.image = #imageLiteral(resourceName: "italy")
        case "Singapore Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "singaporegp")
            flagImage.image = #imageLiteral(resourceName: "singapore")
        case "Japanese Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "japanesegp")
            flagImage.image = #imageLiteral(resourceName: "japan")
        case "United States Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "usagp")
            flagImage.image = #imageLiteral(resourceName: "usa")
        case "Mexico City Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "mexicangp")
            flagImage.image = #imageLiteral(resourceName: "mexico")
        case "Brazilian Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "braziliangp")
            flagImage.image = #imageLiteral(resourceName: "brazil")
        case "Abu Dhabi Grand Prix":
            trackImage.image = #imageLiteral(resourceName: "abudhabigp")
            flagImage.image = #imageLiteral(resourceName: "uae")
        default:
            break
        }
        
        flagImage.frame.size = CGSize(width: imageWidth, height: imageHeight)
        raceLabel.text = trackInfo[1][0]
        
        setTimes()
    }
    
    func setTimes() {
        
        weekendLabel.text = getDates(startDay: "\(trackInfo[2][1])T\(trackInfo[2][2])", endDay: "\(trackInfo[6][0])T\(trackInfo[7][0])")
        weekendLabel.font = UIFont(name: "Formula1-Display-Regular", size: 23)
        weekendLabel.textColor = #colorLiteral(red: 0.7961815596, green: 0.3117287159, blue: 0.08521645516, alpha: 1)
        weekendLabel.textAlignment = .right
        weekendLabel.sizeToFit()
        
        var horzStack: UIStackView
        var seshLabel: UILabel
        var timeLabel: UILabel
              
        for time in trackInfo[2...5] {
            horzStack = UIStackView()
            horzStack.axis = .horizontal
            horzStack.distribution = .fillProportionally
            
            seshLabel = UILabel()
            timeLabel = UILabel()
            
            let session = getSession(time[0])
            let day = getDay(time[1])
            let start = getTime("\(time[1])T\(time[2])")
            
            seshLabel.text = "\(session):"       //\(day) \(start)"
            seshLabel.textColor = .black
            seshLabel.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            seshLabel.textAlignment = .left
            
            
            timeLabel.text = "\(day) \(start)"
            timeLabel.textColor = .black
            timeLabel.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            timeLabel.textAlignment = .right
            
            horzStack.addArrangedSubview(seshLabel)
            horzStack.addArrangedSubview(timeLabel)
            
            timeView.addArrangedSubview(horzStack)
        }
        
        horzStack = UIStackView()
        horzStack.axis = .horizontal
        horzStack.distribution = .fillProportionally
        
        seshLabel = UILabel()
        timeLabel = UILabel()
        
        let day = getDay(trackInfo[6][0])
        let start = getTime("\(trackInfo[6][0])T\(trackInfo[7][0])")
        
        seshLabel.text = "Race:"     //\(day) \(start)"
        seshLabel.textColor = .black
        seshLabel.font = UIFont(name: "Formula1-Display-Regular", size: 20)
        seshLabel.textAlignment = .left
        
        timeLabel.text = "\(day) \(start)"
        timeLabel.textColor = .black
        timeLabel.font = UIFont(name: "Formula1-Display-Regular", size: 20)
        timeLabel.textAlignment = .right
        
        horzStack.addArrangedSubview(seshLabel)
        horzStack.addArrangedSubview(timeLabel)
        
        timeView.addArrangedSubview(horzStack)
        
        scrollView.addSubview(timeView)
    }
    
    func getDates(startDay: String, endDay: String) -> String {
        
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
    
    func getSession(_ session: String) -> String {
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
    
    func getDay(_ date: String) -> String {
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
    
    func getTime(_ time: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let dateObj = dateFormatter.date(from:time)!
        
        dateFormatter.dateFormat = "h:mm a z"
        
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.amSymbol = "AM"
        dateFormatter.pmSymbol = "PM"
        
        return dateFormatter.string(from: dateObj)
    }

}
