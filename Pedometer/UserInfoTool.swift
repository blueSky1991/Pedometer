//
//  UserInfoTool.swift
//  Pedometer
//
//  Created by 张东东 on 2017/5/10.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit


class UserInfoTool: NSObject {
    
    
    
    static var shareInstance:UserInfoTool{
        struct Static{
            static let instance:UserInfoTool = UserInfoTool()
        }
        return Static.instance
    }
    private override init() {}
    
    
     func saveUserInfo(info:UserInfo) {
    
        let userTool = UserDefaults.standard
        userTool.set(info.user_name, forKey: "user_name")
        userTool.set(info.user_password, forKey: "user_password")
        userTool.set(info.user_phone, forKey: "user_phone")
        userTool.set(info.user_emali, forKey: "user_emali")
        userTool.set(info.user_gender, forKey: "user_gender")
        userTool.synchronize()
        
    }
    
     func readUserInfo()-> UserInfo{
        let userTool = UserDefaults.standard
        let user:UserInfo = UserInfo()
        user.user_gender = userTool.string(forKey: "user_gender")
        user.user_name = userTool.string(forKey: "user_name")
        user.user_password = userTool.string(forKey: "user_password")
        user.user_phone = userTool.string(forKey: "user_phone")
        user.user_emali = userTool.string(forKey: "user_emali")
        return  user
    }
    

}
