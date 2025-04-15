//
//  FavouriteCell.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/31/25.
//

// 1. 구굴링을 한다 - 스택오브플로우로, 깃 이슈
// 2. 바로 코드 복붙 해보고
// 3. 문서 - 레퍼런스 확인 - 체크



import Foundation
import UIKit

import Kingfisher

class FavouriteCell: UICollectionViewCell {
    
    // MARK: - Properfies
    
    @IBOutlet var favoruiteImageView: UIImageView!
    
    // MARK: - Initalization
    
    override class func awakeFromNib() {
        super.awakeFromNib()
        print(#file, #function, #line, "")
    }
    
    // MARK: - Public Methods
    
    func updateFavoruiteImage(cellData: AllFavoriteResponse) {
        // 링크: https://swiftpackageindex.com/onevcat/kingfisher/master/documentation/kingfisher/imagetransition/fade(_:)
        let url: URL? = URL(string: cellData.image.url ?? "")
        self.favoruiteImageView.kf.setImage(with: url)
    }
    
    
}
