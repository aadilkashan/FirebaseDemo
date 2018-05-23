//
//  ViewController3.swift
//  Listing
//
//  Created by Apple's on 08/05/18.
//  Copyright © 2018 Aadil. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage

class ViewController3: UIViewController {

    @IBOutlet weak var uploadBtn: UIButton!
    
    @IBOutlet weak var imageName: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var imageView3: UIImageView!
    var selectedImage : UIImage!
    var viewController : ViewController!
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    
    
    var imageReference: StorageReference {
        return Storage.storage().reference().child("images")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.imageView3.image = selectedImage
        // Do any additional setup after loading the view.
        
    }

    @IBAction func uploadBtn(_ sender: Any) {
        if self.imageName.text != "" && self.desc.text != "" {
            self.uploadMedia(title: self.imageName.text!, imageDesc: self.desc.text!, selectedImage: self.imageView3.image!)
        } else {
         showErrorAlert()
        }
    }
    
    func showErrorAlert(){
        let alertController = UIAlertController(title: "Fill all the details in textfeild.", message: "", preferredStyle: UIAlertControllerStyle.alert)
        let ok = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: {(action) -> Void in
        })
        
        alertController.addAction(ok)
        self.present(alertController, animated: true, completion: nil)
    }
    @IBAction func cancelBtn(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func uploadPicturesDataToFireBase(title : String,imageDesc : String,imageUrl : String) {
        var ref: DatabaseReference!
        ref = Database.database().reference()
        let uid = "AdilKashan"
        let imageInfoDict = ["Title" : title  ,"imageDesc" : imageDesc,"imageUrl" : imageUrl]
        ref.child("AadilDataBsse").child(uid).child("PicturesData").childByAutoId().setValue(imageInfoDict)
    }
    
    func uploadMedia(title : String,imageDesc : String,selectedImage : UIImage) {
        
        guard let imageData = UIImageJPEGRepresentation(selectedImage, 1) else { return }
        let filename = self.imageName.text! + "\(imageNameAsCount + 1).JPG"
        let uploadImageRef = imageReference.child(filename)
        self.showLoader()
        let uploadTask = uploadImageRef.putData(imageData, metadata: nil) { (metadata, error) in
            print("UPLOAD TASK FINISHED")
            print(metadata ?? "NO METADATA")
            print(error ?? "NO ERROR")
            self.uploadPicturesDataToFireBase(title: title, imageDesc: imageDesc, imageUrl: (metadata?.downloadURL()?.absoluteString)!)
            self.activityView.stopAnimating()
            self.dismiss(animated: true, completion: {
                self.viewController.currentltyUploadedImage = metadata?.downloadURL()?.absoluteString
                self.viewController.currentltyUploadedImageName = self.imageName.text!
                self.viewController.currentltyUploadedImageDesc = self.desc.text!
                self.viewController.relodTableWithUpdatedData()
            })
        }
        
        uploadTask.observe(.progress) { (snapshot) in
            print(snapshot.progress ?? "NO MORE PROGRESS")
            
        }
        
        uploadTask.resume()
        
    }
    
    ////////////
    func showLoader() {
        activityView.center = self.uploadBtn.center
        activityView.startAnimating()
        view.addSubview(activityView)
        self.uploadBtn.isHidden = true
}
    /////////////
}
