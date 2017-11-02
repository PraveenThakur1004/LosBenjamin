//
//  HomeViewController.swift
//  LosBenjamin
//
//  Created by MAC on 24/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import FTIndicator
import FBSDKCoreKit
import FBSDKShareKit
import MessageUI
import TwitterKit
class HomeViewController: UIViewController {
    @IBOutlet weak var view_Venta: UIView!
    @IBOutlet weak var btn_Cal: UIButton!
    @IBOutlet weak var view_Dicom: UIView!
    @IBOutlet weak var view_Compra: UIView!
    @IBOutlet weak var lbl_DetailCompra: UILabel!
    @IBOutlet weak var lbl_Compra: UILabel!
    @IBOutlet weak var lbl_Venta: UILabel!
    @IBOutlet weak var lbl_Dicom: UILabel!
   
    
    var passValue:String?
    weak var timer: Timer?
    var messageToShare:String?
    var wsManager = WebServiceManager()
    let composeVC = MFMailComposeViewController()
    override func viewDidLoad() {
        super.viewDidLoad()
        passValue = ""
        FTIndicator.showProgress(withMessage: "Loading...")
       self.view_Venta.dropShadow()
       self.view_Compra.dropShadow()
       self.view_Dicom.dropShadow()
       btn_Cal.layer.shadowColor = UIColor.black.cgColor
       btn_Cal.layer.shadowOffset =  CGSize(width: 2, height: 2)
       btn_Cal.layer.shadowRadius = 2
       btn_Cal.layer.shadowOpacity =  0.7
        self.getData()
       
}
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Hide the navigation bar on the this view controller
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    self.stopTimer()
        timer = Timer.scheduledTimer(withTimeInterval: 5.00, repeats: true) { [weak self] _ in
            self?.getData()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.stopTimer()
    }
    func setViewShadow(view:UIView) {
      
    }
    func getData(){
        // do something here
        self.wsManager.getData(completionHandler: {(sucess,data,message)->
            Void in
            FTIndicator.dismissProgress()
            if sucess{
               self.setUpView(data: data)
            }
            else{
                FTIndicator.showError(withMessage: message)
            }
            
        })
    
    
    }
    func stopTimer() {
        timer?.invalidate()
    }
    func setUpView(data:NSDictionary){
       let purchase = data.object(forKey: "purchase") as! NSDictionary
        let sell = data.object(forKey: "sell") as! NSDictionary
        let dollorInDicom = data.object(forKey: "dollor_in_dicom") as! NSDictionary
        passValue = String(describing: purchase.object(forKey: "precio")!)
        lbl_Compra.text = "COMPRA: \(String(describing: passValue!))Bs/$"
        lbl_DetailCompra.text = "Actualizado: \(String(describing: purchase.object(forKey: "fecha")!))"
        lbl_Venta.text = "VENTA: \(String(describing: sell.object(forKey: "precio")!))Bs/$"
       lbl_Dicom.text = "DICOM: \(String(describing: dollorInDicom.object(forKey: "precio")!))Bs/$"
       
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueCalculate" {
            let vc = segue.destination as! ConvertCurrencyViewController
            if let value = passValue{
                vc.value = value
            }
            else{
                vc.value = "0"
            }
            
        }
    }
//@IBAction func action_ShowActivityController(_ sender: Any) {
//    let value = "Último precio de la moneda\n\(String(describing: lbl_DetailCompra.text!))\n\(String(describing: lbl_Compra.text!))\n\(String(describing: lbl_Venta.text!))\n\(String(describing: lbl_Dicom.text!))"
//    let activityViewController: UIActivityViewController =   UIActivityViewController(activityItems: [value], applicationActivities: nil)
//    activityViewController.excludedActivityTypes = [UIActivityType.airDrop];
//    activityViewController.setValue("Los Benjamins", forKey: "subject")
// activityViewController.popoverPresentationController?.sourceView=self.view
//    present(activityViewController, animated: true, completion: nil)
//   }
    
    @IBAction func action_Sharing(_ sender: UIButton) {
      messageToShare = "Los Benjamins\nhttp://www.losbenjamins.com/\nÚltimo precio de la moneda\n\(String(describing: lbl_DetailCompra.text!))\n\(String(describing: lbl_Compra.text!))\n\(String(describing: lbl_Venta.text!))\n\(String(describing: lbl_Dicom.text!))"
        switch sender.tag {
        case 101:
            self.whatsAppShare()
        case 102:
           self.sendEmail()
        case 103:
            self.fbShare()
        case 104:
            self.twitterShare()
        default:
            break
        }
    }
    func whatsAppShare(){
        let urlWhats = "whatsapp://send?text=\(messageToShare!)"
        if let urlString = urlWhats.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) {
            if let whatsappURL = NSURL(string: urlString) {
                if UIApplication.shared.canOpenURL(whatsappURL as URL) {
                    UIApplication.shared.open(whatsappURL as URL, options: [:], completionHandler: { (sucess) in
                        if !sucess{
                           FTIndicator.showToastMessage("Unable to send share througn whatsApp")
                            }
                    })
                 
                } else {
                    FTIndicator.showToastMessage("Plese install whatsApp")
                }
            }
        }
        
    }
    func sendEmail() {
        
        composeVC.mailComposeDelegate = self
        // Configure the fields of the interface.
        composeVC.setSubject("Help")
        composeVC.setMessageBody(messageToShare!, isHTML: false)
        // Present the view controller modally.
        self.present(composeVC, animated: true, completion: nil)
    }
    func twitterShare(){
        let composer = TWTRComposer()
        composer.setText(messageToShare)
        composer.show(from: self) { (result) in
        }
    }
    func fbShare(){
        let content : FBSDKShareLinkContent = FBSDKShareLinkContent()
        content.contentURL = NSURL(string: "https://losbenjamins.com") as URL!
        let shareDialog: FBSDKShareDialog = FBSDKShareDialog()
        shareDialog.shareContent = content
        shareDialog.delegate = self
        shareDialog.mode = .feedWeb
        shareDialog.fromViewController = self
        shareDialog.show()
        }
      
}
extension HomeViewController:FBSDKSharingDelegate {
    func sharer(_ sharer: FBSDKSharing!, didCompleteWithResults results: [AnyHashable : Any]!) {
        print(results)
    }
    func sharer(_ sharer: FBSDKSharing!, didFailWithError error: Error!)
{
    print("sharer NSError")
    
}

    func sharerDidCancel(_ sharer: FBSDKSharing!)
{
    print("sharerDidCancel")
    }
    
}
extension HomeViewController:MFMailComposeViewControllerDelegate{
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        switch result {
        case .cancelled:
            break
        case .saved:
            break
        case .sent:
            break
        case .failed:
            break
            
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
    
    

extension UIView {
    
    // OUTPUT 1
    func dropShadow(scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    // OUTPUT 2
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        self.layer.masksToBounds = false
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowOffset = offSet
        self.layer.shadowRadius = radius
        
        self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
        self.layer.shouldRasterize = true
        self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
}
