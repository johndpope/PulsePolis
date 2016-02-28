//
//  User.swift
//  PulsePolis
//
//  Created by IMAC  on 29.11.15.
//  Copyright © 2015 IMAC . All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    var firstName: String?
    var lastName: String?
    
    var age: NSNumber?
    //0 - not defined, 1- woman, 2- man
    var gender: Gender = .None
    var photoURL: String?
    
    var authorizeType: AuthorizeType?
    var vkID: String?
    var facebookID: String?
    
    var userId: Int?{
        didSet{
            self.saveUser()
        }
    }
    
    init(jsonFromFacebook: JSON) {
        super.init()
        /*
        {
        "first_name" : "Zaytseva",
        "last_name" : "Marina",
        "id" : "538085733007579",
        "age_range" : {
        "min" : 21
        },
        "gender" : "female",
        "picture" : {
        "data" : {
        "width" : 200,
        "url" : "https:\/\/scontent.xx.fbcdn.net\/hprofile-xfa1\/v\/t1.0-1\/p200x200\/11164785_465435746939245_9071997927249509104_n.jpg?oh=46830c80d54a314eb2a6372fcf3bb439&oe=573DEE06",
        "is_silhouette" : false,
        "height" : 200
        }
        }
        }
        */
        self.firstName = jsonFromFacebook["first_name"].string
        self.lastName = jsonFromFacebook["last_name"].string
        self.facebookID = jsonFromFacebook["id"].string
        
        if let gender = jsonFromFacebook["gender"].string{
            switch(gender){
            case "female":
                self.gender = Gender.Female
                break
            case "male":
                self.gender = Gender.Male
                break
            default:
                self.gender = Gender.None
                break
            }
        }
        
        if let url = jsonFromFacebook["picture"]["data"]["url"].string{
            self.photoURL = url
        }
        
        self.authorizeType = AuthorizeType.Facebook
        
    }
    
    init(jsonFromVK: JSON){
        super.init()
        /*
        {
        bdate = "15.4";
        "first_name" = Marina;
        id = 143900400;
        "last_name" = Zaytseva;
        "photo_200" = "https://pp.vk.me/c622929/v622929400/4c68e/fP1ttZxXlDo.jpg";
        sex = 1;
        }
        */
        print(jsonFromVK)
        var array = jsonFromVK.array
        if(array?.isEmpty == false){
            self.firstName = array?[0]["first_name"].string
            self.lastName = array?[0]["last_name"].string
            self.vkID = array?[0]["id"].string
            self.photoURL = array?[0]["photo_200"].string
            
            if let gender = array?[0]["sex"].int{
                if(gender == 1){
                    self.gender = Gender.Female
                } else if(gender == 2){
                    self.gender = Gender.Male
                } else {
                    self.gender = Gender.None
                }
            }
            self.authorizeType = AuthorizeType.VK
        }
    }
    
    override init(){
        super.init()
    }
    
    static func getUserFromDefaults() -> User?{
        let def = NSUserDefaults.standardUserDefaults()
        var u: User?
        
        if let fName = def.valueForKey("firstName") as? String{
            u = User()
            u?.firstName = fName
            
            if let lName = def.valueForKey("lastName") as? String{
                u?.lastName = lName
            }
            if let vkid = def.valueForKey("vkID") as? String{
                u?.vkID = vkid
            }
            if let facebookid = def.valueForKey("facebookID") as? String{
                u?.facebookID = facebookid
            }
            if let ag = def.valueForKey("age") as? NSNumber{
                u?.age = ag
            }
            if let gend = def.valueForKey("gender") as? Int{
                if let newGender = Gender(rawValue: gend){
                    u?.gender = newGender
                }
            }
            if let phURL = def.valueForKey("photoURL") as? String{
                u?.photoURL = phURL
            }
            if let id = def.valueForKey("userID") as? Int{
                u?.userId = id
            }
            if let authType = def.valueForKey("authType") as? String{
                if let newAuthType = AuthorizeType(rawValue: authType){
                    u?.authorizeType = newAuthType
                }
            }
        }
        
        return u
    }
    
    func saveUser(){
        let def = NSUserDefaults.standardUserDefaults()
        def.setValue(firstName, forKey: "firstName")
        def.setValue(lastName, forKey: "lastName")
        def.setValue(photoURL, forKey: "photoURL")
        def.setValue(gender.rawValue, forKey: "gender")
        def.setValue(vkID, forKey: "vkID")
        def.setValue(facebookID, forKey: "facebookID")
        def.setValue(age, forKey: "age")
        def.setValue(userId, forKeyPath: "userID")
        def.setValue(authorizeType?.rawValue, forKeyPath: "authType")
        def.synchronize()
    }
    
    func deleteUser(){
        let def = NSUserDefaults.standardUserDefaults()
        
        def.removeObjectForKey("firstName")
        def.removeObjectForKey("lastName")
        def.removeObjectForKey("photoURL")
        def.removeObjectForKey("gender")
        def.removeObjectForKey("vkID")
        def.removeObjectForKey("facebookID")
        def.removeObjectForKey("age")
        def.removeObjectForKey("userID")
        def.removeObjectForKey("authType")
        
        def.synchronize()
        
        var u: User?
        APP.i().user = u
    }
    
    
}
