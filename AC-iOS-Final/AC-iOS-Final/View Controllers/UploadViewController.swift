//
//  UploadViewController.swift
//  AC-iOS-Final
//
//  Created by C4Q on 2/26/18.
//  Copyright © 2018 C4Q . All rights reserved.
//

import UIKit
import AVFoundation
import Toucan

class UploadViewController: UIViewController {

    private var imagePickerViewController = UIImagePickerController()
    private var currentSelectedImage: UIImage?
    
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textView: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerViewController.delegate = self
        self.textView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        imageView.layer.borderWidth = 0.2
        imageView.layer.borderColor = UIColor.black.cgColor
        textView.layer.borderWidth = 0.2
        textView.layer.borderColor = UIColor.black.cgColor
    }
    
    @IBAction func doneButtonPressed(_ sender: UIBarButtonItem) {
        guard let image = currentSelectedImage else {
            showAlert(title: "NO image", message: "Please choose an image from album or using camera")
            return}
            guard let comment = textView.text, comment != "Enter comment here" else {
               showAlert(title: "No comment", message: "Please write a comment")
                return
            }
        // upload to firebase
        DBService.manager.addPost(comment: comment, image: image)
        self.imageView.image = nil
        self.currentSelectedImage = nil
        self.cameraButton.isHidden = false
        showAlert(title: "Success", message: "You've successfully created a post")
    }
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    private func showActionSheet() {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "Camera", style: .default) { [weak self](action) in
            self?.imagePickerViewController.sourceType = .camera
  //          self?.checkAVAuthoriation()
            self?.showPhotoLibrary()
        }

        let album = UIAlertAction(title: "Choose from Album", style: .default) { [weak self](action) in
            self?.imagePickerViewController.sourceType = .photoLibrary
          //  self?.checkAVAuthoriation()
            self?.showPhotoLibrary()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            alert.addAction(camera)
        }
        alert.addAction(album)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func cameraButtonPressed(_ sender: UIButton) {
        showActionSheet()
    }
    /*
    private func checkAVAuthoriation() {
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .notDetermined:
              print("notDetermined")
              AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
                if granted {
                    self.showPhotoLibrary()
                } else {
                    print("not granted")
                }
              })
        case .denied:
             print("denied")
        case .restricted:
            print("restricted")
        case .authorized:
             print("authorized")
            self.showPhotoLibrary()
        }
    }
 */
    func showPhotoLibrary() {
        present(imagePickerViewController, animated: true, completion: nil)
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
extension UploadViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerOriginalImage] as? UIImage else {
           print("image is nil")
            return
        }
        imageView.image = image
        self.cameraButton.isHidden = true
        // resize the image using Toucan
        let imageSize = CGSize(width: 200, height: 200)
        let toucanImage = Toucan.Resize.resizeImage(image, size: imageSize)
        currentSelectedImage = toucanImage
        dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
extension UploadViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        textView.text = ""
    }
    
}













