//
//  UserAddVC.swift
//  Greychain
//
//  Created by Mujahid on 23/09/20.
//  Copyright © 2020 Individual. All rights reserved.
//

import UIKit
import MobileCoreServices
protocol UserAddVCdelegate {
    func reloadData()
}
class UserAddVC: UIViewController {
    
    @IBOutlet weak var imgContainer: UIView!
    @IBOutlet weak var btnSaveAndUpdate: UIButton!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var tfEmail: UITextField!
    @IBOutlet weak var tfName: UITextField!
    @IBOutlet weak var tfDOB: UITextField!
    let imagePicker = UIImagePickerController()
    var delegate:UserAddVCdelegate?
    var userList:UserList?
    var isUpdate:Bool? = false
    override func viewDidLoad() {
        super.viewDidLoad()
        // for the date picker
        self.tfDOB.setInputViewDatePicker(target: self, selector: #selector(onTap))
        
        // condition for update and save screen, isUpdate = true means update screen
        if isUpdate == true{
            tfEmail.isUserInteractionEnabled = false
            btnSaveAndUpdate.setTitle(Constant.UPDATE, for: .normal)
            self.title = Constant.INFO
        }else{
            self.title = Constant.ADD_USER
            tfEmail.isUserInteractionEnabled = true
            btnSaveAndUpdate.setTitle(Constant.SAVE, for: .normal)
        }
        // setup ui for update
        setupUIForUpdate()
        
    }
    @IBAction func onClickOpenImage(_ sender: Any) {
        // open imagepicker
        openImagePicker()
    }
    override func viewDidLayoutSubviews() {
        // make the imgView round
        imgView.layer.cornerRadius = imgView.frame.size.width / 2.0
        
    }
    
    func setupUIForUpdate() {
        if userList != nil {
            
            if let name = userList?.name{
                tfName.text = name
            }
            if let email = userList?.email{
                tfEmail.text = email
            }
            if let dob = userList?.dob{
                tfDOB.text = dob
            }
            if let img = userList?.image{
                imgView.image = UIImage(data: img)
            }
            
            
            
        }
    }
    
    @IBAction func onClickSave(_ sender: Any) {
        // validation
        guard let name = tfName.text,name.count>0 else {
            showToast(message: Constant.NAME_IS_MANDATORY, font: UIFont.systemFont(ofSize: 12))
            return
        }
        guard let email = tfEmail.text,email.count > 0,isValidEmail(email) == true else {
            showToast(message: Constant.INVALID_EMAIL, font: UIFont.systemFont(ofSize: 12))
            return
        }
        guard let dob = tfDOB.text,dob.count>0 else {
            showToast(message: Constant.DOB_IS_MANDATORY, font: UIFont.systemFont(ofSize: 12))
            return
        }
        
        let imgData = self.imgView.image?.pngData()
        
        if isUpdate == true {
            // for updating user
            DatabaseHelper.shareInstance.updateUser(name: name, email: email, dob: dob, img: imgData!)
        }else{
            //for creating user
            DatabaseHelper.shareInstance.saveUser(object: ["name":name,"email":email,"dob":dob,"image":imgData as Any])
        }
        
        guard let vcs = navigationController?.viewControllers else {return}
        for vc in vcs{
           // checking the viewController
            if vc.isKind(of: UserListVC.self){
                delegate = vc as? UserAddVCdelegate
                // removing the last viewcontroller
                navigationController?.viewControllers.removeLast()
                //call back
                delegate?.reloadData()
            }
        }
        
    }
    @objc func onTap() {
        if let datePicker = self.tfDOB.inputView as? UIDatePicker {
            let dateformatter = DateFormatter()
            dateformatter.dateStyle = .medium
            self.tfDOB.text = dateformatter.string(from: datePicker.date)
        }
        self.tfDOB.resignFirstResponder()
    }
    
}
extension UserAddVC{
    // for email valiiMilk = 14.0
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        print(emailPred.evaluate(with: email))
        return emailPred.evaluate(with: email)
    }
}

extension UserAddVC:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func openImagePicker() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            imagePicker.allowsEditing = true
            present(imagePicker, animated: true, completion: nil)
        }
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true, completion: nil)
        if let img = info[.originalImage] as? UIImage{
            self.imgView.image = img
        }
    }
}
