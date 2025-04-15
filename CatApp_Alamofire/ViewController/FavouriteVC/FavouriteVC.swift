//
//  FavouriteVC.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/31/25.
//

import Foundation
import UIKit

class FavouriteVC: UIViewController {
    
    @IBOutlet var favouriteCollectionView: UICollectionView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function, #line, "-🌱 즐겨찾기 뷰컨")
        
        self.navigationItem.title = "즐겨찾기"
        
        // 컬렉션뷰 Cell 등록 설정
        let nibName = UINib(nibName: "FavouriteCell", bundle: nil)
        self.favouriteCollectionView.register(nibName, forCellWithReuseIdentifier: "FavouriteCell")
        
        // 컬렉션뷰 Delegate 및 DataSource 설정
        self.favouriteCollectionView.delegate = self
        self.favouriteCollectionView.dataSource = self
        self.favouriteCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        CatImageVM.shared.fetchAllFavourites()
        
        updataEmptyFavouriteView()
        
        CatImageVM.shared.onCatImageFavouriteReload = {
            DispatchQueue.main.async {
                self.favouriteCollectionView.reloadData()
                self.updataEmptyFavouriteView()
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#file, #function, #line, "")
        
        CatImageVM.shared.fetchAllFavourites()
    }
    
    
    
    // MARK: - Private Methods
    
    /// 즐겨찾기 목록이 비어있다면 안내 문구 표시해준다.
    fileprivate func updataEmptyFavouriteView() {
        if CatImageVM.shared.favoriteList.isEmpty {
            let label = UILabel()
            label.text = "내가 좋아하는 고양이를\n 즐겨찾기 해보세요."
            label.font = .boldSystemFont(ofSize: 21)
            label.numberOfLines = 2
            label.textAlignment = .center
            favouriteCollectionView.backgroundView = label
        } else {
            favouriteCollectionView.backgroundView = nil
        }
    }
    
} // FavouriteVC

// MARK: - UICollectionViewDelegate

extension FavouriteVC: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#file, #function, #line, "상세페이지로 이동")
        
        let stroyboard: UIStoryboard = UIStoryboard(name: "DetailPageVC", bundle: nil)
        guard let detailPageVC: DetailPageVC = stroyboard.instantiateViewController(withIdentifier: "DetailPageVC") as? DetailPageVC else {
            return
        }
    
        let selectedImageURL: String = CatImageVM.shared.favoriteList[indexPath.item].image.url ?? ""
        let selectedImageID: String = CatImageVM.shared.favoriteList[indexPath.item].image.id ?? ""
        let favouriteID: Int = CatImageVM.shared.favoriteList[indexPath.item].id ?? 0
        
        detailPageVC.imageURL = selectedImageURL
        detailPageVC.imageID = selectedImageID
        detailPageVC.favoriteID = favouriteID
     
        self.navigationController?.pushViewController(detailPageVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource

extension FavouriteVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CatImageVM.shared.favoriteList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: FavouriteCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteCell", for: indexPath) as? FavouriteCell else {
            return UICollectionViewCell()
        }
        
        let cellData: AllFavoriteResponse = CatImageVM.shared.favoriteList[indexPath.row]
        
        // 즐겨찾기 한 고양이 이미지 보여준다.
        cell.updateFavoruiteImage(cellData: cellData)

//        // 즐겨찾기 한 고양이 이미지 보여준다.
//        if let imageURL = CatImageVM.shared.uploadImageList[indexPath.row].url {
//            let url = URL(string: imageURL)
//            cell.favoruiteImageView.kf.setImage(with: url)
//            cell.updateFavoruiteImage(imageURL: imageURL)
//
//        }
        return cell
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FavouriteVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return  UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width / 3) - 1.0
        return CGSize(width: width, height: width)
    }
    
    // 위 아래 간격
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
         return 1
     }

     // 옆 간격
     func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
         return 1
     }
   
    
}
