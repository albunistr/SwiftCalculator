//
//  ViewController.swift
//  TinkoffCalculator
//
//  Created by Powers Mikaela on 28.03.2024.
//

import UIKit

class ViewController: UIViewController {

    @IBAction func buttonPassed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else {return
                        
        }
        print(buttonText)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}
