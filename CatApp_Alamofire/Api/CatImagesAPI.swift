//
//  CatImagesAPI.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/13/25.
//

import Foundation

import Toast
import Alamofire


enum CatImagesAPI {
    
    static let endPoint: String = "https://api.thecatapi.com/"
   
    // MARK: GET
    /// 서버에서 고양이 이미지을 가져옵니다.
    /// - Parameter imageLimit: 고양이 이미지 최대 요청 수를 제한합니다.
    /// - Parameter completion: 서버에서 받은 응답 및 에러
    static func fatchCatImage(imageLimit: Int, completion: @escaping (Result<[CatImageResponse], Error>) -> Void) {
        
        let urlString: String = endPoint + "v1/images/search" + "?limit=\(imageLimit)"
        
        AF.request(urlString, method: .get, parameters: nil, headers: [
            "Content-Type": "application",
            "x-api-key": "live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf"
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

    // MARK: POST
    /// 고양이 이미지를 서버에 업로드합니다
    /// - Parameters:
    ///   - fileData: 선택한 이미지 파일 데이터
    ///   - completion: 서버에서 받은 응답 및 에러
    static func uploadCatImage(selected fileData: Data, completion: @escaping (Result<UploadCatImageResponse, Error>) -> Void) {
        print(#file, #function, #line, "- 고양이 이미지 업로드 요청")
        
        let urlString: String = endPoint + "v1/images/upload"
        let boundary: String = UUID().uuidString
        
        let headers: HTTPHeaders = [
            "x-api-key": "live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf",
            "Content-Type": "multipart/form-data; boundary=\(boundary)"
        ]
        
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(fileData, withName: "file", fileName: "cat.jpeg", mimeType: "image/jpeg" )
            
        }, to: urlString, method: .post, headers: headers)
        .responseDecodable(of: UploadCatImageResponse.self, completionHandler: { response in
            
            // 고양이 업로드 응답을 받았으면 ToastActivity가 사라진다.
            NotificationCenter.default.post(name: .uploadSuccessToastEvenet, object: nil, userInfo: nil)
        
            switch response.result {
            case .success(let result):
                print(#file, #function, #line, "-✅ JSON 디코드 성공")
                completion(Result.success(result))
                
            case .failure(let error):
                completion(Result.failure(error))
            }
            
        })
        
    }
    
    // MARK: GET
    /// 업로드 했던 고양이 이미지를 조회합니다.
    /// - Parameters:
    ///   - imageLimit: 업로드 이미지 조회 횟수
    ///   - completion: 서버에서 받은 응답 및 에러
    static func fatchUploadCatImage(imageLimit: Int, completion: @escaping (Result<[UploadCatImage], Error>) -> Void) {
        print(#file, #function, #line, "- 업로드 이미지 조회 요청 ")
        let urlString: String = endPoint + "v1/images/?limit=\(imageLimit)&page=0&order=DESC"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-api-key": "live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf"
        ]
        
        AF.request(urlString, method: .get, headers: headers)
            .responseDecodable(of: [UploadCatImage].self, completionHandler: { response in
                
                switch response.result {
                case .success(let image):
                    print(#file, #function, #line, "-✅ JSON 디코드 성공")
                    completion(Result.success(image))
                case .failure(let error):
                    print(#file, #function, #line, "-💣 JSON 디코드 실패")
                    completion(Result.failure(error))
                }
                
            })
     
    }
    
    // MARK: GET
    /// 업로드 했던 고양이 이미지를 삭제 합니다.
    /// - Parameters:
    ///   - imageID: 삭제 이미지 아이디
    ///   - completion: 서버에서 받은 응답 및 에러
    static func deleteUploadCatImage(imageID: String, completion: @escaping (Result<DeleteUploadResponse, Error>) -> Void) {
        print(#file, #function, #line, "- 업로드 삭제 요청")
        
        let urlString: String = endPoint + "v1" + "/images/" + "\(imageID)"
        print(#file, #function, #line, "\(urlString)")
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-api-key": "live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf"
        ]
        
        AF.request(urlString, method: .delete, parameters: nil, headers: headers)
            .validate(statusCode: 200..<300)
            .responseDecodable(of: DeleteUploadResponse.self, completionHandler: { response in
                switch response.result {
                case .success(let result):
                    print(#file, #function, #line, "- ✅ JSON 디코드 성공 ")
                    completion(Result.success(result))
                case .failure(let error):
                    completion(Result.failure(error))
                    print(#file, #function, #line, "- 💣JSON 디코드 실패.")
                }
            })
        
    }
    
    // MARK: - 즐겨찾기 API
    
    // MARK: POST
    /// 고양이 이미지를  즐겨찾기 등록 합니다.
    /// - Parameters:
    ///   - imageID: 즐겨찾기할 이미지 아이디
    ///   - completion: 서버에서 받은 응답 및 에러
    static func createFavoriteCatImage(imageID: String, completion: @escaping (Result<CreateFavoriteResponse, Error>) -> Void) {
        print(#file, #function, #line, "- 즐겨찾기 요청 했습니다.")
        
        let urlString: String = endPoint + "v1" + "/favourites"
    
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-api-key": "live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf"
        ]
        
        let body: [String: Any] = [
            "image_id": imageID,
        ]
        
        AF.request(urlString, method: .post, parameters: body, encoding: JSONEncoding.default ,headers: headers)
            .responseDecodable(of: CreateFavoriteResponse.self, completionHandler: { response in
                switch response.result {
                    
                case .success(let result):
                    print(#file, #function, #line, "- ✅ JSON 디코드 성공 ")
                    completion(Result.success(result))
                case .failure(let error):
                    print(#file, #function, #line, "- 💣JSON 디코드 실패.")
                    completion(Result.failure(error))
                }
            })
    }
    
    // MARK: GET
    /// 즐겨찾기 등록 했던 고양이 이미지를 가져옵니다.
    /// - Parameter completion: 서버에서 받은 응답 및 에러
    static func fatchFavoritesCatImages(completion: @escaping (Result<[AllFavoriteResponse], Error>) -> Void) {
         
         let urlString: String = endPoint + "v1/favourites"
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-api-key": "live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf"
        ]
         
        AF.request(urlString, method: .get, parameters: nil, headers: headers)
            .responseDecodable(of: [AllFavoriteResponse].self, completionHandler: { response in
                switch response.result {
                    
                case .success(let result):
                    print(#file, #function, #line, "- ✅ JSON 디코드 성공 ")
                    completion(Result.success(result))
                case .failure(let error):
                    print(#file, #function, #line, "- 💣JSON 디코드 실패.")
                    completion(Result.failure(error))
                }
            })

         
     }

    
    // MARK: DELETE
    /// 즐겨찾기 등록 했던 고양이 이미지를 삭제합니다.
    /// - Parameters:
    ///   - imageID: 삭제할 고양이 이미지 아이디
    ///   - completion: 서버에서 받은 응답 및 에러
    static func deleteFavoriteCatImage(imageID: Int, completion: @escaping (Result<DeleteFavoriteResponse, Error>) -> Void) {
        print(#file, #function, #line, "- 즐겨찾기 삭제 요청 했습니다.")
        
        let urlString: String = endPoint + "v1" + "/favourites/" + "\(imageID)"
        print(#file, #function, #line, "\(urlString)")
        
        
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
            "x-api-key": "live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf"
        ]
        
       AF.request(urlString, method: .delete, parameters: nil, headers: headers)
           .responseDecodable(of: DeleteFavoriteResponse.self, completionHandler: { response in
               switch response.result {
                   
               case .success(let result):
                   print(#file, #function, #line, "- ✅ JSON 디코드 성공 ")
                   completion(Result.success(result))
               case .failure(let error):
                   print(#file, #function, #line, "- 💣JSON 디코드 실패.")
                   completion(Result.failure(error))
               }
           })
    }
    
    
}


