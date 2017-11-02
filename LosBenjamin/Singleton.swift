//
//  Singleton.swift
//  LosBenjamin
//
//  Created by MAC on 24/10/17.
//  Copyright © 2017 Orem. All rights reserved.
//

import UIKit
let sharedManager: Singleton = Singleton()
class Singleton: NSObject {
    //MARK:- Variable and constant
    //MARK:- Initialization
    override init()
    {
        super.init()
    }
    class var sharedInstance : Singleton {
        return sharedManager
    }
}
