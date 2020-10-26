//
//  FormFourViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 7/27/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import AVFoundation
import DropDown
import Alamofire

class FormFourViewController: FormsBaseViewController {
    
    // MARK: - Public Variables
    
    var isRevision: Bool = false {
        didSet {
            if self.isRevision {
                self.view.isUserInteractionEnabled = true
            }
        }
    }
    override var requestFull: RequestFullViewModel? {
        didSet {
            self.loadImages()
        }
    }
    
    // MARK: - Private Variables
    
    private var allPhotosData: [PhotoCellModel] = []
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
            self.dismiss(animated: true, completion: { [weak self] in
                self?.showImagePickerController(sourceType: .photoLibrary)
            })
        }
    }
    
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        let controller = DocumetsTypePopoverController.instantiate()
        self.presentPopoverViewController(controller: controller,
                                          sourceView: self.view,
                                          size: CGSize(width: 300, height: 300),
                                          minusY: 70, arrowDirection: UIPopoverArrowDirection(rawValue: 0))
        controller.selectedDocumentValueHendler = { [weak self] type in
            guard let self = self else { return }
            self.currentPhotoType = type
            self.dismiss(animated: true, completion: { [weak self] in
                self?.showImagePickerController(sourceType: .camera)
            })
        }
    }
    
    @IBAction func continueButtonTapped(_ sender: Any) {
        self.continueButtonTappedHandler?()
    }
    
    
    // MARK: - Networking
    
    private func loadImages() {
        guard let request = self.requestFull else { return }
        self.allPhotosData = []
        let group = DispatchGroup()
        for (key, value) in request.files {
            group.enter()
            Network.shared.downloadImage(fileId: key) { [weak self] (image) in
                guard let self = self else { return }
                self.allPhotosData.append(PhotoCellModel(photo: image, status: .approved, type: value, fileId: key))
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
    
    private func uploadImage(_ item: PhotoCellModel) {
        if let id = self.createdRequestId {
            var localItem = item
            Network.shared.uploadImage(
                id: id, type: item.type, image: item.photo,
                success: { [weak self] (data: PhotoModel) in
                    guard let self = self else { return }
                    localItem.status = .approved
                    localItem.fileId = "\(data.id)"
                    self.allPhotosData.removeLast()
                    self.allPhotosData.append(localItem)
                    self.collectionView.reloadData()
                    if self.allPhotosData.count >= 2 {
                        self.isFormFullHandler?(true)
                    } else {
                        self.isFormFullHandler?(false)
                    }
                    self.completionHendler?(id, self.mIncome)
            }) { (error, code) in
                self.allPhotosData.removeLast()
                self.alertError(message: error.msg)
            }
        }
    }
    
    // MARK: - Setters
    
    private func setDelegates() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    private func makeSubviewsEnabled(value: Bool) {
        for subview in self.view.subviews {
            if subview === self.collectionView {
                subview.isUserInteractionEnabled = true
            } else {
                subview.isUserInteractionEnabled = value
            }
        }
    }
    
    private func setIsEditable() {
        if self.isEditable {
            self.makeSubviewsEnabled(value: true)
        } else {
            if self.isRevision {
                self.makeSubviewsEnabled(value: true)
            } else {
                self.makeSubviewsEnabled(value: false)
            }
        }
    }
}

  //*****************************************//
 // MARK: - UIImagePickerControllerDelegate //
//*****************************************//

extension FormFourViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func showImagePickerController(sourceType: UIImagePickerController.SourceType) {
        
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = sourceType
            self.present(imagePickerController, animated: true, completion: nil)
            break
        default:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] (granted) in
                print(granted)
                if granted {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.delegate = self
                    imagePickerController.allowsEditing = true
                    imagePickerController.sourceType = sourceType
                    self?.present(imagePickerController, animated: true, completion: nil)
                }
            }
            break
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            let model = PhotoCellModel(photo: editedImage, status: .uploaded, type: self.currentPhotoType, fileId: nil)
            self.allPhotosData.append(model)
            self.uploadImage(model)
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            let model = PhotoCellModel(photo: originalImage, status: .uploaded, type: self.currentPhotoType, fileId: nil)
            self.allPhotosData.append(model)
            self.uploadImage(model)
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
        (cell as? DocumentsPhotoCollectionViewCell)?.initView(with: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.allPhotosData[indexPath.row]
        let controller = ImageViewerViewController.instantiate(with: model)
        if self.isEditable {
            controller.deleteButtonEnabled = true
        } else {
            controller.deleteButtonEnabled = false
        }
    
        controller.imageWasDeletedHandler = { [weak self] id in
            guard let self = self else { return }
            self.allPhotosData = self.allPhotosData.filter({$0.fileId != id})
            self.collectionView.reloadData()
            
            if let id = self.createdRequestId {
                self.isFormFullHandler?(self.allPhotosData.count >= 2)
                self.completionHendler?(id, self.mIncome)
            }
        }
        self.navigationController?.pushViewController(controller, animated: true)
    }
}
