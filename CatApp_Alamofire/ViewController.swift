//
//  ViewController.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/11/25.
//

import UIKit

import Kingfisher

class ViewController: UIViewController {
    
    // MARK: - IBOutlet
    
    @IBOutlet var myCollectionView: UICollectionView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function, #line, "🌱")
        
        // 컬렉션뷰 DataSource 및 Delgate 연결
        self.myCollectionView.delegate = self
        self.myCollectionView.dataSource = self
        self.myCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        // 컬렉션뷰 Cell 등록 설정
        let nibName: UINib = UINib(nibName: "ImageCell", bundle: nil)
        self.myCollectionView.register(nibName, forCellWithReuseIdentifier: "ImageCell")
        
        CatImageVM.shared.onCatImageUpdate = {
            print("onCatImageUpdate 실행됨 ✅")
            DispatchQueue.main.async {
                self.myCollectionView.reloadData()
            }
        }
        
    }

} // ViewController

// MARK: - UICollectionViewDelegate

extension ViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#file, #function, #line, "- 상세페이지 화면 이동")
        
        let storyboard: UIStoryboard = UIStoryboard(name: "DetailPageVC", bundle: nil)
        guard let detailPageVC: DetailPageVC = storyboard.instantiateViewController(withIdentifier: "DetailPageVC") as? DetailPageVC else {
            return
        }
                
        let selectedImageURL: String = CatImageVM.shared.catImageList[indexPath.item].url ?? ""
        print(#file, #function, #line, "- 선택된 이미지 URL: \(selectedImageURL)")
        
        let selectedImageID: String = CatImageVM.shared.catImageList[indexPath.item].id ?? ""
        print(#file, #function, #line, "- 선택된 이미지 ID: \(selectedImageID)")
        
        let favoriteID: Int? = CatImageVM.shared.favoriteList.first(where: { $0.imageID == selectedImageID })?.id
     
        detailPageVC.imageURL = selectedImageURL
        detailPageVC.imageID = selectedImageID
        detailPageVC.favoriteID = favoriteID
        
        self.navigationController?.pushViewController(detailPageVC, animated: true)
    }
    
}

// MARK: - UICollectionViewDataSource

extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CatImageVM.shared.catImageList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell: ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else {
            return UICollectionViewCell()
        }
        
        if let imageURL: String = CatImageVM.shared.catImageList[indexPath.row].url {
            let url = URL(string: imageURL)
            cell.catImageView.kf.setImage(with: url)
        }

        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
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

// MARK: - UIScrollViewDelegate

extension ViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY: CGFloat = scrollView.contentOffset.y // 현재 위치
        let contentSize: CGFloat = scrollView.contentSize.height //
        let scrollViewSize: CGFloat = scrollView.frame.size.height // 스크롤 높이 값
        
        if offsetY > (contentSize - scrollViewSize) {
            print(#file, #function, #line, "☑️ 스크롤 하단 찍힘!")
            
            // 스크롤 하단에 닿으면 고양이 이미지 6개 가져오기
            CatImageVM.shared.fatchCatImage(imageLimit: 6)
        }
    }
    
}

