//
//  ViewController.swift
//  Listing
//
//  Created by Apple's on 07/05/18.
//  Copyright © 2018 Aadil. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseDatabase
import FirebaseCore
import FirebaseStorage
import SDWebImage

struct ImageDetails {
    let image : String
    let imageName : String
    let imgDesc : String
}
var imageNameAsCount = 0
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet weak var tblView: UITableView!
    
    var activityView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    var imagePicker: UIImagePickerController!
    var imageTake: UIImageView!
    var imageDataArray : [ImageDetails] = []
    var currentltyUploadedImage : String!
    var currentltyUploadedImageName : String!
    var currentltyUploadedImageDesc : String!
    
    override func viewDidLoad() {
    self.getImageDataFromFirebase()
    }
    
    func getImageDataFromFirebase(){
        showLoader()
        let ref = Database.database().reference().child("AadilDataBsse").child("AdilKashan")
        
        ref.child("PicturesData").observeSingleEvent(of: .value, with: {
            snapshot in
            for key in snapshot.children
            {
                let data = (key as! DataSnapshot).value as! [String:String]
                if let imgUrl = data["imageUrl"],let title = data["Title"],let desc = data["imageDesc"] {
                    let imgData = ImageDetails(image:imgUrl , imageName:title , imgDesc:desc )
                    self.imageDataArray.append(imgData)
                }
            }
            imageNameAsCount = self.imageDataArray.count
            self.tblView.reloadData()
            self.activityView.stopAnimating()
        })
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! myTVC
        let imageData = imageDataArray[indexPath.row]
        cell.myImg.sd_setImage(with: URL(string: imageData.image), placeholderImage: #imageLiteral(resourceName: "placeholderImag"))
        cell.nameLbl.text = imageData.imageName
        cell.sizeLbl.text = imageData.imgDesc
        cell.nameLbl.attributedText = NSAttributedString(string: imageData.imageName, attributes:
            [.underlineStyle: NSUnderlineStyle.styleSingle.rawValue])
        return cell
    }
    
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController2") as! ViewController2
        let imageData = imageDataArray[indexPath.row]
        vc.image = imageData.image
        vc.imageName = imageData.imageName
        vc.imgDesc = imageData.imgDesc
        self.present(vc, animated: true, completion: nil)
    }

    @IBAction func uploadBtn(_ sender: Any) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: - Saving Image here
    @IBAction func save(_ sender: AnyObject) {
        UIImageWriteToSavedPhotosAlbum(imageTake.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    //MARK: - Add image to Library
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    //MARK: - Done image capture here
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let pickedImage = info["UIImagePickerControllerOriginalImage"] as! UIImage
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewController3") as! ViewController3
        vc.selectedImage = pickedImage
        vc.viewController = self
        self.present(vc, animated: true, completion: nil)
}
    func relodTableWithUpdatedData() {
     let imgData = ImageDetails(image: currentltyUploadedImage, imageName: currentltyUploadedImageName, imgDesc: currentltyUploadedImageDesc)
        imageDataArray.append(imgData)
        imageNameAsCount = self.imageDataArray.count
        self.tblView.reloadData()
        
    }
    func showLoader() {
        activityView.center = self.view.center
        activityView.startAnimating()
        view.addSubview(activityView)
        
    }
    
}



