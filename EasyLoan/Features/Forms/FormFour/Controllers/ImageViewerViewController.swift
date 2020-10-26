//
//  ImageViewerViewController.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/15/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit
import SwiftEntryKit

class ImageViewerViewController: UIViewController {

    // MARK: - Public Variables
    
    var imageWasDeletedHandler: ((String) -> Void)?
    var deleteButtonEnabled: Bool = true
    
    // MARK: - Private Variables
    
    private var model: PhotoCellModel?
    
    // MARK: - Instantiate
    
    static func instantiate(with model: PhotoCellModel) -> ImageViewerViewController {
        let storyboard = UIStoryboard(name: "FormFour", bundle: nil)
        guard let controller = storyboard
            .instantiateViewController(withIdentifier: "ImageViewer") as? ImageViewerViewController
            else { return ImageViewerViewController()}
        controller.model = model
        return controller
    }
    
    // MARK: - Outlets
    
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            self.imageView.image = self.model?.photo
        }
    }
    
    // MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupNavigationBar()
    }
    
    // MARK: - Actions
    
    @objc private func deleteBarButtonTapped() {
        self.showDeleteAlert()
    }
    
    // MARK: - Networking
    
    private func deleteImage() {
        guard let id = self.model?.fileId else {
            self.navigationController?.popViewController(animated: true)
            print("pop with nil")
            return
        }
        Network.shared.delete(
            url: URLPath.file + id,
            success: { [weak self] in
                guard let self = self else { return }
                self.imageWasDeletedHandler?(id)
                self.navigationController?.popViewController(animated: true)
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Setters
    
    private func setupNavigationBar() {
        self.navigationItem.title = self.model?.typeText
        if self.deleteButtonEnabled {
            let deleteButton = UIBarButtonItem(
                barButtonSystemItem: .trash, target: self,
                action: #selector(self.deleteBarButtonTapped))
            self.navigationItem.rightBarButtonItem = deleteButton
        }
    }
    
    // MARK: - Aletrt
    
    private func showDeleteAlert() {
        let alertView = DeleteAlertView()
        alertView.messageKey = "DO_YOU_WANT_DELETE_DOCUMENT".localized()
        alertView.yesButtonTappedHendler = { [weak self] in
            guard let self = self else { return }
            self.deleteImage()
            SwiftEntryKit.dismiss()
        }
        SwiftEntryKit.display(entry: alertView,
                              using: EKAttributes.setupAttributes(statusBar: .light))
    }
    
}
