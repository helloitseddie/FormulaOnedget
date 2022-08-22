//
//  DriverViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/21/22.
//

import UIKit

class DriverViewController: UIViewController {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    @IBOutlet weak var driverButt: UIButton!
    @IBOutlet weak var constButt: UIButton!
    @IBOutlet weak var scheduleButt: UIButton!
    @IBOutlet weak var plsButt: UIButton!
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        driverButt.imageView?.alpha = 1
        constButt.imageView?.alpha = 0.5
        scheduleButt.imageView?.alpha = 0.5
        plsButt.imageView?.alpha = 0.5
        
        let driverBrain = DriverBrain()
        driverBrain.getDrivers()
        
        setDrivers()
    }
    
    fileprivate func setDrivers() {
        guard let driverStandings = self.userDefaults?.value(forKey: "driverStandingsApp") as? [[String]] else { return }
        
        let containerHeight: Float = (50.0 * Float(driverStandings.count)) + (10.0 * Float(driverStandings.count))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(containerHeight))
        
        labelView.frame.size = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        labelView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        labelView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        labelView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        labelView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        var labelBG: UIImageView
        var label: UILabel
        
        for driver in driverStandings {
            labelBG = UIImageView()
            labelBG.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(50))
            labelBG.image = #imageLiteral(resourceName: "slotBG")
            
            label = UILabel()
            label.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: CGFloat(50))
            label.text = "\(driver[0]). \(driver[1]) \(driver[2])PTS"
            label.font = UIFont(name: "Formula1-Display-Regular", size: 20)
            label.textAlignment = .center
            label.sizeToFit()
            
            label.center = labelBG.center
            labelBG.addSubview(label)
            labelView.addArrangedSubview(labelBG)
        }
        
        scrollView.addSubview(labelView)
    }
    
}

// MARK - Navigation
extension DriverViewController {
    @IBAction func navigateToConstructor(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ConstructorView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: false, completion: nil)
    }
}
