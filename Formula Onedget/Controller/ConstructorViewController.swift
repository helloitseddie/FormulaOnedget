//
//  ConstructorViewController.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/21/22.
//

import UIKit

class ConstructorViewController: UIViewController {
    
    let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var labelView: UIStackView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let constructorBrain = ConstructorBrain()
        constructorBrain.getConstructors()
        
        setConstructors()
    }
    
    fileprivate func setConstructors() {
        guard let constructorStandings = self.userDefaults?.value(forKey: "constructorStandingsApp") as? [[String]] else { return }
        
        let containerHeight: Float = (50.0 * Float(constructorStandings.count)) + (10.0 * Float(constructorStandings.count))
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: CGFloat(containerHeight))
        
        labelView.frame.size = CGSize(width: scrollView.contentSize.width, height: scrollView.contentSize.height)
        labelView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        labelView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        labelView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        labelView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        labelView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
        var labelBG: UIImageView
        var label: UILabel
        
        for constructor in constructorStandings {
            labelBG = UIImageView()
            labelBG.frame.size = CGSize(width: scrollView.contentSize.width, height: CGFloat(50))
            labelBG.image = #imageLiteral(resourceName: "slotBG")
            
            label = UILabel()
            label.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.width, height: CGFloat(50))
            label.text = "\(constructor[0]). \(constructor[1]) \(constructor[2])PTS"
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
extension ConstructorViewController {
    @IBAction func navigateToDriver(_ sender: UIButton) {
        let viewController:UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DriverView") as UIViewController
        viewController.modalPresentationStyle = .fullScreen
        self.present(viewController, animated: true, completion: nil)
    }
}
