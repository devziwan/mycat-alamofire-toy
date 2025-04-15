//
//  Notification+Name.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 4/9/25.
//

import Foundation


extension Notification.Name {
    
    static let uploadEvent = Notification.Name("uploadImageSuccess")
    static let uploadSuccessToastEvenet = Notification.Name(rawValue: "uploadSuccessToastEvenet")
    static let goToFavoriteList = Notification.Name(rawValue: "goToFavoriteList")
    static let uploadDidSuccess: Notification.Name = Notification.Name("uploadDidSuccess")
}
