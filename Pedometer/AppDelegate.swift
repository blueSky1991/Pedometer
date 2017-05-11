//
//  AppDelegate.swift
//  Pedometer
//
//  Created by 张东东 on 2017/4/13.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.backgroundColor = UIColor.white
        self.window?.rootViewController =  LoginController()
        self.window?.makeKeyAndVisible()
        
        NotificationCenter.default.addObserver(forName: NSNotification.Name.UIApplicationUserDidTakeScreenshot, object: nil, queue: OperationQueue.main) { (notification:Notification) in
            let alter =   UIAlertController(title: "警告", message: "用户数据为私有,禁止泄露,再次截屏将封号处理", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "知道了", style: .default, handler: { (action:UIAlertAction) in
                self.userDidTakeScreenshot(notification: notification as NSNotification)
            })
            alter.addAction(okAction)
            self.window?.rootViewController?.present(alter, animated: true, completion: nil)
        }
        
        
        return true
    }
    
    
    func userDidTakeScreenshot(notification:NSNotification) -> Void {
        
        
//        NSLog(@"检测到截屏");
        print("检测用户截屏")
//        
       //人为截屏, 模拟用户截屏行为, 获取所截图片
           let image = imageWithScreenshot()
            //添加显示
           let imageView = UIImageView.init(image: image)
           let imgNum = (self.window?.frame.size.width)!/2
          imageView.frame = CGRect(x: imgNum, y: imgNum, width: imgNum, height: imgNum)


        //添加边框
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 5.0
        

//        //添加四个边阴影
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 0, height: 0)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 10.0
//        //添加两个边阴影
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOffset = CGSize(width: 4, height: 4)
        imageView.layer.shadowOpacity = 0.5
        imageView.layer.shadowRadius = 2.0
        
        self.window?.addSubview(imageView)

        
        self.perform( #selector(imageView.removeFromSuperview), with: nil, afterDelay: 5)
        
    }
    
    func imageWithScreenshot() -> UIImage {
        
        let data = dataWithScreenshotInPNGFormat()
        
        return UIImage.init(data: data )!
    }
    
    
    
    func dataWithScreenshotInPNGFormat() -> Data {
        
        
        let width =  UIScreen.main.bounds.size.width
        let height = UIScreen.main.bounds.size.height
        var imageSize = CGSize.zero
        let orientation = UIApplication.shared.statusBarOrientation
        
        if UIInterfaceOrientationIsPortrait(orientation) {
             imageSize = UIScreen.main.bounds.size
        }else {
             imageSize = CGSize(width: height, height: width)
        }
        
        
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 0)
        let  context:CGContext = UIGraphicsGetCurrentContext()!
        for window:UIWindow in UIApplication.shared.windows {
            context.saveGState()
            context.translateBy(x: window.center.x, y: window.center.y)
            context.concatenate(window.transform)
            context.translateBy(x: -window.bounds.size.width * window.layer.anchorPoint.x, y: -window.bounds.size.height * window.layer.anchorPoint.y)
            
            if orientation == UIInterfaceOrientation.landscapeLeft  {
                context.rotate(by: CGFloat(Double.pi/2))
                context.translateBy(x: 0, y: -imageSize.width)
            }else if orientation == UIInterfaceOrientation.landscapeRight  {
                
                context.rotate(by: -CGFloat(Double.pi/2))
                context.translateBy(x: -imageSize.width, y: 0)
            }else if orientation == UIInterfaceOrientation.portraitUpsideDown {
                
                context.rotate(by: CGFloat(Double.pi))
                context.translateBy(x: -imageSize.width, y: -imageSize.height)
            }
            
            if window.responds(to:#selector(window.drawHierarchy(in:afterScreenUpdates:))) {
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }else{
                window.layer.render(in: context)
            }
            
            context.restoreGState()
            

        }
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return UIImagePNGRepresentation(image!)!
    }
    
    
    
    
    
    

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        
        
        print(shortcutItem.type)
        
    }
    
    

}

