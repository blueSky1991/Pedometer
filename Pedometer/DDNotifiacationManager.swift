//
//  DDNotifiacationManager.swift
//  Pedometer
//
//  Created by 张东东 on 2018/2/28.
//  Copyright © 2018年 张东东. All rights reserved.
//

import UIKit

class DDNotifiacationManager: UIView {
    
    var showView : UIView?
    var showLabel : UILabel?
    var showImage : UIImageView?
    
    
    // 创建单例
    static var shareInstance:DDNotifiacationManager{
        struct Static {
            static let instance : DDNotifiacationManager = DDNotifiacationManager();
        }
        return Static.instance;
    }
    
    
    
    
    
    // 警告提示信息
    func wringInfo(bodyStr:String) {
        alertInfoShow(bodyStr: bodyStr, backgroundColor: UIColor.yellow)
        
    }

    // 错误提示信息
    func errorInfo(bodyStr:String) {
       alertInfoShow(bodyStr: bodyStr, backgroundColor: UIColor.red)
        
    }
    

    // 成功提示信息
    func successInfo(bodyStr:String) {
       alertInfoShow(bodyStr: bodyStr, backgroundColor: UIColor.white)
    }

    
    func alertInfoShow(bodyStr:String,backgroundColor:UIColor) {
        
         self.showView = UIView.init(frame: CGRect(x: 0, y: -80, width: UIScreen.main.bounds.size.width, height: 80))
         self.showLabel = UILabel.init(frame: CGRect(x: 80, y: 0, width: UIScreen.main.bounds.size.width-80, height: 80))
         self.showImage = UIImageView.init(frame: CGRect(x: 0, y: 20, width: 40, height: 40))
        self.showImage?.image  = UIImage(named: "info.png");
         self.showView?.addSubview(self.showLabel!)
         self.showView?.addSubview(self.showImage!)
         UIApplication.shared.keyWindow?.addSubview(self.showView!);
        
        
        
        
        
         self.showView?.backgroundColor = backgroundColor;
         self.showLabel?.text = bodyStr;
        
        UIView.animate(withDuration: 0.5) {
            self.showView?.transform = CGAffineTransform.init(translationX: 0, y: 80);
            UIView.animate(withDuration: 0.5, delay: 2, options: UIViewAnimationOptions(rawValue: 0)
                , animations: {
                    self.showView?.transform = CGAffineTransform.init(translationX: 0, y: -80);
            }, completion: { (finish:Bool) in
                self.showView?.removeFromSuperview();
                self.showView = nil;
                self.showLabel = nil;
                self.showImage = nil;
            })
            
        }
    }

}
