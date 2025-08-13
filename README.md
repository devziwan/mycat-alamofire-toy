# 🐱 마이켓 (MyCat) – Alamofire 버전

고양이 이미지를 랜덤으로 감상하고,  
내가 찍은 사진을 업로드하고,  
좋아하는 이미지를 즐겨찾는 iOS 앱



## 프로젝트 개요

**MyCat**은 랜덤 고양이 사진을 감상하고,  
직접 사진을 업로드하거나 즐겨찾기할 수 있는 **iOS 반려동물 이미지 앱**입니다.

이 버전은 **Swift 네트워크 라이브러리인 Alamofire를 활용하여 API 통신을 구현**하는 것을 목적으로 제작되었습니다.  
보다 간결하고 효율적인 네트워크 요청 처리 방식에 중점을 두었습니다.



## 개발 인원

- **1인 개인 프로젝트**  
- 기획, UI/UX 설계, API 연동, 로컬 저장 등 **전 과정을 단독으로 개발**



## 사용 기술

- `Swift`
- `UIKit`
- `Alamofire` – 네트워크 통신
- `Toast` – 사용자 피드백 메시지
- `PHPickerViewController` – 이미지 업로드 기능



##  주요 기능

- 랜덤 고양이 이미지 **API 호출 및 표시**
- 앨범에서 고양이 사진 **선택하여 업로드**
- 고양이 사진 **즐겨찾기 등록/해제** 및 **로컬 저장**

### 대표메서드 - 이미지
```swift
  static func fatchCatImage(imageLimit: Int, completion: @escaping (Result<[CatImageResponse], Error>) -> Void) {
        
        let urlString: String = endPoint + "v1/images/search" + "?limit=\(imageLimit)"
        
        guard let apiKey = Bundle.main.infoDictionary?["CAT_API_KEY"] as? String else {
            return
        }
        
        AF.request(urlString, method: .get, parameters: nil, headers: [
            "Content-Type": "application",
            "x-api-key": apiKey
        ])
        .responseDecodable(of: [CatImageResponse].self) { response in
            switch response.result {
            case .success(let catImages):
                print(#file, #function, #line, "-✅ JSON 디코드 성공")
                completion(Result.success(catImages))
            case .failure(let error):
                print(#file, #function, #line, "-💣 JSON 디코드 실패")
                completion(Result.failure(error))
            }
        }
        
    }
