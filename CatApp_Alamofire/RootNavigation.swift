//
//  RootNavigation.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 4/3/25.
//

import Foundation
import UIKit

class RootNavigation: UINavigationController {
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function, #line, "")
        
        self.navigationController?.isNavigationBarHidden = true

    }
}
