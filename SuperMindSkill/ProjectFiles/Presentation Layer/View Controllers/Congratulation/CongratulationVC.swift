
//
//  CongratulationVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 30/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit

class CongratulationVC: BaseViewController {
    @IBOutlet var btnContinue:UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        btnContinue.layer.borderWidth = 2.0
        btnContinue.layer.cornerRadius = btnContinue.frame.size.height / 2
        btnContinue.layer.borderColor = UIColor.white.cgColor
    }
}
extension CongratulationVC{
    @IBAction func buttonDidtapNext(_ sender: UIButton){
        
            guard let navigationController = self.navigationController else { return }
            let navigationArray = navigationController.viewControllers // To get all UIViewController stack as Array
            if  navigationArray.count > 4{
             self.navigationController!.popToViewController(navigationArray[navigationArray.count - 4], animated: true)
            }
    //        navigationArray.remove(at: navigationArray.count - 2) // To remove previous UIViewController
    //        self.navigationController?.viewControllers = navigationArray
            
        }
}
