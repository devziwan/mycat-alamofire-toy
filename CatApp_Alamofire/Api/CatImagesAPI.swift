//
//  CatImagesAPI.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/13/25.
//

import Foundation

import Toast

// 질문: Result은 자료형이 열거형인데 왜 클로저처리를 해야하는 것일까? -> 질문 수정
enum CatImagesAPI {
    
    static let endPoint: String = "https://api.thecatapi.com/"
   
    // MARK: GET
    /// 서버에서 고양이 이미지을 가져옵니다.
    /// - Parameter imageLimit: 고양이 이미지 최대 요청 수를 제한합니다.
    /// - Parameter completion: 서버에서 받은 응답 및 에러 
    static func fatchCatImage(imageLimit: Int, completion: @escaping (Result<[CatImageResponse], Error>) -> Void) {
        
        let urlString: String = endPoint + "v1/images/search" + "?limit=\(imageLimit)"
        
        guard let url = URL(string: urlString) else {
            print(#file, #function, #line, "- ❌ 잘못된 URL: \(urlString)")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf", forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in

            guard let data: Data = data else {
                print(#file, #function, #line, "- 💣 [Data] 데이터 없음")
                return
            }
            
            do {
                let jsonData: [CatImageResponse] = try JSONDecoder().decode([CatImageResponse].self, from: data)
//                print(#file, #function, #line, "\(String(describing: jsonData))")
                
                completion(Result.success(jsonData))
                print(#file, #function, #line, "-✅ JSON 디코드 성공")
            } catch {
                print(#file, #function, #line, "-💣 JSON 디코드 실패")
            }
            
           
        }).resume()
        
    }
    
    // MARK: POST
    /// 고양이 이미지를 서버에 업로드합니다
    /// - Parameters:
    ///   - fileData: 선택한 이미지 파일 데이터
    ///   - completion: 서버에서 받은 응답 및 에러
    static func uploadCatImage(selected fileData: Data, completion: @escaping (Result<UploadCatImageResponse, Error>) -> Void) {
        print(#file, #function, #line, "- 고양이 이미지 업로드 요청")
        
        let urlString: String = endPoint + "v1/images/upload"
        
        guard let url = URL(string: urlString) else {
            print(#file, #function, #line, "-💣 Error: 잘못된 URL 입니다.")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        let boundary: String = UUID().uuidString
        
        urlRequest.httpMethod = "POST"
        urlRequest.addValue("live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf", forHTTPHeaderField: "x-api-key")
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let multipartFromDataBody: Data = multipartFromDataBody(boundary, imageData: fileData)
        
        URLSession.shared.uploadTask(with: urlRequest, from: multipartFromDataBody, completionHandler: { data, urlResponse, error in
            print(#file, #function, #line, "- 고양이 이미지 업로드 응답 받음")
            
            // 고양이 업로드 응답을 받았으면 ToastActivity가 사라진다.
            NotificationCenter.default.post(name: .uploadSuccessToastEvenet, object: nil, userInfo: nil)
            
            if let error: Error = error {
                print(#file, #function, #line, "-💣 Error: 업로드 네트워크 요청 실패")
                return
            }
            
            guard let data: Data = data else {
                print(#file, #function, #line, "-💣 Error: 데이터가 nil 입니다.")
                return
            }
            
            if let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse {
                print(#file, #function, #line, "-✅ Status Code: \(httpResponse.statusCode)")
            }
            
            
            do {
                let jsonData: UploadCatImageResponse = try JSONDecoder().decode(UploadCatImageResponse.self, from: data)
//                print(#file, #function, #line, "\(String(describing: jsonData))")
            
                completion(Result.success(jsonData))
                
                print(#file, #function, #line, "-✅ JSON 디코드 성공 ")
            } catch {
                print(#file, #function, #line, "-💣 JSON 디코드 실패")
                completion(Result.failure(error))
            }

            
        }).resume()
        
    }
    
    // MARK: GET
    /// 업로드 했던 고양이 이미지를 조회합니다.
    /// - Parameters:
    ///   - imageLimit: 업로드 이미지 조회 횟수
    ///   - completion: 서버에서 받은 응답 및 에러
    static func fatchUploadCatImage(imageLimit: Int, completion: @escaping (Result<[UploadCatImage], Error>) -> Void) {
        print(#file, #function, #line, "- 업로드 이미지 조회 요청 ")
        let urlString: String = endPoint + "v1/images/?limit=\(imageLimit)&page=0&order=DESC"
        
        guard let url = URL(string: urlString) else {
            print(#file, #function, #line, "- ❌ 잘못된 URL: \(urlString)")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf", forHTTPHeaderField: "x-api-key")
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in

            guard let data: Data = data else {
                print(#file, #function, #line, "- 💣 [Data] 데이터 없음")
                return
            }
            
            do {
                let jsonData: [UploadCatImage] = try JSONDecoder().decode([UploadCatImage].self, from: data)
//                print(#file, #function, #line, "\(String(describing: jsonData))")
                
                completion(Result.success(jsonData))
                print(#file, #function, #line, "-✅ JSON 디코드 성공")
            } catch {
                print(#file, #function, #line, "-💣 JSON 디코드 실패")
            }
            
        }).resume()
    }
    
    
    
    static func deleteUploadCatImage(imageID: String, completion: @escaping (Result<DeleteUploadResponse, Error>) -> Void) {
        print(#file, #function, #line, "- 업로드 삭제 요청")
        
        let urlString: String = endPoint + "v1" + "/images/" + "\(imageID)"
        print(#file, #function, #line, "\(urlString)")
        
        guard let url: URL = URL(string: urlString) else {
            print(#file, #function, #line, "-💣 Error: 잘못된 URL 입니다.")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf", forHTTPHeaderField: "x-api-key")
        
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
            print(#file, #function, #line, "- 업로드 삭제 응답 했습니다.")
            guard let data: Data = data else {
                print(#file, #function, #line, "-💣 Error: 데이터가 nil 입니다.")
                return
            }
            
            if let error: Error = error {
                print(#file, #function, #line, "-💣 Error: 업로드 네트워크 요청 실패 했습니다.")
            }
            
            if let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse {
                print(#file, #function, #line, "-✅ Status Code: \(httpResponse.statusCode)")
            }
            
            do {
                let jsonData: DeleteUploadResponse = try JSONDecoder().decode(DeleteUploadResponse.self, from: data)
                print(#file, #function, #line, "\(String(describing: jsonData))")
                
                completion(Result.success(jsonData))
                print(#file, #function, #line, "- ✅ JSON 디코드 성공 ")
            } catch {
                print(#file, #function, #line, "- 💣JSON 디코드 실패.")
            }
        }).resume()
        
    }
    
    
    // MARK: - 즐겨찾기 API
    
    // MARK: POST
    /// 고양이 이미지를  즐겨찾기 등록 합니다.
    /// - Parameters:
    ///   - imageID: 이미지 아이디
    ///   - completion: 서버에서 받은 응답 및 에러
    static func createFavoriteCatImage(imageID: String, completion: @escaping (Result<CreateFavoriteResponse, Error>) -> Void) {
        print(#file, #function, #line, "- 즐겨찾기 요청 했습니다.")
        
        let urlString: String = endPoint + "v1" + "/favourites"
        
        guard let url: URL =  URL(string: urlString) else {
            print(#file, #function, #line, "- 잘못된 URL 입니다.")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf", forHTTPHeaderField: "x-api-key")
        
        // struct -> data
//        struct RequestData : Encodable {
//            var image_id : String
//        }
//        
//        let jsonData02 = try? JSONEncoder().encode(RequestData(image_id: imageID))
//        
        // dictionary -> data
        let body: [String: Any] = [
            "image_id": imageID,
        ]
        
        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            urlRequest.httpBody = jsonData
        } catch {
            print(#file, #function, #line, "- 직렬화 실패 했습니다.")
        }
        
        // -- data = struct -> data, [:] -> data

        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
            print(#file, #function, #line, "- 즐겨찾기 응답 했습니다.")
            
            guard let data: Data = data else {
                print(#file, #function, #line, "-💣 Error: 데이터가 nil 입니다.")
                return
            }
            
            if let error: Error = error {
                print(#file, #function, #line, "-💣 Error: 업로드 네트워크 요청 실패 했습니다.")
            }
            
            if let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse {
                print(#file, #function, #line, "-✅ Status Code: \(httpResponse.statusCode)")
            }
    
            
            do {
                let jsonData = try JSONDecoder().decode(CreateFavoriteResponse.self, from: data)
                completion(Result.success(jsonData))
            } catch {
                completion(Result.failure(error))
            }
            
            
        }).resume()
    }
    
    // MARK: GET
    /// 즐겨찾기 등록 했던 고양이 이미지를 가져옵니다.
    /// - Parameter completion: 서버에서 받은 응답 및 에러
    static func fatchFavoritesCatImages(completion: @escaping (Result<[AllFavoriteResponse], Error>) -> Void) {
         
         // MARK: 꼭 체크 하기!!!
         let urlString: String = endPoint + "v1/favourites"
         
        guard let url: URL = URL(string: urlString) else {
             print(#file, #function, #line, "-💣 Error: 잘못된 URL 입니다.")
             return
         }
         
        var urlRequest: URLRequest = URLRequest(url: url)
         
         urlRequest.httpMethod = "GET"
         // MARK: 꼭 체크 하기!!!
         urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
         urlRequest.addValue("live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf", forHTTPHeaderField: "x-api-key")
        
         
         URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in

             guard let data: Data = data else {
                 print(#file, #function, #line, "-💣 Error: 데이터가 nil 입니다.")
                 return
             }
             
             do {
                 let jsonData: [AllFavoriteResponse] = try JSONDecoder().decode([AllFavoriteResponse].self, from: data)
//                 print(#file, #function, #line, "\(String(describing: jsonData))")
                 
                 completion(Result.success(jsonData))
                 print(#file, #function, #line, "-✅ Sursser: JSON 디코드 성공 하였습니다.")
             } catch {
                 print(#file, #function, #line, "-💣 Error: JSON 디코드 실패 하였습니다.")
             }
             
            
         }).resume()
         
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
        
        guard let url: URL = URL(string: urlString) else {
            print(#file, #function, #line, "-💣 Error: 잘못된 URL 입니다.")
            return
        }
        
        var urlRequest: URLRequest = URLRequest(url: url)
        
        urlRequest.httpMethod = "DELETE"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.addValue("live_xLST3RHbCI8ZlLXfi7PG8uwm9GjmFsiqiAz4yrtWVGtCXeB7wZELTOZEAfnfF3Jf", forHTTPHeaderField: "x-api-key")
        
        
        URLSession.shared.dataTask(with: urlRequest, completionHandler: { data, urlResponse, error in
            print(#file, #function, #line, "- 즐겨찾기 삭제 응답 했습니다.")
            guard let data: Data = data else {
                print(#file, #function, #line, "-💣 Error: 데이터가 nil 입니다.")
                return
            }
            
            if let error: Error = error {
                print(#file, #function, #line, "-💣 Error: 업로드 네트워크 요청 실패 했습니다.")
            }
            
            if let httpResponse: HTTPURLResponse = urlResponse as? HTTPURLResponse {
                print(#file, #function, #line, "-✅ Status Code: \(httpResponse.statusCode)")
            }
            
            do {
                let jsonData: DeleteFavoriteResponse = try JSONDecoder().decode(DeleteFavoriteResponse.self, from: data)
                print(#file, #function, #line, "\(String(describing: jsonData))")
                
                completion(Result.success(jsonData))
                print(#file, #function, #line, "-✅ Sursser: JSON 디코드 성공 하였습니다.")
            } catch {
                print(#file, #function, #line, "-💣 Error: JSON 디코드 실패 하였습니다.")
            }
            
           
        }).resume()
        
    }
    
    fileprivate static func multipartFromDataBody(_ boundary: String, imageData: Data) -> Data {
        var body: Data = Data()
        
        // 1. 지금부터 파일을 보낼게
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        
        // 2. 파일에 파일이름 으로 저장해줘
        // FIXME: name & filename 무엇을 넣어야하는지 이해가 잘안간다.
        body.append("Content-Disposition: form-data; name=\"\("file")\"; filename=\"\("cat.jpeg")\"\r\n".data(using: .utf8)!)
        
        // 3. 이 jpg 이미지 라고 서버한테 알려준다.
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        // 4. 실제 이미지 데이터를 보낸다.
        body.append(imageData)
        // 5. 이제 끝났어
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        
        return body
    }
    
    
    
    
    
}


