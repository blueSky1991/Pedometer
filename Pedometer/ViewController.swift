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
    
    
    @IBOutlet weak var showStep: UILabel!
    
    @IBOutlet weak var stepNumer: UITextField!
    
    @IBOutlet weak var addStep: UIButton!
    
    var manager : PedometerManger?
    var healthStore :HKHealthStore?
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.stepNumer.delegate = self
        self.stepNumer.borderStyle = .roundedRect
        self.stepNumer.keyboardType = .numberPad
        
//        self.view.backgroundColor = UIColor.init(red: 0, green: 186/255.0, blue: 111/255.0, alpha: 0.9)
        
        
        
        self.addStep.layer.borderWidth = 1
        self.addStep.layer.borderColor = UIColor.darkGray.cgColor
        self.addStep.layer.cornerRadius = 5
        self.addStep.layer.masksToBounds = true
        
        getCompetence()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func addStepNumerAction(_ sender: UIButton) {
        
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
    
                 let stepSample = HKQuantitySample.init(type: stepType!, quantity: stepQuantity, start: Date.init(), end: Date.init())
            
                 self.healthStore?.save(stepSample, withCompletion: { (success, error) in
                    
                    
                    if success {
                        
                        DispatchQueue.main.async {
                            
                            let alterView = UIAlertController.init(title: "提示", message: "步数已加上", preferredStyle: .alert)
                            
                            let okAction = UIAlertAction(title: "确定", style: .default, handler:{
                                (UIAlertAction) -> Void in
                                self.stepNumer.text = ""
                                self.getStepCount()
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
                      self.getStepCount()
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

    
    
    func getStepCount() {
        
        
        self.manager = PedometerManger.shareInstance
       
        weak var weakSelf = self
        
        let version = ( (UIDevice.current.systemVersion) as NSString).floatValue

        weakSelf?.manager?.authorizeHealthKit(version: CGFloat(version), completion:  { (success, error) in
    
        if success {
            
            weakSelf?.manager?.getStepCount(completion:{ (value, error) in
                
                        let strongSelf = self
                
                         DispatchQueue.main.async {
                            
                            strongSelf.showStep.text = "今日步数:"+String(value)
                }
        
            })

        }

     })

        
    }
    
}

