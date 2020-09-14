//
//  FormFourViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/27/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import DropDown
import Alamofire

class FormFourViewController: FormsBaseViewController {
    
    // MARK: - Public Variables
    
    override var requestFull: RequestFullViewModel? {
        didSet {
            self.loadImages()
        }
    }
    
    // MARK: - Private Variables
    
    private var allPhotosData: [PhotoCellModel] = []
    private var uploadedPhotosData: [PhotoCellModel] = []
    private var currentPhotoType: String = "PAS"
    
    // MARK: - Outlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Instantiate
    
    static func instantiate() -> FormFourViewController {
        let storyboard = UIStoryboard(name: "FormFour", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "FormFour") as? FormFourViewController
            else { return FormFourViewController()}
        return controller
    }
    
    // MARK: - View Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setDelegates()
        self.setIsEditable()
    }
    
    // MARK: - Actions
    
    @IBAction func imagePickerButtonTapped(_ sender: UIButton) {
        let controller = DocumetsTypePopoverController.instantiate()
        self.presentPopoverViewController(controller: controller,
                                          sourceView: self.view,
                                          size: CGSize(width: 300, height: 300),
                                          minusY: 70, arrowDirection: UIPopoverArrowDirection(rawValue: 0))
        controller.selectedDocumentValueHendler = { [weak self] type in
            guard let self = self else { return }
            self.currentPhotoType = type
            print(type)
            self.dismiss(animated: true, completion: nil)
            self.showImagePickerController(sourceType: .photoLibrary)
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        self.showImagePickerController(sourceType: .camera)
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        self.uploadImages()
    }
    
    
    // MARK: - Networking
    
    private func loadImages() {
        guard let request = self.requestFull else { return }
        let group = DispatchGroup()
        for (key, value) in request.files {
            group.enter()
            Network.shared.downloadImage(fileId: key) { [weak self] (image) in
                guard let self = self else { return }
                self.allPhotosData.append(PhotoCellModel(photo: image, status: .approved, type: value))
                group.leave()
            }
        }
        
        group.notify(queue: .main) {
            self.collectionView.reloadData()
            if self.allPhotosData.count >= 2 {
                self.isFormFullHandler?(true)
            } else {
                self.isFormFullHandler?(false)
            }
        }
    }
    
    private func uploadImages() {
        if let id = self.createdRequestId {
            let group = DispatchGroup()
            for item in self.uploadedPhotosData {
                group.enter()
                Network.shared.uploadImage(
                    id: id, type: item.type, image: item.photo,
                    success: { (data: PhotoModel) in
                        group.leave()
                }) { (error, code) in
                    print(error)
                    group.leave()
                }
            }
            
            group.notify(queue: .main) {
                self.uploadedPhotosData = []
                self.collectionView.reloadData()
                if self.allPhotosData.count >= 2 {
                    self.isFormFullHandler?(true)
                } else {
                    self.isFormFullHandler?(false)
                }
                self.continueButtonTappedHandler?()
                self.completionHendler?(id, self.familyMemberNum)
            }
        }
    }
    
    // MARK: - Setters
    
    private func setDelegates() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func setIsEditable() {
        if self.isEditable {
            self.view.isUserInteractionEnabled = true
        } else {
            self.view.isUserInteractionEnabled = false
        }
    }
}

  //*****************************************//
 // MARK: - UIImagePickerControllerDelegate //
//*****************************************//

extension FormFourViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let model = PhotoCellModel(photo: editedImage, status: .approved, type: self.currentPhotoType)
            self.uploadedPhotosData.append(model)
            self.allPhotosData.append(model)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let model = PhotoCellModel(photo: originalImage, status: .approved, type: self.currentPhotoType)
            self.uploadedPhotosData.append(model)
            self.allPhotosData.append(model)
        }
        self.collectionView.reloadData()
        self.dismiss(animated: true, completion: nil)
    }
}

  //**************************************************************//
 // MARK: - UICollectionViewDelegate, UICollectionViewDataSource //
//**************************************************************//

extension FormFourViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.allPhotosData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: DocumentsPhotoCollectionViewCell.reuseIdentifier, for: indexPath)
        let model = self.allPhotosData[indexPath.row]
        (cell as? DocumentsPhotoCollectionViewCell)?
            .initView(photoImage: model.photo, status: model.status, type: model.type)
        return cell
    }
}
