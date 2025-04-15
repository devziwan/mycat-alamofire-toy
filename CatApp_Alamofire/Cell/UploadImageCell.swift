//
//  UploadImageCell.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/20/25.
//

import Foundation
import UIKit
    
class UploadImageCell: UICollectionViewCell {
    
    // MARK: - IBOutlets
    
    @IBOutlet var checkOverlayView: UIView! // 체크 반투명 배경
    @IBOutlet var uploadImageView: UIImageView! // 업로드 이미지
    @IBOutlet var checkIconImageView: UIImageView! // 체크 아이콘 이미지
    
    // MARK: - Initalization
    
    override func awakeFromNib() {
        super.awakeFromNib()
        print(#file, #function, #line, "")
        
        checkIconImageView.isHidden = true
        checkOverlayView.isHidden = true
        
        setupCheckIcon()
    }
    
    // MARK: - Public Methods
    
    func configureSelectImage(isSelectHidden: Bool) {
        self.checkIconImageView.isHidden = isSelectHidden
        self.checkOverlayView.isHidden = isSelectHidden
    }

    // MARK: - Private Methods
    
    /// 이미지 선택 아이콘  레이아웃 설정
    /// 체크 아이콘 레이아웃 설정/
    fileprivate func setupCheckIcon() {
        self.checkIconImageView.layer.cornerRadius = 15
        self.checkIconImageView.layer.masksToBounds = true
        self.checkIconImageView.layer.borderColor = UIColor.white.cgColor
        self.checkIconImageView.layer.borderWidth = 2.0
    }
    
}
