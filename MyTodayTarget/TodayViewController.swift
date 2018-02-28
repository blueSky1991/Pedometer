//
//  TodayViewController.swift
//  MyTodayTarget
//
//  Created by 张东东 on 2017/11/20.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit
import NotificationCenter
import HealthKit
import AVFoundation
import MediaPlayer
import AVKit




class TodayViewController: UIViewController,
NCWidgetProviding,
UITextFieldDelegate,
FSCalendarDelegate,
FSCalendarDataSource {

    var healthStore :HKHealthStore?
    @IBOutlet weak var calender: FSCalendar!
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var stepCount: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCompetence()
        self.extensionContext?.widgetLargestAvailableDisplayMode =  .expanded
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let  x = UIScreen.main.bounds.size.width
        self.preferredContentSize = CGSize(width: x, height: 100)
        self.stepCount.keyboardType = .numberPad
        self.stepCount.delegate = self as UITextFieldDelegate
        
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.resignFirstResponder()

        return true
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if (textField.text?.isEmpty)! {
           self.btn.backgroundColor = UIColor.gray
           self.btn.isEnabled = false
        }else{
            self.btn.backgroundColor = UIColor.blue
            self.btn.isEnabled = true
        }
        
       
        return true
    }
    
    
    @IBAction func btnClick(_ sender: UIButton) {
        

        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)
        if HKHealthStore.isHealthDataAvailable() {
            
            let stepQuantity = HKQuantity.init(unit: HKUnit.count(), doubleValue: Double(50))
            
            let stepSample = HKQuantitySample.init(type: stepType!, quantity: stepQuantity, start: Date.init(timeIntervalSinceNow: -15*60), end: Date.init())
            
            
             self.healthStore?.save(stepSample, withCompletion: { (success, error) in
                if success {
                    DispatchQueue.main.async {
                  PushNotificationManager.sharedInstance().normalPushNotification(withTitle: "提示", subTitle: "今日目标", body: "啦啦啦", identifier: "stepCount", timeInterval: 10, repeat: false)
                        
                    }
                    
                    
                }else{
                    
                    DispatchQueue.main.async {
                        
                       
                        
                    }
                    
                    
                }
                
            })
        }
        
        
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        // Perform any setup necessary in order to update the view.
        
        // If an error is encountered, use NCUpdateResult.Failed
        // If there's no update required, use NCUpdateResult.NoData
        // If there's an update, use NCUpdateResult.NewData
        
        completionHandler(NCUpdateResult.newData)
    }
    
}

extension TodayViewController{
    
  
    //获取权限
    fileprivate  func getCompetence()  {
        
        
        self.healthStore = HKHealthStore.init()
        
        if HKHealthStore.isHealthDataAvailable(){
            let write = writeCompetence()
            let read = readCompetence()
            
            self.healthStore?.requestAuthorization(toShare: write, read: read, completion: { (success, error) in
                if success {
                    print("success")
                }else{
                    
                    let alterView = UIAlertController.init(title:"", message:"请前往健康为程序打开权限" , preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                        (UIAlertAction) -> Void in
//                        let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString)!
                    
                        
                    })
                    alterView.addAction(okAction)
                    self.present(alterView, animated: true, completion: nil)
                    
                }
                
            })
            
        }
    }

    
  
    
    fileprivate   func writeCompetence() -> Set<HKQuantityType> {
        
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)
        
        return Set.init(arrayLiteral: stepType!)
        
    }
    
    fileprivate   func readCompetence() -> Set<HKQuantityType> {
        
        
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)
        
        return Set.init(arrayLiteral: stepType!)
        
    }
    
    
}
