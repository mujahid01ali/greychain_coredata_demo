//
//  DatabaseHelper.swift
//  CoreDataApp
//
//  Created by Mujahid on 15/08/20.
//  Copyright © 2020 Mujahid. All rights reserved.
//

import Foundation
import CoreData
import UIKit

class DatabaseHelper{
    static var shareInstance = DatabaseHelper()
    let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext
    func saveUser(object:[String:Any]) {
        let userList = NSEntityDescription.insertNewObject(forEntityName: "UserList", into: context!) as! UserList
        userList.name = object["name"] as? String
        userList.email = object["email"] as? String
        userList.dob = object["dob"] as? String
        userList.image = object["image"] as? Data
        do{
            try context?.save()
        }catch{
            print("data not saved")
        }
    }
    
    func getUserData() -> [UserList] {
        var userData = [UserList]()
        let fetchReq = NSFetchRequest<NSManagedObject>(entityName: "UserList")
        do{
            userData = try context?.fetch(fetchReq) as! [UserList]
            
        }catch{
            print("Error to get Data")
        }
        return userData
    }
    func updateUser(name:String,email:String,dob:String,img:Data){
         let fetchRequest:NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: "UserList")
        fetchRequest.predicate = NSPredicate(format: "email = %@", email)
         do
         {
            let test = try context?.fetch(fetchRequest)
    
            let objectUpdate = test?[0] as! NSManagedObject
            objectUpdate.setValue(name, forKey: "name")
            objectUpdate.setValue(email, forKey: "email")
            objectUpdate.setValue(dob, forKey: "dob")
            objectUpdate.setValue(img, forKey: "image")
                 do{
                    try context?.save()
                 }
                 catch
                 {
                     print(error)
                 }
             }
         catch
         {
             print(error)
         }
    
     }
    
    func deleteUser(index:Int) -> [UserList]{
        var userList = getUserData()
        context?.delete(userList[index])
        userList.remove(at: index)
        do{
            try context?.save()
        }catch{
            print("cannot delete user")
        }
        return userList
     }
}
