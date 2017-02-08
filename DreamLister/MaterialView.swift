//
//  MaterialView.swift
//  DreamLister
//
//  Created by pranav gupta on 30/01/17.
//  Copyright © 2017 Pranav gupta. All rights reserved.
//

import UIKit

private var materialKey = false

extension UIView {

        @IBInspectable var MaterialDesign : Bool {
        
        
        get{
            return materialKey
        }
        
        set{
            materialKey = newValue
            if materialKey {
                
                self.layer.masksToBounds = false
                self.layer.cornerRadius = 3.0
                self.layer.shadowOpacity = 0.8
                self.layer.shadowColor = UIColor(red: 157/255, green: 158/255, blue: 159/255, alpha: 1.0).cgColor
                self.layer.shadowRadius = 3.0
                self.layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
                
            }else{
                
                self.layer.cornerRadius = 0.0
                self.layer.shadowOpacity = 0.0
                self.layer.cornerRadius = 0.0
                self.layer.shadowColor = nil
            }
                
        }
            
            
            
    }
    
    
}

