//
//  DocumentsPhotoCollectionViewCell.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 8/6/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class DocumentsPhotoCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Constants
    
    static let reuseIdentifier = "DocumentsPhotoCollectionViewCell"
    
    // MARK: - Outlets
    
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var statusImageView: UIImageView!
    @IBOutlet weak var typeLabel: UILabel!
    
    // MARKL - Initialization
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func initView(with model: PhotoCellModel) {
        self.photoImageView.image = model.photo
        self.statusImageView.image = self.setStatusImage(status: model.status)
        self.typeLabel.text = model.typeText
    }
    
    // MARK: - Setters
    
    private func setStatusImage(status: RequestState) -> UIImage {
        var imageName = ""
        switch status {
        case .approved:
            imageName = "statusApproved"
            break
        case .uploaded:
            imageName = "statusRevision2"
            break
        default:
            break
        }
        
        guard let statusImage = UIImage(named: imageName) else { return UIImage()}
        return statusImage
    }
}


//$(DEVELOPMENT_LANGUAGE)
