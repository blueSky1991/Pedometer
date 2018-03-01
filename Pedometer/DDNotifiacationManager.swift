//
//  DDNotifiacationManager.swift
//  Pedometer
//
//  Created by 张东东 on 2018/2/28.
//  Copyright © 2018年 张东东. All rights reserved.
//

import UIKit

class DDNotifiacationManager: UIView {
    
   private var showView  : UIView?
   private var showLabel : UILabel?
   private var showImage : UIImageView?
   private var ViewHeight = 80
    
    // 创建单例
    static var shareInstance:DDNotifiacationManager{
        struct Static {
            static let instance : DDNotifiacationManager = DDNotifiacationManager();
        }
        return Static.instance;
    }
    
    
    // 警告提示信息
    func wringInfo(bodyStr:String) {
        
        alertInfoShow(bodyStr: bodyStr, backgroundColor: UIColor.yellow, imageName: "waring.png", delay: 2)
    }

    // 错误提示信息
    func errorInfo(bodyStr:String) {
        alertInfoShow(bodyStr: bodyStr, backgroundColor: UIColor.red, imageName: "error.png", delay: 2.5)
    }
    

    // 成功提示信息
    func successInfo(bodyStr:String) {
        alertInfoShow(bodyStr: bodyStr, backgroundColor: UIColor.white, imageName: "success.png", delay: 2)
    }

    
    private func alertInfoShow(bodyStr:String,backgroundColor:UIColor,imageName:String,delay:CGFloat){
        
        self.showView = UIView.init(frame: CGRect(x: 0, y: -ViewHeight, width: Int(UIScreen.main.bounds.size.width), height: ViewHeight))
        self.showLabel = UILabel.init(frame: CGRect(x: ViewHeight, y: 0, width:Int(UIScreen.main.bounds.size.width) - ViewHeight, height: ViewHeight))
        self.showImage = UIImageView.init(frame: CGRect(x: 0, y: 20, width: ViewHeight/2, height: ViewHeight/2))
        self.showImage?.image  = UIImage(named: imageName);
        self.showView?.addSubview(self.showLabel!)
        self.showView?.addSubview(self.showImage!)
        UIApplication.shared.keyWindow?.addSubview(self.showView!);
        
        self.showView?.backgroundColor = backgroundColor;
        self.showLabel?.text = bodyStr;
        
        UIView.animate(withDuration: 0.5) {
            self.showView?.transform = CGAffineTransform.init(translationX: 0, y: CGFloat(self.ViewHeight));
            UIView.animate(withDuration: 0.5, delay: TimeInterval(delay), options: UIViewAnimationOptions(rawValue: 0)
                , animations: {
                    self.showView?.transform = CGAffineTransform.init(translationX: 0, y: CGFloat(-self.ViewHeight));
            }, completion: { (finish:Bool) in
                self.showView?.removeFromSuperview();
                self.showView = nil;
                self.showLabel = nil;
                self.showImage = nil;
            })
            
        }

        
        
    }
    
}
