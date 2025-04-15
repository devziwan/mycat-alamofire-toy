//
//  UploadPhotosVC.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/19/25.
//

import Foundation
import UIKit

import Kingfisher
import Toast
import Loaf


class UploadPhotosVC: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet var uploadImageCollectionView: UICollectionView!
    @IBOutlet var toobar: UIToolbar!
    @IBOutlet var editButton: UIButton!
    @IBOutlet var trashButton: UIBarButtonItem!
    
    // MARK: - Properfies
    
    var deleteUploadImage: [IndexPath] = []
    var isEditingMode: Bool = true // 편집 모드 플래그
    var onSelectHidden: (() -> Void)? = nil
    
    var selectedImageID: String?
    var selectedImageIDList: [String] = []
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#file, #function, #line, "")
        
        setEditing(false, animated: false) // 편집 모드 OFF모드
        
        let nibName: UINib = UINib(nibName: "UploadImageCell", bundle: nil)
        self.uploadImageCollectionView.register(nibName, forCellWithReuseIdentifier: "UploadImageCell")
        
        self.uploadImageCollectionView.delegate = self
        self.uploadImageCollectionView.dataSource = self
        self.uploadImageCollectionView.collectionViewLayout = UICollectionViewFlowLayout()
        
        self.navigationItem.title = "내 업로드한 이미지"
        
        NotificationCenter.default.addObserver(self, selector: #selector(showUploadActivityToast), name: .uploadDidSuccess, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUploadActivityToast), name: .uploadSuccessToastEvenet, object: nil)
      
        
        // 컬렉션뷰 다중 선택 설정
        uploadImageCollectionView.allowsMultipleSelection = true
        uploadImageCollectionView.allowsFocus = true
        
        // 휴지통 설정
        trashButton.isEnabled = false
        
        updateEmptyUploadView(tag: 1)
        
        CatImageVM.shared.onCatImageUpload = {
            DispatchQueue.main.async {
                self.uploadImageCollectionView.reloadData()
                self.updateEmptyUploadView(tag: 1)
            }
        }
        
      
        updateTrashButton()
    } // viewDidLoad
    
    // MARK: - SetEditing Method
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        isEditingMode = editing

        switch isEditingMode {
        case true:
            print(#file, #function, #line, "- 편집모드 ON")
            
            self.toobar.isHidden = false
            self.tabBarController?.tabBar.isHidden = true
            
        case false:
            print(#file, #function, #line, "- 편집모드 OFF")
            self.trashButton.isEnabled = false
            self.toobar.isHidden = true
            self.tabBarController?.tabBar.isHidden = false
            
            self.selectCellToCheckIconHidden()
        }
    }
    
    // MARK: - Prvite Methods
    
    /// 편집모드 상태에 따라 버튼 텍스트가 '선택' 또는 '취소' 변경됩니다.
    fileprivate func updateEditButtonTitle() {
        // 편집모드 ON 모드
        if isEditingMode == true {
            self.editButton.setTitle("취소", for: .normal)
            return
        }
        
        // 편집모드 OFF 모드
        if isEditingMode == false {
            self.editButton.setTitle("선택", for: .normal)
            return
        }
    }
    
    /// 업로드 화면 목록이 비어있다면 안내 문구를 표시해준다
    fileprivate func updateEmptyUploadView(tag: Int = 1) {
        if CatImageVM.shared.uploadImageList.isEmpty {
            
            let iconImage = UIImageView()
            iconImage.image = UIImage(named: "Image 1")
//            iconImage.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
            
            
            // 타이틀 라벨
            let titleLabel = UILabel()
            titleLabel.text = "내 고양이 사진을 올려보세요."
            titleLabel.font = .boldSystemFont(ofSize: 21)
            titleLabel.textAlignment = .center
            
            // 라벨
            let label = UILabel()
            label.text = "현재 등록한 이미지가 없습니다."
            label.textAlignment = .center
            label.textColor = .gray
            
            // 버튼
            let button = UIButton()
            button.setTitle("이미지 등록하기", for: .normal)
            button.setTitleColor(.accent, for: .normal)
            
            button.layer.frame = CGRect(x: 0, y: 0, width: 100, height: 50)
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.systemGray.cgColor
            button.layer.cornerRadius = 8
            button.translatesAutoresizingMaskIntoConstraints = false
            // iOS 15버전
            button.contentEdgeInsets = UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
            
            button.addTarget(self, action: #selector(moveUploadVC), for: .touchUpInside)
            
            // t
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .center
            stackView.distribution = .fill
            stackView.spacing = 10
            stackView.tag = tag
            
            stackView.addArrangedSubview(iconImage)
            stackView.addArrangedSubview(titleLabel)
            stackView.addArrangedSubview(label)
            stackView.addArrangedSubview(button)
            
            uploadImageCollectionView.addSubview(stackView)
            
         
            // 스택뷰가 가운데에 오도록 제약조건 설정
            NSLayoutConstraint.activate([
                stackView.centerXAnchor.constraint(equalTo: uploadImageCollectionView.centerXAnchor),
                stackView.centerYAnchor.constraint(equalTo: uploadImageCollectionView.centerYAnchor)
            ])
        } else {
            uploadImageCollectionView.viewWithTag(tag)?.removeFromSuperview()
        }
    }
    
    /// 선택했던 셀이 0개 이면 휴지통 버튼은 비활성화 하고, 1개 이상 선택 했다면 활성화가 됩니다.
    fileprivate func updateTrashButton() {
        if let selectedItems: [IndexPath] = self.uploadImageCollectionView.indexPathsForSelectedItems {
            print(#file, #function, #line, "- 선택된 셀: \(selectedItems.count)개")
            
            if selectedItems.count == 0 {
                self.trashButton.isEnabled = false
                print(#file, #function, #line, "휴지통 비활성화")
            }
        }
        
    }
    
    /// 선택한 셀에 체크 아이콘 가려준다.
    fileprivate func selectCellToCheckIconHidden() {
        if let selectedIndexPaths: [IndexPath] = uploadImageCollectionView.indexPathsForSelectedItems {

            for indexPath in selectedIndexPaths {
                uploadImageCollectionView.deselectItem(at: indexPath, animated: true)
                let cell = uploadImageCollectionView.cellForItem(at: indexPath) as? UploadImageCell
                cell?.configureSelectImage(isSelectHidden: true)
            }
            
        }
    }
    
    /// 이미지 업로드 요청하는 동안 액티비티 토스트가 계속 나타난다.
    @objc fileprivate func showUploadActivityToast(_ sender: Notification) {
        uploadImageCollectionView.viewWithTag(1)?.removeFromSuperview()
        
        var toastStyle = ToastStyle()
        toastStyle.activityBackgroundColor = .clear
        toastStyle.activityIndicatorColor = .accent
        ToastManager.shared.style = toastStyle
        
        self.view.makeToastActivity(.center)
    }
    
    /// 이미지 업로드 응답을 받으면 액티비티 토스트 가 사라진다.
    @objc fileprivate func didUploadActivityToast(_ sender: Notification) {
        DispatchQueue.main.async() {
            self.view.hideToastActivity()
        }
    }
    
    /// 업로드 화면으로 이동합니다.
    @objc fileprivate func moveUploadVC() {
        
        self.tabBarController?.selectedIndex = 1
    }
    
    // MARK: - IBActhon Methods
    
    /// 편집모드 버튼 눌렀을 때  동작처리 합니다.
    /// 편집모드 상태에 따라 버튼 타이틀이 '선택' 또는 '취소'로 변경됩니다.
    @IBAction func editButtonPressed(_ sender: UIButton) {
        print(#file, #function, #line, "- 편집모드 버튼 눌음")
        setEditing(!isEditing, animated: true)
        
        updateEditButtonTitle()
    }
    
    /// 휴지통 버튼을 눌렀을 때 동적처리 합니다.
    /// 버튼을 누르면 삭제할 수 있는 얼럿이 나옵니다. 삭제 버튼을 누르면 이미지 삭제가 됩니다.
    /// 삭제가 완료 될 경우 편집모드를 해제하고 업로드 화면을 업데이트 합니다.
    @IBAction func trashButtonPressed(_ sender: UIButton) {
        updateTrashButton()
        
        if let selectedItems: [IndexPath] = self.uploadImageCollectionView.indexPathsForSelectedItems {
            
            let actionSheet: UIAlertController = UIAlertController(title: "선택한 사진은 영구 삭제됩니다.", message: nil, preferredStyle: .actionSheet)
            
            let deletedAction: UIAlertAction = UIAlertAction(title: "\(selectedItems.count)장의 사진 삭제", style: .destructive) { (action) in
                
                let selectedID: [String] = CatImageVM.shared.uploadImageList
                    .filter({ self.selectedImageIDList.contains($0.id)
                    }).map({ $0.id })
                
                print(#file, #function, #line, "선택된 아이디 배열:\(selectedID)")
                CatImageVM.shared.deleteUploadCatImages(imageIDs: selectedID)
            
                self.uploadImageCollectionView.performBatchUpdates {
                    
                    // 선택된 아이템들을 내림차순으로 변경
                    let selectedItems: [IndexPath] = selectedItems.sorted(by: {$0 > $1})
                    print(#file, #function, #line, "selectedItems: \(selectedItems)")
                    
                    for indexPath in selectedItems {
                        if let cell: UploadImageCell = self.uploadImageCollectionView.cellForItem(at: indexPath) as? UploadImageCell {
                            
                            CatImageVM.shared.uploadImageList.remove(at: indexPath.item)
                            print(#file, #function, #line, "- 업로드 리스트 배열: \(CatImageVM.shared.uploadImageList)")
                            print(#file, #function, #line, "삭제됨\(indexPath.item)")
                           
                            cell.configureSelectImage(isSelectHidden: true) // 체크 아이콘 숨기기
                        }
                    }
                    
                    // 선택한 아이템이 비어 있으면 휴지통 비활성화 변경됨
                    if selectedItems.isEmpty {
                        self.trashButton.isEnabled = false
                    }
                    
                    // 성공하면 선택한 아이템을 지웁니다.
                    self.uploadImageCollectionView.deleteItems(at: selectedItems)
                } completion: { _ in
                    print(#file, #function, #line, "-✅ 업로드 이미지 삭제 성공")
                    self.updateEmptyUploadView(tag: 1)
                }
                
                // 이미지 삭제가 성공 되면 편집모드 해제
                self.setEditing(false, animated: true)
                self.updateEditButtonTitle()
            }
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "취소", style: .cancel) { (action) in
                self.setEditing(false, animated: true)
                self.updateEditButtonTitle()
                self.trashButton.isEnabled = false
            }
            
            actionSheet.addAction(deletedAction)
            actionSheet.addAction(cancelAction)
            
            self.present(actionSheet, animated: true, completion: nil)
        }
        
    }
    
} // UploadPhotosVC

// MARK: - UICollectionViewDelegate

extension UploadPhotosVC: UICollectionViewDelegate { }

// MARK: - UICollectionViewDataSource

extension UploadPhotosVC: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CatImageVM.shared.uploadImageList.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell: UploadImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCell", for: indexPath) as? UploadImageCell else {
            return UICollectionViewCell()
        }
        
        // 서버에 업로드 했던 고양이 이미지 보여준다.
        if let imageURL: String = CatImageVM.shared.uploadImageList[indexPath.row].url {
            let url = URL(string: imageURL)
            cell.uploadImageView.kf.setImage(with: url)
        }
        return cell
    }
    
    // 셀 선택하기 직전에
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        // 편집모드 ON일 경우에만 실행 한다.
        if isEditingMode == true {
            print(#file, #function, #line, "편집모드 \(isEditingMode)중 입니다. 쎌을 선택 했습니다 ")
            
            self.trashButton.isEnabled = true
            
            // 선택된 셀의 인덱스를 추적하고 체크 아이콘을 표시
            if let cell: UploadImageCell = collectionView.cellForItem(at: indexPath) as? UploadImageCell {
                cell.configureSelectImage(isSelectHidden: false) // 체크 아이콘 보이기
                print(#file, #function, #line, "- 쎌 인덱스: \(indexPath.item)")
            }
            
            
            let selectedImageID: String = CatImageVM.shared.uploadImageList[indexPath.item].id
            print(#file, #function, #line, "선택된 이미지 ID: \(selectedImageID)")
            
            // 선택된 셀의 이미지 ID를 selectedImageIDList에 넣는다.
            self.selectedImageIDList.append(selectedImageID)
            self.selectedImageID = selectedImageID
            
        }
        return isEditingMode
    }
    
    // 셀 선택 완료
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#file, #function, #line, "- 셀 선택 완료")
        updateTrashButton()
    }
    
    // 셀 선택해제
    func collectionView(_ collectionView: UICollectionView, shouldDeselectItemAt indexPath: IndexPath) -> Bool {
        
        // 편집모드 ON일 경우에만 실행 한다.
        if isEditingMode == true {
            print(#file, #function, #line, "- 편집모드 \(isEditingMode)입니다. 쎌을 해제 했습니다.")
            
            if let cell: UploadImageCell = collectionView.cellForItem(at: indexPath) as? UploadImageCell {
                cell.configureSelectImage(isSelectHidden: true) // 체크 아이콘 가리기
                print(#file, #function, #line, "- Cell 인덱스: \(indexPath.item)")
                
                let selectedImageID: String = CatImageVM.shared.uploadImageList[indexPath.item].id
                print(#file, #function, #line, "- 선택된 이미지 ID: \(selectedImageID)")
                
                // 업로드 목록에 있는 이미지ID 하고 선택된 이미지ID 동일한 것을 찾는다.
                let removeID: String? = CatImageVM.shared.uploadImageList
                    .first(where: { $0.id == selectedImageID })?.id
                
                // 동일한 이미지ID를 selectedImageIDList에 지운다.
                self.selectedImageIDList.removeAll(where: {$0 == removeID })
            }
            
        }
        
        return isEditingMode
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        print(#file, #function, #line, "- 셀 해제 완료")
        updateTrashButton()
    }
    
    
}

// MARK: - UICollectionViewDelegateFlowLayout

extension UploadPhotosVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets.init(top: 0, left: 0, bottom: 1, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let size: CGFloat = (collectionView.frame.width / 3) - 1.0
        
        return CGSize(width: size, height: size)
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



