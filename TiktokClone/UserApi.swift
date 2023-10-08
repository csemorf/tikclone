//
//  UserApi.swift
//  TiktokClone
//
//  Created by admin on 06/10/2023.
//

import PhotosUI
import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import ProgressHUD

class UserApi {
    func signIn(with email:String,password:String,onSuccess:@escaping()->Void,onError:@escaping(_ errorMessage:String)->Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authData, error in
            if let error = error {
                onError(error.localizedDescription)
                return
            }
            print(authData?.user.uid)
            
            onSuccess()
        }
    }
    
    func signUp(with username:String,email:String, password:String,image:UIImage?,onSuccess:@escaping()->Void,onError:@escaping(_ errorMessage:String)->Void){
        
        guard let imageSelected = image else {
            ProgressHUD.showError("please enter profile image")
            return}
        
        guard let imageData = imageSelected.jpegData(compressionQuality: 0.4) else {return}
        
        
        Auth.auth().createUser(withEmail: email, password: password) { authData, err in
            if err != nil {
                ProgressHUD.showError("something wrong creaet user")
                return
            }
            
            if let authData = authData {
                let dict : Dictionary<String,Any> = [
                    UID:authData.user.uid,
                    EMAIL:authData.user.email as Any,
                    USERNAME:username,
                    PROFILE_IMAGE_URL:"",
                    STATUS:""
                ]
                
//              let storageRef = Storage.storage().reference(forURL:  "gs://tiktokclone-ff164.appspot.com")
//              let storageProfileRef = storageRef.child("profile").child(authData.user.uid)
                
                let storageProfileRef = Ref().storageProfileSpesific(uid: authData.user.uid)
                
                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                    
                StorageService.savePhoto(username: username, uid: authData.user.uid, data:imageData, metadata: metadata, storageProfileRef: storageProfileRef, dict: dict) {
                    onSuccess()
                } onError: { errorMessage in
                    onError(errorMessage)
                }
              
                
                
            }
        }
    }
    func logout() {
        do {
        try    Auth.auth().signOut()
            
            let scene =  UIApplication.shared.connectedScenes.first
            if let sceneDelegate = (scene?.delegate as? SceneDelegate) {
                sceneDelegate.setupInitialViewController()
            }
        }catch {
            ProgressHUD.showError(error.localizedDescription)
            return
        }
        
        
        
    }
}
