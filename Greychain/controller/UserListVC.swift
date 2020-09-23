//
//  ViewController.swift
//  Greychain
//
//  Created by Mujahid on 23/09/20.
//  Copyright © 2020 Individual. All rights reserved.
//

import UIKit

class UserListVC: UIViewController,UserAddVCdelegate,UserListtableCellDelegate {
    func onClickItem(res: UserList?) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserAddVC") as! UserAddVC
        vc.userList = res
        vc.isUpdate = true
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    

    @IBOutlet weak var tableView: UITableView!
    var userList:[UserList]? = [UserList]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = Constant.USER_LIST
        userList = DatabaseHelper.shareInstance.getUserData().reversed()
        setupTableView()
    }
    func reloadData() {
      userList = DatabaseHelper.shareInstance.getUserData().reversed()
        setupTableView()
    }
    
    func setupTableView() {
        // register  the cell
        tableView.register(UINib(nibName: "UserListTableCell", bundle: nil), forCellReuseIdentifier: "UserListTableCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.reloadData()
    }
    @IBAction func onClickAdd(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "UserAddVC") as! UserAddVC
        navigationController?.pushViewController(vc, animated: true)
    }
    func getRowsCount() -> Int{
        if let data = userList{
            return data.count
        }else{
            return 0
        }
    }
}
extension UserListVC:UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return getRowsCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserListTableCell", for: indexPath) as! UserListTableCell
        // setting data the UITableViewCell
        cell.delegate = self
        cell.setData(res: userList![indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            userList = DatabaseHelper.shareInstance.deleteUser(index: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

