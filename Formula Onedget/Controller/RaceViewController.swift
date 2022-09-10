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
    
    var trackInfo: IndividualRace? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let safeTrack = trackInfo else { return }
        raceLabel.text = safeTrack.raceName
        
        setTimes()
    }
    
    func setTimes() {
//        guard let safeTrack = trackInfo else { return }
        scrollView.contentSize = CGSize(width: scrollView.frame.width, height: 250)
        
        let infoView = UIStackView()
        infoView.frame.size = scrollView.contentSize
        infoView.axis = .vertical
        
        let headerView = UIStackView()
        headerView.axis = .horizontal
        
        let trackView = UIImageView()
        trackView.frame.size = CGSize(width: scrollView.frame.width * 0.6, height: scrollView.frame.width * 0.6)
        trackView.image = #imageLiteral(resourceName: "mexicangp")
        headerView.addArrangedSubview(trackView)
//        trackView.translatesAutoresizingMaskIntoConstraints = false
//        trackView.heightAnchor.constraint(equalToConstant: trackView.frame.height).isActive = true
//        trackView.widthAnchor.constraint(equalToConstant: trackView.frame.width).isActive = true
        
        let flagView = UIImageView()
        flagView.frame.size = CGSize(width: scrollView.frame.width * 0.4, height: scrollView.frame.width * 0.4)
        flagView.image = #imageLiteral(resourceName: "germany")
        headerView.addArrangedSubview(flagView)
//        flagView.translatesAutoresizingMaskIntoConstraints = false
//        flagView.heightAnchor.constraint(equalToConstant: flagView.frame.height).isActive = true
//        flagView.widthAnchor.constraint(equalToConstant: flagView.frame.width).isActive = true
        
        infoView.addArrangedSubview(headerView)
        scrollView.addSubview(infoView)
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
    
//    func setImages(_ raceName: String) {
//        switch raceName {
//        case "Bahrain Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "bahraingp")
//            flagImage.image = #imageLiteral(resourceName: "bahrain")
//        case "Saudi Arabian Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "saudigp")
//            flagImage.image = #imageLiteral(resourceName: "saudi")
//        case "Australian Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "australiangp")
//            flagImage.image = #imageLiteral(resourceName: "australia")
//        case "Emilia Romagna Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "ergp")
//            flagImage.image = #imageLiteral(resourceName: "italy")
//        case "Miami Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "miamigp")
//            flagImage.image = #imageLiteral(resourceName: "usa")
//        case "Spanish Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "spanishgp")
//            flagImage.image = #imageLiteral(resourceName: "spain")
//        case "Monaco Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "monacogp")
//            flagImage.image = #imageLiteral(resourceName: "monaco")
//        case "Azerbaijan Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "azerbaijangp")
//            flagImage.image = #imageLiteral(resourceName: "azerbaijan")
//        case "Canadian Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "canadiangp")
//            flagImage.image = #imageLiteral(resourceName: "canada")
//        case "British Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "britishgp")
//            flagImage.image = #imageLiteral(resourceName: "britain")
//        case "Austrian Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "austriangp")
//            flagImage.image = #imageLiteral(resourceName: "austria")
//        case "French Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "frenchgp")
//            flagImage.image = #imageLiteral(resourceName: "france")
//        case "Hungarian Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "hungariangp")
//            flagImage.image = #imageLiteral(resourceName: "hungary")
//        case "Belgian Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "belgiangp")
//            flagImage.image = #imageLiteral(resourceName: "belgium")
//        case "Dutch Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "dutchgp")
//            flagImage.image = #imageLiteral(resourceName: "dutch")
//        case "Italian Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "italiangp")
//            flagImage.image = #imageLiteral(resourceName: "italy")
//        case "Singapore Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "singaporegp")
//            flagImage.image = #imageLiteral(resourceName: "singapore")
//        case "Japanese Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "japanesegp")
//            flagImage.image = #imageLiteral(resourceName: "japan")
//        case "United States Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "usagp")
//            flagImage.image = #imageLiteral(resourceName: "usa")
//        case "Mexico City Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "mexicangp")
//            flagImage.image = #imageLiteral(resourceName: "mexico")
//        case "Brazilian Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "braziliangp")
//            flagImage.image = #imageLiteral(resourceName: "brazil")
//        case "Abu Dhabi Grand Prix":
//            trackImage.image = #imageLiteral(resourceName: "abudhabigp")
//            flagImage.image = #imageLiteral(resourceName: "uae")
//        default:
//            break
//        }
//    }

}
