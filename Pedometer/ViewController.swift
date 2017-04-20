//
//  ViewController.swift
//  Pedometer
//
//  Created by 张东东 on 2017/4/13.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit
import HealthKit

class ViewController: UIViewController,UITextFieldDelegate {
    
    

      var stepNumer: UITextField!
      var addStep: UIButton!

    var manager : PedometerManger?
    var healthStore :HKHealthStore?
    var player : SoundPlayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        self.title  = "添加我的步数"
        initUI()
        getCompetence()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

     func addStepNumerAction(_ sender: UIButton) {
        
        if (self.stepNumer.text?.isEmpty)! {
            let alterView = UIAlertController.init(title: nil, message: "步数不能为空", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                (UIAlertAction) -> Void in
                self.stepNumer.text = ""
            })
            alterView.addAction(okAction)
            self.present(alterView, animated: true, completion: nil)
            return
        }
        
        
        self.stepNumer.endEditing(true)
        let stepType = HKQuantityType.quantityType(forIdentifier: .stepCount)
        if HKHealthStore.isHealthDataAvailable() {
            
                let stepQuantity = HKQuantity.init(unit: HKUnit.count(), doubleValue: Double(self.stepNumer.text!)!)
    
                 let stepSample = HKQuantitySample.init(type: stepType!, quantity: stepQuantity, start: Date.init(timeIntervalSinceNow: -15*60), end: Date.init())
            

                 self.healthStore?.save(stepSample, withCompletion: { (success, error) in
                    
                    if success {
                        
                        DispatchQueue.main.async {
                            
                            
                            let alterView = UIAlertController.init(title: "提示", message: "步数已加上", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                                (UIAlertAction) -> Void in
                                self.stepNumer.text = ""
                                self.navigationController?.popViewController(animated: true)
                                
                            })
                            
                            alterView.addAction(okAction)
                            self.present(alterView, animated: true, completion: nil)

                        }

                    
                    }else{
                    
                        DispatchQueue.main.async {
                            
                            let alterView = UIAlertController.init(title:"", message:error.debugDescription , preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                                (UIAlertAction) -> Void in
                                
                            })
                            
                            alterView.addAction(okAction)
                            self.present(alterView, animated: true, completion: nil)
                            
                        }

                    
                    }
                    
                 })
        }
        
    }
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.stepNumer.endEditing(true)
    }

}


extension ViewController {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    
        if (textField.text?.isEmpty)! {
            self.addStep.isEnabled = false
        }else{
            
            self.addStep.isEnabled = true
        }

        return true
    }

}



extension ViewController{
    fileprivate  func initUI(){
    
        let width = UIScreen.main.bounds.size.width
        
        self.stepNumer = UITextField(frame: CGRect(x: 50, y: 150, width:width-100 , height: 40))
        self.stepNumer.delegate = self
        self.stepNumer.borderStyle = .roundedRect
        self.stepNumer.keyboardType = .numberPad
        self.stepNumer.placeholder = "添加步数"
        self.view.addSubview(self.stepNumer!)
        
        
        self.player = SoundPlayer.shareInstance
        
        
        self.addStep = UIButton(type: .custom)
        self.addStep?.frame = CGRect(x: 50, y: 200 , width: width-100, height: 40)
        self.addStep?.layer.cornerRadius = 5
        self.addStep?.layer.masksToBounds = true
        self.addStep?.layer.borderWidth = 1
        self.addStep?.layer.borderColor = UIColor.black.cgColor
        self.addStep?.setTitle("添   加", for: .normal)
        self.addStep?.backgroundColor = UIColor.red
        self.addStep?.setTitleColor(UIColor.black, for: .normal)
        self.addStep?.addTarget(self, action: #selector(addStepNumerAction(_:)), for:.touchUpInside)
        self.view.addSubview(self.addStep!)
        
    }


}








extension ViewController {

    //获取权限
     fileprivate  func getCompetence()  {
        
        self.manager = PedometerManger.shareInstance
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
                        let settingUrl = NSURL(string: UIApplicationOpenSettingsURLString)!
                        if UIApplication.shared.canOpenURL(settingUrl as URL){
                            UIApplication.shared.openURL(settingUrl as URL)
                        }

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

    
    
    func getStepCount()  {
        
        
        self.manager = PedometerManger.shareInstance
       
        weak var weakSelf = self
        
        let version = ( (UIDevice.current.systemVersion) as NSString).floatValue

        weakSelf?.manager?.authorizeHealthKit(version: CGFloat(version), completion:  { (success, error) in
    
        if success {
            
            weakSelf?.manager?.getStepCount(completion:{ (value, error) in
                
//                        let strongSelf = self
                
                         DispatchQueue.main.async {
                            
//                         strongSelf.showStep.text = "今日步数:"+String(value)
                           
//                         let str = "厉害了我的哥今天奔跑了"+String(value)+"步,状态燃爆了"
                            
//                         strongSelf.player?.play(string: str)
                   }
                
            })
            
            weakSelf?.manager?.getDistance(compltion: { (value, error) in
//                let strongSelf = self
                
                DispatchQueue.main.async {

//                   strongSelf.showDistance.text =  "今日公里:"+String.init(format: "%.2f", value)
                }

            })
 
            

        }

     })

        
    }
    
}

