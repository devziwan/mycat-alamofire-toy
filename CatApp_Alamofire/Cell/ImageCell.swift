//
//  ImageCell.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/12/25.
//

import Foundation
import UIKit

class ImageCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var catImageView: UIImageView!
    
    // MARK: - Initalization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#file, #function, #line, "")
    }
    
}
