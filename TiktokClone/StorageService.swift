//
//  StorageService.swift
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

class StorageService {
    static func savePhoto(username:String,uid:String,data:Data, metadata:StorageMetadata, storageProfileRef:StorageReference,dict:Dictionary<String,Any>,onSuccess:@escaping()->Void,onError:@escaping(_ errorMessage:String)->Void) {
        
        storageProfileRef.putData(data, metadata: metadata) { data, err in
            if err != nil {
                onError(err!.localizedDescription)
                return
            }
            
            storageProfileRef.downloadURL { url, err in
                
                if let metaImageUrl = url?.absoluteString  {
                    
                    if let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest() {
                        changeRequest.displayName = username
                        changeRequest.photoURL = url
                        changeRequest.commitChanges { error in
                            if let error = error {
                                ProgressHUD.showError(error.localizedDescription)
                            }
                        }
                    }
                    
                    var dictTemp  = dict
                    dictTemp[PROFILE_IMAGE_URL] = metaImageUrl
                    
                    Ref().databaseUserSpesific(uid: uid).updateChildValues(dictTemp) { err, ref in
                        if err != nil {
                            onError(err!.localizedDescription)
                        }else {
                            onSuccess()
                        }
                    }
                }
            }
        }
                
    }
}
