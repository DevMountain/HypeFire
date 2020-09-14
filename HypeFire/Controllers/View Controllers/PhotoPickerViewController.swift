//
//  PhotoPickerViewController.swift
//  HypeFire
//
//  Created by Cameron Stuart on 7/12/20.
//  Copyright © 2020 Cameron Stuart. All rights reserved.
//

import UIKit

protocol PhotoSelectorDelegate: AnyObject {
    func photoPickerSelected(image: UIImage)
}

class PhotoPickerViewController: UIViewController {
    
    //MARK: - Outlets
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var selectPhotoButton: UIButton!
    
    //MARK: - Properties
    let imagePicker = UIImagePickerController()
    weak var delegate: PhotoSelectorDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    //MARK: - Actions
    @IBAction func selectPhotoButtonTapped(_ sender: Any) {
        let alertController = UIAlertController(title: "Add a photo", message: nil, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            self.imagePicker.dismiss(animated: true, completion: nil)
        }
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default) { (_) in
            self.openCamera()
        }
        
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { (_) in
            self.openPhotoLibrary()
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(cameraAction)
        alertController.addAction(photoLibraryAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - Helper Methods
    func setupViews() {
        imagePicker.delegate = self
        photoImageView.contentMode = .scaleAspectFill
        photoImageView.clipsToBounds = true
        photoImageView.backgroundColor = .systemTeal
    }
}

extension PhotoPickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "No Camera Access", message: "Please allow access to the camera to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "No Photo Library Access", message: "Please allow access to the photo library to use this feature.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[.editedImage] as? UIImage {
            guard let delegate = delegate else {return}
            selectPhotoButton.setTitle("Edit Photo", for: .normal)
            delegate.photoPickerSelected(image: pickedImage)
            photoImageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
