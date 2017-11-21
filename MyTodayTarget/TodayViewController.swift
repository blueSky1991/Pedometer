//
//  TodayViewController.swift
//  MyTodayTarget
//
//  Created by 张东东 on 2017/11/20.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit
import NotificationCenter



class TodayViewController: UIViewController, NCWidgetProviding,UITextFieldDelegate {
    
    
    @IBOutlet weak var btn: UIButton!
    @IBOutlet weak var stepCount: UITextField!
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.extensionContext?.widgetLargestAvailableDisplayMode =  .expanded
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let  x = UIScreen.main.bounds.size.width
        self.preferredContentSize = CGSize(width: x, height: 100)
        self.stepCount.keyboardType = .numberPad
        self.stepCount.delegate = self as UITextFieldDelegate
//        self.stepCount.endEditing(false)
        self.view.resignFirstResponder()
        self.btn.backgroundColor = UIColor.gray
        self.btn.isEnabled = false
        
    }
    
    
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.view.resignFirstResponder()
//        self.stepCount.endEditing(false)
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
    
    
    
    
    
}
