//
//  EventDetailViewController.swift
//  ARText
//
//  Created by nikilesh balaji on 2/19/22.
//  Copyright © 2022 Mark Zhong. All rights reserved.
//

import UIKit
import Photos
import OpalImagePicker

class EventDetailViewController: UIViewController, UITextFieldDelegate, OpalImagePickerControllerDelegate {

    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var eventName: UITextField!
    @IBOutlet weak var eventDescription: UITextField!
    
    @IBOutlet weak var uploadButton: UIButton!
    var imagePicker: OpalImagePickerController!
    var assets: [PHAsset] = []
    var userImage: [Data] = []
    var location: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.eventName.delegate = self
        self.eventDescription.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.submitButton.layer.borderWidth = 1.0
        self.submitButton.layer.borderColor = UIColor.black.cgColor
        self.submitButton.layer.cornerRadius = 20
        self.uploadButton.layer.borderWidth = 1.0
        self.uploadButton.layer.borderColor = UIColor.black.cgColor
        self.uploadButton.layer.cornerRadius = 20
    }
    
    func checkPermission(imagePicker1: OpalImagePickerController) {
        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        switch photoAuthorizationStatus {
        case .authorized:
            print("Access is granted by user")
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                print("status is \(newStatus)")
                if newStatus ==  PHAuthorizationStatus.authorized {
                    print("success")
                }
            })
            print("It is not determined until now")
        case .restricted:
            // same same
            print("User do not have access to photo album.")
        case .denied:
            // same same
            print("User has denied the permission.")
        case .limited:
            print(".limited")
        }
    }
    
    
    @IBAction func uploadPhotos(_ sender: Any) {
        let imagePicker1 = OpalImagePickerController()
        checkPermission(imagePicker1: imagePicker1)
        imagePicker1.imagePickerDelegate = self
        self.modalPresentationStyle = .fullScreen
        self.present(imagePicker1, animated: true, completion: nil)
        
    }
    
    @IBAction func submit(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerDidCancel(_ picker: OpalImagePickerController) {
        
      }
    
    

    func imagePicker(_ picker: OpalImagePickerController, didFinishPickingAssets assets: [PHAsset]) {
        self.assets = assets
        DispatchQueue.global(qos: .background).async {
            self.userImage = assets.map{ return UIImagePNGRepresentation($0.image)! }
            storeInUserdefault(userData: self.userImage, withKey: "data")
            storeInUserdefault(userData: self.eventName.text ?? "", withKey: "eventName")
            storeInUserdefault(userData: self.location.latitude.description, withKey: "lat")
            storeInUserdefault(userData: self.location.longitude.description, withKey: "lng")
        }
          presentedViewController?.dismiss(animated: true, completion: {
              DispatchQueue.main.async {
                  self.collectionView.reloadData()
              }
          })
      }
    
}

extension EventDetailViewController : UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return assets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageData", for: indexPath) as? ImageCollectionViewCell
        
        cell?.userSelectedImage.image = assets[indexPath.row].image
        cell?.userSelectedImage.layer.borderWidth = 1.0
        cell?.userSelectedImage.layer.borderColor = UIColor.black.cgColor
        
        return cell!
    }
    
}

extension PHAsset {

    var image : UIImage {
        var thumbnail = UIImage()
        let imageManager = PHCachingImageManager()
        let options = PHImageRequestOptions()
        options.version = .original
        options.isSynchronous = true
        imageManager.requestImage(for: self, targetSize: CGSize(width: 1280, height: 1024), contentMode: .aspectFill, options: options, resultHandler: { image, _ in
            thumbnail = image!
        })
        return thumbnail
    }
}

