//
//  ViewController.swift
//  RotatingWheel
//
//  Created by Luca Kaufmann on 01/05/2018.
//  Copyright © 2018 Luca Kaufmann. All rights reserved.
//

import UIKit

class ViewController: UIViewController, RotatingWheelProtocol {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let wheel = RotatingWheel(frame: CGRect(x: 0, y: 0, width: 200, height: 200),
                                  delegate: self,
                                  sections: 9)
        self.view.addSubview(wheel)
        wheel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        wheel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        wheel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        wheel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func wheelDidChange(value: String) {
        return
    }
    
}

