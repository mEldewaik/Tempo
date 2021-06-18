//
//  Helper.swift
//  Tempo
//
//  Created by Mohamed Eldewaik on 16/06/2021.
//

import Foundation
import Kingfisher

class HelperMethods: NSObject {
    
    class func configureImage(_ imageString: String?,_ image: UIImageView,_ placeholder: String) {
        guard let imageString = imageString else { return }
        if let encoded = imageString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed),
            let url = URL(string: encoded) {
            image.kf.indicatorType = .activity
            image.kf.setImage(with: url,
                              placeholder: nil,
                              options: [
                                .scaleFactor(UIScreen.main.scale),
                                .transition(.fade(1)),
                                .cacheOriginalImage
                              ]) { (img,error) in
                
            }
        }
        
    }

}
