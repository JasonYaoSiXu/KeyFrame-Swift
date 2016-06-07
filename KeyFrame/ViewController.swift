//
//  ViewController.swift
//  KeyFrame
//
//  Created by yaosixu on 16/6/7.
//  Copyright © 2016年 Jason_Yao. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var BgImageView: UIImageView!
    @IBOutlet weak var LogInButton: UIButton!
    @IBOutlet weak var UserIdTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    override func viewDidLoad() {
        print("\(#function)")
        super.viewDidLoad()
        //初始化所有组件
        initAllContents()
    }
    
    override func viewWillAppear(animated: Bool) {
        print("\(#function)")
        super.viewWillAppear(animated)
        
        //将状态栏（时间、电池电量...）的颜色设置为白色，要在info.plist里面添加View controller-based status bar appearance字段，type=bool, value = NO
        UIApplication.sharedApplication().statusBarStyle = .LightContent
    }
    
    override func viewDidAppear(animated: Bool) {
        print("\(#function)")
        super.viewDidAppear(animated)
        //给UserIdTextField添加动画效果
        UsertextFieldFadeIn(UserIdTextField.layer)
        //给PasswordTextFiled添加动画效果
        PasswordTextFieldFadeIn(PasswordTextField.layer)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func initAllContents() {
        //设置背景图片
        BgImageView.image = UIImage(named: "bg-snowy")
        //loginButton设置圆角
        LogInButton.layer.cornerRadius = LogInButton.bounds.height / 2
        LogInButton.layer.masksToBounds = true
        //给Button设置点击事件
        LogInButton.addTarget(self, action: #selector(ViewController.tapLogInButton), forControlEvents: .TouchUpInside)
    }
    
    //LoginButton点击事件
    func tapLogInButton() {
        tapLogInButtonAnimation()
    }
    
    //MARK : Add Key Frame Animation for LoginButton
    func tapLogInButtonAnimation() {
        
        let ballon = CALayer()
        ballon.contents = UIImage(named: "balloon")?.CGImage
        ballon.frame = CGRect(x: -50.0, y: 0.0, width: 50.0, height: 65.0)
        view.layer.insertSublayer(ballon, below: UserIdTextField.layer)
        
        let path = CGPathCreateMutable()
        //定位起点
        CGPathMoveToPoint(path, nil, 0, 0)
        //添加曲线
//        CGPathAddCurveToPoint(path, nil, 50,20, 100, 300, 0, 0) // (path,pointer,x1,y1,x2,y2,x0,y0) 贝塞尔曲线
        CGPathAddCurveToPoint(path,nil,50.0,275.0,150.0,275.0,70.0,120.0)
        CGPathAddCurveToPoint(path,nil,150.0,275.0,250.0,275.0,90.0,120.0)
        CGPathAddCurveToPoint(path,nil,250.0,275.0,350.0,275.0,110.0,120.0)
        CGPathAddCurveToPoint(path,nil,350.0,275.0,450.0,275.0,130.0,120.0)
        
        let logAnimation = CAKeyframeAnimation(keyPath: "position")
        logAnimation.setValue("logIn", forKey: "name")
        logAnimation.setValue(ballon, forKey: "layer")
        logAnimation.path = path
        logAnimation.duration = 5.0
        logAnimation.fillMode = kCAFillModeForwards
        logAnimation.removedOnCompletion = false
        ballon.addAnimation(logAnimation, forKey: nil)
    }
    
    //MARK : Add Key Frame Animation for UsertextField
    func  UsertextFieldFadeIn(layer: CALayer) {
        let leftIn = CAKeyframeAnimation(keyPath: "position")
        leftIn.delegate = self
        leftIn.duration = 3
        leftIn.values = [CGPoint(x: -layer.position.x ,y: layer.position.y),CGPoint(x: 0,y: layer.position.y),CGPoint(x: layer.position.x,y: layer.position.y)].map({  NSValue(CGPoint : $0) })
        leftIn.keyTimes = [0.0,0.5,1.0]
        leftIn.setValue("leftIn", forKey: "name")
        leftIn.setValue(layer, forKey: "layer")
        layer.addAnimation(leftIn, forKey: nil)
        //fade in
        FadeIn(layer)
    }
    
    //MARK : Add Key Frame Animation for PasswordTextFiled
    func PasswordTextFieldFadeIn(layer: CALayer) {
        let rightIn = CAKeyframeAnimation(keyPath: "position")
        rightIn.delegate = self
        rightIn.duration = 3
        rightIn.values = [CGPoint(x: view.bounds.width + layer.position.x ,y: layer.position.y),CGPoint(x: view.bounds.width,y: layer.position.y),CGPoint(x: layer.position.x,y: layer.position.y)].map({  NSValue(CGPoint : $0) })
        rightIn.keyTimes = [0.0,0.5,1.0]
        rightIn.setValue("rightIn", forKey: "name")
        rightIn.setValue(layer, forKey: "layer")
        layer.addAnimation(rightIn, forKey: nil)
        //fade in
        FadeIn(layer)
    }
    
    //MARK : Fade In
    func FadeIn(layer: CALayer) {
        let fadeIn = CABasicAnimation(keyPath: "opacity")
        fadeIn.fromValue = 0.2
        fadeIn.toValue = 1.0
        fadeIn.duration = 5
        layer.addAnimation(fadeIn, forKey: nil)
    }
    
    //MARK : Animation Delegate
    //动画开始执行后执行
    override func animationDidStart(anim: CAAnimation) {
            print("\(#function)")
    }
    
    //动画结束执行后执行
    override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
            if let name = anim.valueForKey("name") as? String {
    
                //动画执行结束后再次添加一个弹簧效果
                if name == "leftIn" {
                    let layer = anim.valueForKey("layer") as? CALayer
                    layer?.setValue(nil, forKey: "layer")
                    let spring = CASpringAnimation(keyPath: "transform.scale")
                    spring.fromValue = 1.25
                    spring.toValue = 1.0
                    //弹簧阻尼
                    spring.damping = 7.0
                    //弹簧刚度
                    spring.stiffness = 1500
                    //初始速度,可以为负值
                    spring.initialVelocity = 100
                    spring.duration = spring.settlingDuration
                    layer?.addAnimation(spring, forKey: nil)
                }
                
                if name == "rightIn" {
                    let layer = anim.valueForKey("layer") as? CALayer
                    layer?.setValue(nil, forKey: "layer")
                    let spring = CASpringAnimation(keyPath: "transform.scale")
                    spring.fromValue = 1.25
                    spring.toValue = 1.0
                    //弹簧阻尼
                    spring.damping = 7.0
                    //弹簧刚度
                    spring.stiffness = 1500
                    //初始速度,可以为负值
                    spring.initialVelocity = -100
                    spring.duration = spring.settlingDuration
                    layer?.addAnimation(spring, forKey: nil)
                }
                
            }
    }
    
}

