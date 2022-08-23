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
