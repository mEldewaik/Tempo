//
//  UIViewController+Ext.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 16/06/2021.
//

import UIKit
import NVActivityIndicatorView

extension UIViewController: NVActivityIndicatorViewable {
    
    func startAnimate(){
        let size = CGSize(width: 60, height: 60)
        self.startAnimating(size, message: "", type: .ballPulseSync, color: #colorLiteral(red: 0, green: 0.8300948739, blue: 0.7751371861, alpha: 1), padding: 6)
    }
    
    func stopAnimate(){
        self.stopAnimating(nil)
    }
}
