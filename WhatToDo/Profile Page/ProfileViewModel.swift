//
//  ProfileViewModel.swift
//  WhatToDo
//
//  Created by FUTURE on 2023/09/20.
//

import Foundation

class ProfileViewModel {
    var profile: ProfileModel
    
    var userName: String {
        return profile.userName
    }
    
    var userAge: String {
        return "\(profile.userAge) 세"
    }
    
    init(profile: ProfileModel) {
        self.profile = profile
    }
}
