//
//  ViewController.swift
//  keyboardLayout
//
//  Created by Mohan K on 17/12/22.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var text1TextField: UITextField!
    @IBOutlet weak var text2TextField: UITextField!
    @IBOutlet weak var text3TextField: UITextField!
    @IBOutlet weak var text1Error: UILabel!
    @IBOutlet weak var text2Error: UILabel!
    @IBOutlet weak var text3Error: UILabel!
    @IBOutlet weak var SubmitButton: UIButton!
    
    var activeTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        resetForm()
        
        text1TextField.delegate = self
        text2TextField.delegate = self
        text3TextField.delegate = self
        
        let center:NotificationCenter = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardHidden(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func resetForm(){
        SubmitButton.isEnabled = false
        text1Error.isHidden = false
        text2Error.isHidden = false
        text3Error.isHidden = false
    }
    
    @IBAction func didEndTap(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func text1Change(_ sender: Any) {
        if let email = text1TextField.text{
            if let errorMessage = invalidEmail(email){
                text1Error.text = errorMessage
                text1Error.isHidden = false
            }
            else{
                text1Error.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidEmail(_ value: String) -> String?
    {
        let reqularExpression = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        if !predicate.evaluate(with: value)
        {
            return "Invalid Email Address"
        }
        
        return nil
    }
    
    @IBAction func text2Change(_ sender: Any) {
        if let password = text2TextField.text
        {
            if let errorMessage = invalidPassword(password)
            {
                text2Error.text = errorMessage
                text2Error.isHidden = false
            }
            else{
                text2Error.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidPassword(_ value: String) -> String?
    {
        if value.count < 8
        {
            return "Password must be at least 8 characters"
        }
        if containsDigit(value)
        {
            return "Password must contain at least 1 digit"
        }
        if containsLowerCase(value)
        {
            return "Password must contain at least 1 lowercase character"
        }
        if containsUpperCase(value)
        {
            return "Password must contain at least 1 uppercase character"
        }
        return nil
    }
    
    func containsDigit(_ value: String) -> Bool{
        let reqularExpression = ".*[0-9]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsLowerCase(_ value: String) -> Bool{
        let reqularExpression = ".*[a-z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    
    func containsUpperCase(_ value: String) -> Bool{
        let reqularExpression = ".*[A-Z]+.*"
        let predicate = NSPredicate(format: "SELF MATCHES %@", reqularExpression)
        return !predicate.evaluate(with: value)
    }
    @IBAction func text3Change(_ sender: Any) {
        if let phoneNumber = text3TextField.text{
            if let errorMessage = invalidPhoneNumber(phoneNumber){
                text3Error.text = errorMessage
                text3Error.isHidden = false
            }
            else{
                text3Error.isHidden = true
            }
        }
        checkForValidForm()
    }
    
    func invalidPhoneNumber(_ value: String) -> String?{
        let set = CharacterSet(charactersIn: value)
        if !CharacterSet.decimalDigits.isSuperset(of: set)
        {
        
            return "Phone Number must contain only digits"
        }
        
        if value.count != 10
        {
            return "Phone Number must be 10 Digits in Length"
        }
        return nil
    }
    
    func checkForValidForm(){
        if text1Error.isHidden && text2Error.isHidden && text3Error.isHidden{
            SubmitButton.isEnabled = true
        }
        else{
            SubmitButton.isEnabled = false
        }
    }
    @IBAction func submitButton(_ sender: Any) {
        
    }
    
    @objc func keyboardDidShow(notification: Notification){
        let info: NSDictionary = notification.userInfo! as NSDictionary
        let keyboardsize = (info[UIResponder.keyboardFrameEndUserInfoKey] as!
                            NSValue).cgRectValue
        let keyboardY = self.view.frame.height - keyboardsize.height
        let editingTextFieldY = activeTextField.convert(activeTextField.bounds, to:self.view).minY
        if self.view.frame.minY>=0
        {
            if editingTextFieldY>keyboardY-20
            {
                UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                    self.view.frame = CGRect(x: 0, y: self.view
                        .frame.origin.y-(editingTextFieldY-(keyboardY-50)), width: self.view.bounds.width, height: self.view.bounds.height)
                }, completion: nil)
            }
        }
    }
    
    @objc func keyboardHidden(notification: Notification)
    
    {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height)
        }, completion: nil)
    }
    
}

extension ViewController:UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField) {
        activeTextField = textField
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.switchBasedNextTextField(textField)
        return true
    }
    private func switchBasedNextTextField(_ textField: UITextField) {
        switch textField {
        case self.text1TextField:
            self.text2TextField.becomeFirstResponder()
        case self.text2TextField:
            self.text3TextField.becomeFirstResponder()
        default:
            self.text3TextField.resignFirstResponder()
        }
    }

}
