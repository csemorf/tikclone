//
//  Ref.swift
//  TiktokClone
//
//  Created by admin on 06/10/2023.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
import FirebaseStorage


let EMAIL = "email"
let UID = "uid"
let PROFILE_IMAGE_URL = "profileImageUrl"
let STATUS = "status"
let USERNAME = "username"

let REF_USER = "users"
let URL_STORAGE_ROOT = "gs://tiktokclone-ff164.appspot.com"
let STORAGE_PROFILE = "profile"
let IDENTIFIER_MAIN = "MainVC"
let IDENTIFIER_TABBAR = "TabbarVC"


class Ref {
    
    let databaseRoot = Database.database().reference()
    var databaseUsers :DatabaseReference {
        return databaseRoot.child(REF_USER)
    }
    
    func databaseUserSpesific(uid:String) -> DatabaseReference {
        return databaseUsers.child(uid)
    }
    
    
    
    let storageRoot = Storage.storage().reference(forURL: URL_STORAGE_ROOT)
    var storageProfile:StorageReference {
        return storageRoot.child(STORAGE_PROFILE)
    }
    func storageProfileSpesific(uid:String) -> StorageReference {
        return storageProfile.child(uid)
    }
}
