//
//  LoginController.swift
//  Pedometer
//
//  Created by 张东东 on 2017/5/10.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit

class LoginController: UIViewController {
    
    
    @IBOutlet weak var login_user: UITextField!
    @IBOutlet weak var login_password: UITextField!
    @IBOutlet weak var login_btn: UIButton!
    @IBOutlet weak var rememberBtn: UIButton!
    @IBOutlet weak var autoLoginBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setUI()
    }
    
    
    override var prefersStatusBarHidden: Bool{
        
        return true
    }
    

    @IBAction func registBtnCLick(_ sender: UIButton) {
    }
    
    
    @IBAction func findPassWordBtnClick(_ sender: UIButton) {
    }
    
    
    
    @IBAction func autoLoginClick(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
             sender.imageView?.image = UIImage(named: "selected")
        }else{
             sender.imageView?.image = UIImage(named: "normal")
        }

    }
    
    
    @IBAction func loginBtnClick(_ sender: UIButton) {
       self.view.endEditing(true)
        print(NSHomeDirectory())
        
        let user:UserInfo = UserInfo()
        user.user_name = self.login_user.text
        user.user_password = self.login_password.text
        UserInfoTool.shareInstance.saveUserInfo(info: user)
        self.login_user.text = ""
        self.login_password.text = ""
        
    }
    

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    

}



extension LoginController{

    fileprivate func setUI(){
    self.login_user.leftView = UIImageView(image: UIImage(named: "icon_user"))
    self.login_user.leftViewMode = .always
    self.login_password.leftView = UIImageView(image: UIImage(named: "icon_key"))
    self.login_password.leftViewMode = .always
    self.rememberBtn.setImage(UIImage(named: "normal"), for: .normal)
    self.rememberBtn.setImage(UIImage(named: "selected"), for: .selected)
    self.rememberBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
    self.autoLoginBtn.setImage(UIImage(named: "normal"), for: .normal)
    self.autoLoginBtn.setImage(UIImage(named: "selected"), for: .selected)
    self.autoLoginBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: -30, bottom: 0, right: 0)
}
    
}






