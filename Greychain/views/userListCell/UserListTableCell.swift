//
//  UserListTableCell.swift
//  Greychain
//
//  Created by Mujahid on 23/09/20.
//  Copyright © 2020 Individual. All rights reserved.
//

import UIKit
protocol UserListtableCellDelegate {
    func onClickItem(res:UserList?)
}

class UserListTableCell: UITableViewCell {
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var lbEmail: UILabel!
    @IBOutlet weak var lbName: UILabel!
    var delegate:UserListtableCellDelegate?
    var userList:UserList?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tap = UITapGestureRecognizer(target: self, action: #selector(onTap))
        mainView.isUserInteractionEnabled = true
        mainView.addGestureRecognizer(tap)
    }
    @objc func onTap(){
        if userList != nil {
            delegate?.onClickItem(res: userList)
        }
    }
    func setData(res:UserList?){
        if res != nil {
            userList = res
        }
        
        if let name = res?.name{
            lbName.isHidden = false
            lbName.text = name
        }else{
            lbName.isHidden = true
        }
        
        if let email = res?.email{
            lbEmail.isHidden = false
            lbEmail.text = email
        }else{
            lbEmail.isHidden = true
        }
        
    }
    
}
