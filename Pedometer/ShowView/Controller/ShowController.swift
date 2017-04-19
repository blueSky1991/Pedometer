//
//  ShowController.swift
//  Pedometer
//
//  Created by 张东东 on 2017/4/18.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit

import CoreMotion

import EventKit

class ShowController: BaseViewController {

    var totalView : CirclePercentageView?
    var stepShowView : CirclePercentageView?
    var speedShowView : CirclePercentageView?
    var statusShowView : CirclePercentageView?
    var operationQueue : OperationQueue?
    var dayStepBtn : UIButton?
    var settingBtn : UIButton?
    
    var timer : Timer?
    
    let ScreenHeight = UIScreen.main.bounds.size.height
    let ScreenWidth = UIScreen.main.bounds.size.width

    
    
    var stepCounter : CMPedometer?
    var activityManager : CMMotionActivityManager?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        getData()
        getStatues()
        addEveryDayTotal()

        self.timer = Timer(timeInterval: 60, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
        RunLoop.current.add(self.timer!, forMode: .defaultRunLoopMode)
        
    }


}



extension ShowController{

    fileprivate func initUI(){
        
        self.title = "运动信息"
        
        addItem()
        
        self.operationQueue = OperationQueue.main
        self.stepCounter = CMPedometer()
        self.activityManager = CMMotionActivityManager()
        
        let WIDTH :CGFloat  = 150.0
        let HEIGHT = WIDTH
        
        
        self.totalView = CirclePercentageView(frame: CGRect(x: 5, y: 90, width: WIDTH, height: HEIGHT))
        self.totalView?.descTextStr = "今日步数"
        self.totalView?.isAnimation  = true
        
        self.stepShowView = CirclePercentageView(frame: CGRect(x:ScreenWidth-WIDTH-5, y: 90, width: WIDTH, height: HEIGHT))
        self.stepShowView?.descTextStr = "目标步数"
        self.stepShowView?.currnTextStr = "5000"
        
        self.speedShowView = CirclePercentageView(frame: CGRect(x: 5, y: 260, width: WIDTH, height: HEIGHT))
        self.speedShowView?.descTextStr = "运动速度"
        
        self.statusShowView = CirclePercentageView(frame: CGRect(x:ScreenWidth-WIDTH-5, y: 260, width: WIDTH, height: HEIGHT))
        self.statusShowView?.descTextStr = "运动状态"
        
        self.view.addSubview(self.totalView!)
        self.view.addSubview(self.stepShowView!)
        self.view.addSubview(self.speedShowView!)
        self.view.addSubview(self.statusShowView!)

    
    }
    
    
    @objc fileprivate func getData(){
        
        if CMPedometer.isStepCountingAvailable() {
            let calendar = Calendar.current
            let set = Set.init(arrayLiteral:Calendar.Component.day,Calendar.Component.month,Calendar.Component.year)
            var components = calendar.dateComponents(set, from: Date.init())
            components.hour = 0
            components.minute = 0
            components.second = 0
            let startDate = calendar.date(from: components)
            let endDate = calendar.date(byAdding: Calendar.Component.day, value: 1, to: startDate!, wrappingComponents: true)
            
                self.stepCounter?.queryPedometerData(from: startDate!, to: endDate!, withHandler: { (pedometer, error) in
            
                    DispatchQueue.main.async {
                    if !(error != nil) {
                        self.totalView?.currnTextStr = (pedometer?.numberOfSteps.stringValue)!
                    }else{
                       self.alterMessage(str: error.debugDescription)
                    }
                        
                }
               
           })
            
        }
        
    }
    
    
    
    fileprivate func getStatues(){
        
        if CMMotionActivityManager.isActivityAvailable() {
            self.activityManager?.startActivityUpdates(to: self.operationQueue!, withHandler: { (activity) in
                DispatchQueue.main.async {
                 self.statusShowView?.currnTextStr = self.statusForActivity(activity: activity!)
                  self.speedShowView?.currnTextStr = self.stringFromConfidence(confidence: (activity?.confidence)!)
                    
                }
                
            })
        }

    }
    
    
    
    func statusForActivity(activity : CMMotionActivity) -> String {
        
        var status:String = "未知"
        
        if activity.stationary {
            
            status = "静止"
        }
        
        if activity.walking {
     
            status = "走路"
        }
        
        if activity.running {
            status = "奔跑"
        }
        
        if activity.automotive {
            
            status = "开车"
            
            
        }
        
        if activity.unknown   {
            
           status = "未知"
            
        }
        
        
        return status
    }
    
    
    
    func stringFromConfidence(confidence:CMMotionActivityConfidence) -> String {
        
        switch confidence {
            
        case .low:
            return "略低"
        case .medium:
            return "中等"
        case .high:
            return "略高"
        }
        
    }
    
    
    
    func alterMessage(str:String) -> () {
        let alterView = UIAlertController.init(title:"", message:str, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "确定", style: .default, handler:{
            (UIAlertAction) -> Void in
        })
        alterView.addAction(okAction)
        self.present(alterView, animated: true, completion: nil)
    }
    
    
}



extension ShowController {

    fileprivate func addItem(){
    
        self.settingBtn = UIButton(type: .custom)
        self.settingBtn?.frame = CGRect(x: 0, y: 0 , width: 40, height: 40)
        self.settingBtn?.setTitle("设置", for: .normal)
        self.settingBtn?.backgroundColor = UIColor.white
        self.settingBtn?.setTitleColor(UIColor.black, for: .normal)
        self.settingBtn?.addTarget(self, action: #selector(settingBtn(btn:)), for:.touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: self.settingBtn!)
    
    }

    
    func settingBtn(btn:UIButton){
        
        self.navigationController?.pushViewController(ViewController(), animated: true)
    
    }
    
    
    fileprivate func addEveryDayTotal(){
        
        let height = UIScreen.main.bounds.size.height
        let width = UIScreen.main.bounds.size.width
        self.dayStepBtn = UIButton(type: .custom)
        self.dayStepBtn?.frame = CGRect(x: 0, y: height-80.0 , width: width, height: 40)
        self.dayStepBtn?.layer.cornerRadius = 5
        self.dayStepBtn?.layer.masksToBounds = true
        self.dayStepBtn?.layer.borderWidth = 1
        self.dayStepBtn?.layer.borderColor = UIColor.black.cgColor
        self.dayStepBtn?.setTitle("添加每日跑步目标数", for: .normal)
        self.dayStepBtn?.backgroundColor = UIColor.red
        self.dayStepBtn?.setTitleColor(UIColor.black, for: .normal)
        self.dayStepBtn?.addTarget(self, action: #selector(add(btn:)), for:.touchUpInside)
        self.view.addSubview(self.dayStepBtn!)
        
    }
    
     func add(btn:UIButton){
    
        let alterView = UIAlertController.init(title: nil, message: "添加每日步数", preferredStyle: .alert)
        alterView.addTextField { (textFiled) in
            textFiled.placeholder = "添加步数"
            textFiled.keyboardType = .numberPad

        }
        let okAction = UIAlertAction(title: "确定", style: .default, handler:{
            (UIAlertAction) -> Void in
            let textFiled:UITextField = alterView.textFields![0]
              print(textFiled.text ?? "未获取到")
            self.stepShowView?.currnTextStr = textFiled.text ?? "5000"
            self.addToCalendarClicked(meaage:textFiled.text!)
            
        })
        alterView.addAction(okAction)
        self.present(alterView, animated: true, completion: nil)

    }
    
    
    func addToCalendarClicked(meaage:String){
        let eventStore = EKEventStore()
           eventStore.requestAccess(to: .event) {(granted, error) in
            
            do {
                if((error) != nil){
                    //添加错误
                }
                else if(!granted){
                    //无访问日历权限
                    
                }else{
                    let event = EKEvent(eventStore: eventStore)
                    event.title = "加油 目标步数\(meaage)"
                    //起止时间
                    let formatter = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm"
                    let calendar = Calendar.current
                    let set = Set.init(arrayLiteral:Calendar.Component.day,Calendar.Component.month,Calendar.Component.year)
                    var components = calendar.dateComponents(set, from: Date.init())
                    components.hour = 8
                    components.minute = 0
                    components.second = 0
                    let startDate = calendar.date(from: components)
                    let endDate = calendar.date(byAdding: Calendar.Component.day, value:1, to: startDate!, wrappingComponents: true)
                    event.startDate = startDate!
                    event.endDate = endDate!
                    //在事件前多少秒开始事件提醒
                    let alarm = EKAlarm()
                    alarm.relativeOffset = -60.0
                    event.addAlarm(alarm)
                    event.calendar = eventStore.defaultCalendarForNewEvents
                    let result:()? = try eventStore.save(event, span: EKSpan.thisEvent)
                    
                    if(result != nil){
                        
                    }
                }
            }
            catch {
                print("error")
            }
        }
        
    }
    
    
    
    
    
    
}



