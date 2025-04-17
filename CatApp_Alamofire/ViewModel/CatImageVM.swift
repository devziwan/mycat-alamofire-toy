//
//  CatImageVM.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/13/25.
//

import Foundation

import Toast

class CatImageVM: ObservableObject {
    
    // MARK: - Properties
    
    static let shared : CatImageVM = CatImageVM()

    var catImageList: [CatImageResponse] = []
    var uploadImageList: [UploadCatImage] = []
    var favoriteList: [AllFavoriteResponse] = []
    
    var onCatImageUpdate: (() -> Void)? = nil
    var onCatImageUpload: (() -> Void)? = nil
    var onCatImageFavouriteReload: (() -> Void)? = nil
    
    // MARK: - init Method
    
    init() {
        self.fatchCatImage(imageLimit: 20) 
        self.fetchAllFavourites()
        self.fatchUploadCatImage()
    }
    
    // MARK: - Public Methods
    
    /// 고양이 이미지를 가져옵니다.
    /// - Parameter imageLimit: 고양이 이미지 최대 요청 수를 제한합니다.
    func fatchCatImage(imageLimit: Int) {
        CatImagesAPI.fatchCatImage(imageLimit: imageLimit ,completion: { result in
            
            switch result {
            case.success(let catImages):
                print(#file, #function, #line, "- 고양이 이미지 가져오기 성공:")
                self.catImageList.append(contentsOf: catImages)
                
                self.onCatImageUpdate?()
            case .failure(let error):
                print(#file, #function, #line, "고양이 이미지 가져오기: \(error)")
            }
        })
    }

    /// 고양이 이미지를 업로드합니다.
    /// - Parameter image: 등록할 고양이 이미지 데이터
    func uploadCatImage(image: Data) {
        CatImagesAPI.uploadCatImage(selected: image, completion: { result in
            
            switch result {
            case.success(let uploadImage):
                print(#file, #function, #line, "- 이미지 업로드 성공:")
                
                self.fatchUploadCatImage()
//                self.uploadImageList.append(uploadImage)
                print("- ☑️ 이미지 업로드 리스트 증가: \(self.uploadImageList.count)")
                
//                guard let onCatImageUpLoad = self.onCatImageUpload else {
//                    print(#file, #function, #line, "- onCatImageUpLoad is nil")
//                    return
//                }
//                
//                onCatImageUpLoad()
            case.failure(let error):
                print(#file, #function, #line, "- 이미지 업로드 실패: \(error)")
            }
        })
    }
    
    /// 업로드 했던 고양이 이미지를 조회 합니다.
    func fatchUploadCatImage() {
        CatImagesAPI.fatchUploadCatImage(imageLimit: 100, completion: { result in
            
            switch result {
            case.success(let uploadImages):
                print(#file, #function, #line, "- 이미지 업로드 조회 성공: \(uploadImages)")
                self.uploadImageList = uploadImages
                
                guard let onCatImageUpLoad = self.onCatImageUpload else {
                    print(#file, #function, #line, "- onCatImageUpLoad is nil")
                    return
                }
                
                onCatImageUpLoad()
            case .failure(_):
                print(#file, #function, #line, "- 이미지 업로드 조회 실패:")
            }
            
        })
    }
    
    /// 업로드 목록에서 고양이 이미지를  삭제합니다.
    /// - Parameter imageID: 삭제하고 싶은 고양이 이미지 ID
    func deleteUploadCatImage(imageID: String) {
        CatImagesAPI.deleteUploadCatImage(imageID: imageID, completion: { result in
            
            switch result {
            case .success(let deletedFavorites):
                print(#file, #function, #line, "- 이미지 업로드 삭제 성공: \(deletedFavorites)")
                self.fatchUploadCatImage()
            case .failure(_):
                print(#file, #function, #line, "- 이미지 업로드 삭제 실패:")
            }
            
        })
    }
    
    /// 업로드 목록에서 선택된 고양이 이미지들을  삭제합니다.
    /// - Parameter imageIDs: 삭제할 이미지들의  ID 목록
    func deleteUploadCatImages(imageIDs: [String]) {
        for id in imageIDs {
            deleteUploadCatImage(imageID: id)
        }
    }
    
    /// 고양이 이미지를 즐겨찾기로 등록합니다.
    /// - Parameter imageID: 등록한 즐겨찾기 고양이 이미지 ID
    func createFavouriteCatImage(imageID: String) {
        CatImagesAPI.createFavoriteCatImage(imageID: imageID, completion: { result in
            
            switch result {
            case .success(let favoriteImage):
                print(#file, #function, #line, "- 즐겨찾기 성공 했습니다: \(favoriteImage)")
                self.fetchAllFavourites()
                
            case .failure(let error):
                print(#file, #function, #line, "- 즐겨찾기 실패 했습니다: \(error) ")
            }
        })
    }
    
    /// 고양이 이미지를 즐겨찾기 했던 것을 전체 조회합니다.
    func fetchAllFavourites() {
        CatImagesAPI.fatchFavoritesCatImages(completion: { result in
            
            switch result {
            case .success(let fatchFavorites):
                print(#file, #function, #line, "- 즐겨찾기 전체 조회 성공")
                self.favoriteList = fatchFavorites

                self.onCatImageFavouriteReload?()
                
            case .failure(_):
                print(#file, #function, #line, "- 즐겨찾기 전체 조회 실패")
            }
        })
    }
    
    /// 고양이 이미지를 즐겨찾기 했던 목록에서 삭제합니다.
    /// - Parameter imageID: 삭제할 고양이  이미지 ID
    func deleteFavoriteCatImage(imageID: Int) {
        CatImagesAPI.deleteFavoriteCatImage(imageID: imageID, completion: { result in
            
            switch result {
            case .success(let deletedFavorites):
                print(#file, #function, #line, "- 즐겨찾기 삭제 성공: \(deletedFavorites)")
                
            case .failure(_):
                print(#file, #function, #line, "- 즐겨찾기 삭제 실패:")
            }
        })
    }
    
} // CatImageVM



