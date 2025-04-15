//
//  UploadVC.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/19/25.
//

import Foundation
import UIKit

class UploadVC: UIViewController {
    
    // MARK: - Preporfies
    
    let picker = UIImagePickerController()
        
    // MARK: - Lifecycles Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function, #line, "- 🌱 업로드 뷰컨트롤러")
        picker.delegate = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#file, #function, #line, "")
        
        self.picker.sourceType = .photoLibrary
        self.picker.modalTransitionStyle = .coverVertical
        self.picker.modalPresentationStyle = .fullScreen
        
        self.present(self.picker, animated: true)
    }
    
    
} // UploadVC

// MARK: - Private Methods

/// 이미지를 JPEG 데이터로 변환 하고 업로드 한다.
/// - Parameter selectedImage: 선택할 이미지
fileprivate func convertImageToJPEGAndUpload(_ selectedImage: UIImage) {
    
    if let imageData: Data = selectedImage.jpegData(compressionQuality: 1.0) {
        print(#file, #function, #line, "-✅ 선택한 이미지 JPEG 변환 성공")
        
        CatImageVM.shared.uploadCatImage(image: imageData)
        NotificationCenter.default.post(name: .uploadDidSuccess, object: nil)
        
    } else {
        print(#file, #function, #line, "- 💣 이미지 데이터 변환 실패")
    }
    
}

// MARK: - UINavigationControllerDelegate & UIImagePickerControllerDelegate

extension UploadVC: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        print(#file, #function, #line, "이미지 선택을 했습니다.")
        
        if let selectedImage: UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print(#file, #function, #line, "- 선택된 이미지: \(selectedImage)")
            
            convertImageToJPEGAndUpload(selectedImage)
        } else {
            print(#file, #function, #line, "- 선택된 이미지 nil 입니다.")
        }
        
        // 이미지 선택후에 탭바 2인덱스 위치로 이동한다.
        tabBarController?.selectedIndex = 2
        
        // 이미지를 선택하면 Piker가 닫힌다.
        self.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#file, #function, #line, "- 이미지 취소 했습니다.")
        tabBarController?.selectedIndex = 2
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    
}


