//
//  UIViewController.swift
//  Greychain
//
//  Created by Mujahid on 23/09/20.
//  Copyright © 2020 Individual. All rights reserved.
//

import UIKit
extension UIViewController {
    func showToast(message: String,font: UIFont){
        guard let window = UIApplication.shared.keyWindow else {return}
        let messageLbl = UILabel()
        messageLbl.text = message
        messageLbl.textAlignment = .center
        messageLbl.font = font
        messageLbl.textColor = .white
        messageLbl.backgroundColor = UIColor(white: 0, alpha: 0.5)

        let textSize:CGSize = messageLbl.intrinsicContentSize
        let labelWidth = min(textSize.width, window.frame.width - 40)

        messageLbl.frame = CGRect(x: 20, y: window.frame.height - 90, width: labelWidth + 30, height: textSize.height + 20)
        messageLbl.center.x = window.center.x
        messageLbl.layer.cornerRadius = messageLbl.frame.height/2
        messageLbl.layer.masksToBounds = true
        window.addSubview(messageLbl)

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {

        UIView.animate(withDuration: 1, animations: {
            messageLbl.alpha = 0
        }) { (_) in
            messageLbl.removeFromSuperview()
        }
        }
    }

}
