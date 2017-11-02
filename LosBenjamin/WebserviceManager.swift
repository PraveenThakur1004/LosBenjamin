//
//  WebserviceManager.swift
//  LosBenjamin
//
//  Created by MAC on 24/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import FTIndicator
class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

//MARK- BaseUrl
let baseURL = "http://nimbyisttechnologies.com/himanshu/historico/"
//MARK - RegisterDeviceToken
let deviceTokenUrl = baseURL + "device_register.php?"

class WebServiceManager:NSObject{
    //MARK:-Almofire  request
    //PostRequest
    func alamofirePost(parameter : NSDictionary , urlString : String, completionHandler: @escaping (NSDictionary?, NSError?) -> ()) {
        if Connectivity.isConnectedToInternet{
            Alamofire.request(urlString, method: .post, parameters: nil, encoding: JSONEncoding.default , headers: nil).responseJSON { (response:DataResponse<Any>) in
             
                switch(response.result) {
                case .success(_):
                    if response.result.value != nil{
                        let dict  =  response.result.value as! NSDictionary
                        completionHandler(dict, nil)
                        
                    }
                    break
                case .failure(_):
                    FTIndicator.showError(withMessage:"Unable to find the result")
                    break
                }
            }
        }
        else{
            FTIndicator.showError(withMessage:"Network not available")
        }
    }
    //GetRequest
    func alamofireGet(urlString:String,completionHandler:@escaping(AnyObject)-> ()){
        if Connectivity.isConnectedToInternet{
            Alamofire.request(urlString).responseJSON{ response in // method defaults to `.get`
                debugPrint(response)
                
                switch(response.result){
                case .success(_):
                    if let JSON = response.result.value {
                        completionHandler(JSON as AnyObject)
                    }
                    break
                case .failure(_):
                    FTIndicator.showError(withMessage:"Unable to find the result")
                    break
                }
            }}
        else{
            FTIndicator.showError(withMessage:"Network not available")
        }
    }
    
    //GET Data
    func getData( completionHandler closure:@escaping (_ sucess:Bool, _ data:NSDictionary, _ message:String? ) -> Void){
        
        if URL(string:baseURL ) != nil {
            self.alamofireGet(urlString: baseURL, completionHandler: { result in
                var success = false
                var message: String?
                var data = NSDictionary()
                let status = result["response"] as? String
                if  status == "1" {
                    success = true
                    data  = (result["data"] as? NSDictionary)!
                    message = result["mesg"] as? String;
                }
                else {
                    
                    message = result["mesg"] as? String;
                }
                closure( success, data, message)
            })
        }
    }
    //http://nimbyisttechnologies.com/himanshu/historico/device_register.php?imei=1234&device_token=555555&device_type=2
    //UpdateToken
    func updateToken(_ devicetoken: String, completionHandler closure: @escaping ( _ success: Bool) -> Void) {
        if URL(string: deviceTokenUrl) != nil {
            var uniqueId = ""
            if let id = UIDevice.current.identifierForVendor?.uuidString {
                uniqueId = id
            }
            let queryString = deviceTokenUrl + "imei=\(uniqueId)"  + "&device_token=\(devicetoken)" + "&device_type=1" ;
            print(queryString)
            self.alamofirePost(parameter: [:], urlString:  queryString, completionHandler: { (result, error) -> Void in
                var success = false
                let status = result?["response"] as! String
                if  status == "1" {
                    success = true
                    
                }
                else {
                    success = false
                }
                closure(success );
            })
        }
    }
    
    
}


