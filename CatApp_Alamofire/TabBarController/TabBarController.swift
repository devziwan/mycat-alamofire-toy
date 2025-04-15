//
//  TabBarVC.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/19/25.
//

import Foundation
import UIKit

class TabBarController: UITabBarController {
    
    // MARK: - Properfies
    static let sheard = TabBarController()
    var previousIndex: Int = 2
    
    var detailPageVC: DetailPageVC?
    
    var tabBarHeght: CGFloat = 0.0
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function, #line, "")
        
        self.navigationController?.isNavigationBarHidden = true
        
        // 탭바컨트롤러 Delgate 설정
        self.delegate = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(goToFavorite), name: .goToFavoriteList, object: nil)
        
        self.tabBarHeght = self.tabBar.frame.height
        print(#file, #function, #line, "tabBarHeght \(tabBarHeght)")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#file, #function, #line, "")
        
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        print(#file, #function, #line, "")
        
        self.navigationController?.isNavigationBarHidden = false
    }

 
    // MARK: - Private Methods
    
    /// 즐겨찾기 화면으로 이동합니다.
    @objc fileprivate func goToFavorite() {
        print(#file, #function, #line, "")

        self.selectedIndex = 3
    }
    
    
} // TabBarController


 // MARK: - UITabBarControllerDelegate

extension TabBarController: UITabBarControllerDelegate {
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        let currentIndex: Int = tabBarController.selectedIndex
        
        if currentIndex == 1 {
            tabBarController.selectedIndex = previousIndex
            print(#file, #function, #line, "\(previousIndex)")
            return
        }
        
        previousIndex = currentIndex
       
    }
    
}


