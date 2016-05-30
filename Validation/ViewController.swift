//
//  ViewController.swift
//  Validation
//
//  Created by Kumar gaurav on 2016-05-25.
//  Copyright © 2016 Kumar gaurav. All rights reserved.
//

import UIKit


class ViewController: UIViewController, UITextFieldDelegate {

    var labelView: UIView?
    var tap = UITapGestureRecognizer()
    var counter = 0
    var timer: NSTimer!
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    var label: UILabel!
    
    @IBOutlet weak var ValidateNull: UITextField!
    @IBOutlet weak var ValidateNumeric: UITextField!
    @IBOutlet weak var ValidateEmail: UITextField!
    @IBOutlet weak var ValidatePassword: UITextField!
    @IBOutlet weak var ValidateCPassword: UITextField!
    @IBOutlet weak var ValidateMaxChar: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ValidateNumeric.delegate = self
        
        let screenWidth: CGFloat = screenSize.width - 2;
        label = UILabel(frame: CGRectMake(0, 0, screenWidth, 50))
        
        tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.handleFrontTap(_:)))
        view.addGestureRecognizer(tap)

    }
    
    func handleFrontTap(gestureRecognizer: UITapGestureRecognizer) {
        let buttonTap = gestureRecognizer.locationInView(labelView!.superview)
        if (self.labelView!.layer.presentationLayer()!.frame.contains(buttonTap)) {
            FadeOutNotification()
        }
    }

    func createNotification(message: String) {
        label!.layer.borderWidth = 0
        label!.backgroundColor = UIColor(red: 120/255, green: 177/255, blue: 237/255, alpha: 1.0)
        label!.textAlignment = NSTextAlignment.Left
        label!.numberOfLines = 1
        label!.text = "        " + message
        labelView = label
        
        self.view.addSubview(labelView!)
       // counter = 0
        FadeInNotification()
        if (timer == nil) {
            timer = NSTimer.scheduledTimerWithTimeInterval(0.5, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
        }
        print(timer)
    }
    
    func timerAction() {
        counter += 1
        if (counter == 10) {
            counter = 0
            FadeOutNotification()
        }
    }
    
    func FadeInNotification() {
        labelView!.alpha = 0.0
        UIView.animateWithDuration(
            2.0,
            delay: 0.2,
            options: [],
            animations: {
                self.labelView!.alpha = 1.0
                },
            completion: nil)
    }
    
    func FadeOutNotification() {
        UIView.animateWithDuration(
            2.0,
            delay: 0.2,
            options: UIViewAnimationOptions.CurveEaseOut,
            animations: {
                self.labelView!.alpha = 0.0
                },
            completion: nil)
        timer.invalidate()
        timer = nil
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func ValidateMe(sender: AnyObject) {
        NullValidation(ValidateNull)
        NullValidation(ValidateEmail)
        validateEmail(ValidateEmail)
        checkPasswordText(ValidatePassword, CPasswordText: ValidateCPassword)
        let maxcharval = checkMaxChar(ValidateMaxChar, Clength: 10)
        if (maxcharval) {
            ValidateMaxChar.layer.borderWidth = 0
        }
        else {
            changeColor(ValidateMaxChar)
        }
    }
    
    
    internal func NullValidation(Value: UITextField) {
        if (Value.text! == ""){
            changeColor(Value)
        }
        else {
            Value.layer.borderWidth = 0
        }
    }
   
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        switch string {
        case "0","1","2","3","4","5","6","7","8","9":
            return true
            //uncomment the code if you want dot in the field
//        case ".":
//            let array = Array(arrayLiteral: textField.text)
//            var decimalCount = 0
//            for character in array {
//                if character == "." {
//                    decimalCount += 1
//                }
//            }
//            if decimalCount == 1 {
//                return false
//            } else {
//                return true
//            }
        case "":
            return true
        default:
            let array = Array(arrayLiteral: string)
            if array.count == 0 {
                return true
            }
            return false
        }
    }
    
    func checkPasswordText(PasswordText : UITextField, CPasswordText: UITextField) {
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        let capitalresult = texttest.evaluateWithObject(PasswordText.text!)
        print("\(capitalresult)")
        
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        let numberresult = texttest1.evaluateWithObject(PasswordText.text!)
        print("\(numberresult)")
        
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        let specialresult = texttest2.evaluateWithObject(PasswordText.text!)
        print("\(specialresult)")
        
        let checkCharLen = checkChar(PasswordText, Clength: 8)
        print("\(checkCharLen)")
        
        let checkPass = (PasswordText.text! == CPasswordText.text! ? true: false)
        print("\(checkPass)")
        
        if !(capitalresult && numberresult && specialresult && checkCharLen && checkPass) {
            changeColor(PasswordText)
            changeColor(CPasswordText)
        }
        else {
            PasswordText.layer.borderWidth = 0
            CPasswordText.layer.borderWidth = 0
        }
    }
    
    func checkChar(Text: UITextField, Clength: Int) -> Bool {
        if(Text.text!.characters.count > Clength){
            return true
        }
        return false
    }
    
    func checkMaxChar(Text: UITextField, Clength: Int) -> Bool {
        if(Text.text!.characters.count == Clength){
            return true
        }
        return false
    }
    
    func changeColor(field: UITextField) {
        let myColor : UIColor = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 0.5)
        field.layer.borderWidth = 1
        field.layer.borderColor = myColor.CGColor
        createNotification("All fields are required.")
    }
    
    func validateEmail(enteredEmail: UITextField) {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        if (emailPredicate.evaluateWithObject(enteredEmail.text!) != true){
            changeColor(enteredEmail)
        }
        else{
            enteredEmail.layer.borderWidth = 0
        }
    }

    func removeView() {
        self.labelView!.removeFromSuperview()
    }
}
