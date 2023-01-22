//
//  SideMenuViewModel.swift
//  EasyTrader
//
//  Created by Angel Rincon on 12/4/22.
//

import Foundation

enum SideMenuViewModel : Int, CaseIterable {
    case profile
    case logOut
    
    var title: String {
        switch self {
        case .profile: return "Profile"
        case .logOut: return "LogOut"
        }
    }
    
    var imageName: String {
        switch self {
        case .profile: return "person"
        case .logOut: return "arrow.left.square"
        }
    }
    
}
    
