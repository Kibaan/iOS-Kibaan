//
//  TopViewController.swift
//  KibaanSample
//
//  Created by Keita Yamamoto on 2018/11/08.
//  Copyright © 2018 altonotes Inc. All rights reserved.
//

import Kibaan

class TopViewController: SmartViewController {
    
    // MARK: - Outlets
    
    @IBOutlet weak var stateButton: SmartButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // MARK: - Actions
    
    @IBAction func actionStateChangeButton(_ sender: SmartButton) {
        if (stateButton.isEnabled && stateButton.isSelected) {
            stateButton.isEnabled = false
            stateButton.isSelected = false
        } else if (stateButton.isEnabled) {
            stateButton.isSelected = true
        } else if (!stateButton.isEnabled) {
            stateButton.isEnabled = true
        }
    }
}
