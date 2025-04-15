//
//  DetailPageVC.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/26/25.
//

import Foundation
import UIKit

import Kingfisher
import Toast

class DetailPageVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var detailImageView: UIImageView! // 상세이미지
    @IBOutlet var favoriteButton: UIButton! // 즐겨찾기 버튼
    
    // MARK: - Properties
    
    var imageURL: String?
    var imageID: String?
    var favoriteID: Int?
    var isFavorite: Bool = false
    
    var tabBarHeghtSize: CGFloat = 0.0
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function, #line, "-🌱 상세페이지 화면")
        
        self.tabBarController?.tabBar.isHidden = true
        
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationItem.title = "상세 페이지"
        
        let url: URL? = URL(string: imageURL ?? "")
        self.detailImageView.kf.setImage(with: url)
        
        tabBarHeghtSize = TabBarController.sheard.tabBarHeght
    
        if let favouriteInfo = CatImageVM.shared.favoriteList.first(where: { $0.imageID == imageID }) {
            isFavorite = true
        } else {
            isFavorite = false
        }
        
        updateFavoriteButton()
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#file, #function, #line, "")
        
        self.tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Private Methods
    
//    private func makeToastAlertView() -> UIStackView{
//        
//    }
    
    /// 즐겨찾기 버튼 눌렀을 때 UI 업데이트 된다.
    fileprivate func updateFavoriteButton() {
        let imageName: String = isFavorite ? "heart.fill" : "heart"
        favoriteButton.setImage(UIImage(systemName: imageName), for: .normal)
    }
    
    /// 토스트 얼럿뷰 등장 합니다.
    fileprivate func showToastAlertView() {
        
        // 디바이스 높이
        let diviceSize: CGRect = UIScreen.main.bounds

        let diviceWdith: CGFloat = diviceSize.width - 20

        let stackView = UIStackView(frame: CGRect(x: 0.0, y: 0.0, width: diviceWdith , height: 40))
        stackView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]
        stackView.backgroundColor = .darkGray
        stackView.layer.cornerRadius = 8
        
        let customToastAlertLabel = UILabel()
        customToastAlertLabel.text = "관심목록에 추가했어요."
        customToastAlertLabel.font = UIFont.systemFont(ofSize: 16)
        customToastAlertLabel.textColor = .white
        
        let customToastAlertButton = UIButton()
        customToastAlertButton.setTitle("관심목록 보기", for: .normal)
        customToastAlertButton.setTitleColor(.accent, for: .normal)
        customToastAlertButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        
        stackView.addArrangedSubview(customToastAlertLabel)
        stackView.addArrangedSubview(customToastAlertButton)
        
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 20)
        
        let diviceHeght = diviceSize.height// 디바이스 높이 값
        let safeBottom = view.safeAreaInsets.bottom // safeArea 바텀
        print(#file, #function, #line, "- divisHeght: \(diviceHeght), safeBottom: \(safeBottom)")
        let toastY = (diviceHeght - tabBarHeghtSize - safeBottom) - 30
        let toastX = UIScreen.main.bounds.width / 2
      
        print(#file, #function, #line, "- toastY: \(toastY)")
        print(#file, #function, #line, "- toastX: \(toastX)")
        
        self.navigationController?.view.showToast(stackView, duration: 3.0, point: CGPoint(x: toastX, y: toastY))
        
        customToastAlertButton.addTarget(self, action: #selector(goToFavoriteView), for: .touchUpInside)
    }
    
    // FIXME: 함수명 다시 생각해보기!!
    /// 즐겨찾기 화면으로 이동 합니다.
    @objc fileprivate func goToFavoriteView() {
        self.navigationController?.popViewController(animated: true)
        
        NotificationCenter.default.post(name: .goToFavoriteList, object: nil, userInfo: nil)
    }

    // MARK: - IBAction Methods
    
    @IBAction func favoriteButtonPassed(_ sender: UIButton) {
        print(#file, #function, #line, "- 상세페이지 즐겨찾기 버튼 눌음")
        isFavorite.toggle()

        switch isFavorite {
        case true:
            print(#file, #function, #line, "즐겨찾기 등록 버튼 눌음: \(String(describing: imageID))")
            updateFavoriteButton()
            showToastAlertView()
            
            CatImageVM.shared.createFavouriteCatImage(imageID: imageID ?? "")
            
            print(#file, #function, #line, "현재 favouriteList:\(CatImageVM.shared.favoriteList)")
            
        case false:
            print(#file, #function, #line, "즐겨찾기 해제 버튼 눌음: \(String(describing: favoriteID))")
            updateFavoriteButton()
            
            let deleteFavouriteID: Int? = CatImageVM.shared.favoriteList.first(where: {
                $0.imageID == imageID
            })?.id
            
            CatImageVM.shared.deleteFavoriteCatImage(imageID: deleteFavouriteID ?? 0)
        }
        
    }
    
} // DetailPageVC


