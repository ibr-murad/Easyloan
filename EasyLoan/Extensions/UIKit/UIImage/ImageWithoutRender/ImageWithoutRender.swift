//
//  ImageWithoutRender.swift
//  EasyLoan
//
//  Created by Murad Ibrohimov on 9/11/20.
//  Copyright © 2020 Murad Ibrohimov. All rights reserved.
//

import UIKit

class ImageWithoutRender: UIImage {
    override func withRenderingMode(_ renderingMode: UIImage.RenderingMode) -> UIImage {
        return self
    }
}
