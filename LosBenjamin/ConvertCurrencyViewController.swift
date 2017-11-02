//
//  ConvertCurrencyViewController.swift
//  LosBenjamin
//
//  Created by MAC on 24/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit

class ConvertCurrencyViewController: UIViewController {
    @IBOutlet weak var view_Button: UIView!
    @IBOutlet weak var btn_Result:UIButton!
    @IBOutlet weak var btn_Cancel:UIButton!
    @IBOutlet weak var view_ConvertMain: UIView!
    @IBOutlet weak var lbl_BottomResultado: UILabel!
    @IBOutlet weak var lbl_BottomIngresar: UILabel!
    @IBOutlet weak var view_ConvertInner: UIView!
    @IBOutlet weak var txtFld_Resultado: UITextField!
    @IBOutlet weak var txtFld_Ingresar: UITextField!
    var toDollar:Bool?
    var value : String?
    override func viewDidLoad() {
        super.viewDidLoad()
        view_ConvertInner.dropShadow()
        view_Button.dropShadow()
        btn_Result.layer.shadowColor = UIColor.black.cgColor
        btn_Result.layer.shadowOffset =  CGSize(width: 2, height: 2)
        btn_Result.layer.shadowRadius = 2
        btn_Result.layer.shadowOpacity =  0.7
        btn_Cancel.layer.shadowColor = UIColor.black.cgColor
        btn_Cancel.layer.shadowOffset =  CGSize(width: 2, height: 2)
        btn_Cancel.layer.shadowRadius = 2
        btn_Cancel.layer.shadowOpacity = 0.7
        toDollar = false
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
   @IBAction func action_Convert(_ sender: UIButton) {
        switch sender.tag {
        case 10:
           toDollar = true
           self.showCurrencyConverterView()
        case 11:
            toDollar = false
            self.showCurrencyConverterView()
        default:
            break
        }
    }
   
  @IBAction func action_Back(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
    }
}
extension ConvertCurrencyViewController{
    func showCurrencyConverterView(){
        txtFld_Ingresar.text  = ""
        txtFld_Resultado.text = ""
        txtFld_Ingresar.becomeFirstResponder()
        view_ConvertMain.frame = self.view.bounds
        UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: { _ in
                 self.view.addSubview(self.view_ConvertMain)
            }, completion: nil)
        self.view_ConvertMain.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        self.view_ConvertMain.isOpaque = true
       
        }
    @IBAction func action_InnerViewBtn(_ sender: UIButton) {
        switch sender.tag {
        case 101:
            if toDollar!{
                txtFld_Resultado.text = String("\( Double((txtFld_Ingresar.text! as NSString).integerValue) * Double((value! as NSString).integerValue) * 0.01)")
                
            }
            else{
                
                 txtFld_Resultado.text = String("\( Double((txtFld_Ingresar.text! as NSString).integerValue) / Double((value! as NSString).integerValue) * 0.01)")
            }
        case 102:
             self.view.endEditing(true)
             UIView.transition(with: view, duration: 0.5, options: .transitionCrossDissolve, animations: { _ in
                 self.view_ConvertMain.removeFromSuperview()
             }, completion: nil)
            
        default:
            break
        }
        
    }
    @IBAction func action_HideConvertViewMain(_ sender: Any) {
        self.view.endEditing(true)
    }
}
//MARK:- UIGestureViewDelegates
extension ConvertCurrencyViewController: UIGestureRecognizerDelegate
{
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if (touch.view?.isDescendant(of: view_ConvertInner))!{
            return false
        }
        return true
    }
}
extension ConvertCurrencyViewController : UITextFieldDelegate{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if self.view.frame.origin.y<0{
            self.view.frame.origin.y = 0}
        
    }
    func textFieldShouldReturn(_ _textField: UITextField) -> Bool {
    _textField.resignFirstResponder();
        return true;
}
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         if string == ""{
            txtFld_Resultado.text = ""
            }
        
        return true
    }
}
