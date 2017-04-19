//
//  CirclePercentageView.swift
//  Pedometer
//
//  Created by 张东东 on 2017/4/18.
//  Copyright © 2017年 张东东. All rights reserved.
//

import UIKit


class CirclePercentageView: UIView {
    
    var tatolNum:NSInteger = 5000 {
    
        didSet{
            setNeedsDisplay()
        }
    }
    
    var isAnimation : Bool = false {
        didSet{
            setNeedsDisplay()
        }

    }
    
    
    var currenNum : NSInteger = 0 {
        didSet{
            setNeedsDisplay()
        }
    }
    var currnTextStr:String? = ""{
        didSet{
           setNeedsDisplay()
        }
    }
    
    var descTextStr:String? = ""{
        didSet{
            setNeedsDisplay()
        }
    }


    var gradientLayer:CAGradientLayer?
    var allgradientLayer:CAGradientLayer?
    var colors : [UIColor] = [UIColor]()
    var bgcolors : [UIColor] = [UIColor]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        addcolors()
        initUI()
        
        
        
        self.backgroundColor = UIColor.white

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        

        initUI()
        
        let point : CGPoint = CGPoint.init(x: self.frame.size.width*0.35, y: self.frame.size.height*0.40)
        (self.currnTextStr! as NSString).draw(at: point, withAttributes: [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 20)])
        
         changeLayer(rect: rect)
        
        let descpoint : CGPoint = CGPoint.init(x: self.frame.size.width*0.13, y: self.frame.size.height*0.78)
        (self.descTextStr! as NSString).draw(at: descpoint, withAttributes: [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.boldSystemFont(ofSize: 28)])
        
    
    }
    
    func RGBCOLOR(r:CGFloat,_ g:CGFloat,_ b:CGFloat) -> UIColor{
        return UIColor(red: (r)/255.0, green: (g)/255.0, blue: (b)/255.0, alpha: 1.0)
    }
    
    
    func ConversionRadian(degrees:CGFloat) -> CGFloat {
        
         return (CGFloat.pi * degrees)/180.0
    }
 
    func addcolors()->(){
        
        self.colors.append(UIColor.colorWithHex(hexColor: 0xffff0000, alpha: 0.5))
        self.colors.append(UIColor.colorWithHex(hexColor: 0xffffff00, alpha: 0.5))
        self.colors.append(UIColor.colorWithHex(hexColor: 0xff00ff00, alpha: 0.5))
        self.colors.append(UIColor.colorWithHex(hexColor: 0xff00ffff, alpha: 0.5))
        self.colors.append(UIColor.colorWithHex(hexColor: 0xff0000ff, alpha: 0.5))
        self.colors.append(UIColor.colorWithHex(hexColor: 0xffff00ff, alpha: 0.5))
        
        self.bgcolors.append(UIColor.colorWithHex(hexColor: 0xffff0000, alpha: 0.5))
        self.bgcolors.append(UIColor.colorWithHex(hexColor: 0xffffff00, alpha: 0.5))
        self.bgcolors.append(UIColor.colorWithHex(hexColor: 0xff00ff00, alpha: 0.5))
        self.bgcolors.append(UIColor.colorWithHex(hexColor: 0xff00ffff, alpha: 0.5))
        self.bgcolors.append(UIColor.colorWithHex(hexColor: 0xff0000ff, alpha: 0.5))
        self.bgcolors.append(UIColor.colorWithHex(hexColor: 0xffff00ff, alpha: 0.5))

    }
    
    
    
}



extension CirclePercentageView{

    fileprivate func initUI() -> () {
        
        let  outerArc = CAShapeLayer()
        
        let center = CGPoint.init(x: self.frame.size.width*0.5, y: self.frame.size.height*0.5)
        
        outerArc.path  = UIBezierPath(arcCenter:center, radius:self.frame.size.width*0.5-8, startAngle: ConversionRadian(degrees: 150), endAngle: ConversionRadian(degrees: 390), clockwise: true).cgPath
        
        outerArc.fillColor = UIColor.clear.cgColor;
        outerArc.strokeColor = UIColor.black.cgColor
        outerArc.lineWidth = 8
        outerArc.lineDashPattern = [15,1]
        self.allgradientLayer = CAGradientLayer()
        self.allgradientLayer?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        self.allgradientLayer?.colors = [UIColor.blue.cgColor,UIColor.orange.cgColor,UIColor.green.cgColor,UIColor.red.cgColor]
        self.allgradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.allgradientLayer?.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.allgradientLayer?.mask = outerArc
        self.layer.addSublayer(self.allgradientLayer!)
        
        
        let  centerArc = CAShapeLayer()
        centerArc.path  = UIBezierPath(arcCenter:center , radius:self.frame.size.width*0.35, startAngle: ConversionRadian(degrees: 150), endAngle: ConversionRadian(degrees: 390), clockwise: true).cgPath
        centerArc.fillColor = UIColor.clear.cgColor;
        centerArc.strokeColor = UIColor.black.cgColor
        centerArc.lineWidth = 4
        self.gradientLayer = CAGradientLayer()
        self.gradientLayer?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        
        
        if !isAnimation {
            self.gradientLayer?.colors = [UIColor.blue.cgColor,UIColor.orange.cgColor,UIColor.green.cgColor,UIColor.red.cgColor]
        }else{
            self.gradientLayer?.colors = [UIColor.blue.cgColor,UIColor.orange.cgColor]
        }

        self.gradientLayer?.startPoint = CGPoint(x: 0.0, y: 0.5)
        self.gradientLayer?.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.gradientLayer?.mask = centerArc
        self.layer.addSublayer(self.gradientLayer!)
    }


    func changeLayer(rect:CGRect) -> () {
        
        
        if !isAnimation {
             return
        }
        
        let  centerArc = CAShapeLayer()
        let center = CGPoint.init(x: self.frame.size.width*0.5, y: self.frame.size.height*0.5)
        centerArc.path  = UIBezierPath(arcCenter:center , radius:self.frame.size.width*0.35, startAngle: ConversionRadian(degrees: 150), endAngle: ConversionRadian(degrees: 390), clockwise: true).cgPath

        centerArc.fillColor = UIColor.clear.cgColor;
        centerArc.strokeColor = UIColor.green.cgColor
        centerArc.lineWidth = 4
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = 5.0
        drawAnimation.repeatCount = 1.0
        drawAnimation.isRemovedOnCompletion = false
        drawAnimation.fromValue = 0
        drawAnimation.toValue = 10
        drawAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseIn)
        centerArc.add(drawAnimation, forKey: "drawCircleAnimation")
        let changeLayer = CAGradientLayer()
        changeLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)
        changeLayer.colors = [UIColor.green.cgColor,UIColor.red.cgColor]
        changeLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        changeLayer.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        changeLayer.mask = centerArc
        self.layer.addSublayer(changeLayer)
    }
    
    
}


