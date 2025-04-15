//
//  CatImageData.swift
//  CatApp_Turtorial
//
//  Created by 유지완 on 3/13/25.
//

import Foundation

/// 고양이 이미지 응답
struct CatImageResponse: Decodable {
    let breeds: [Breeds]?
    let id: String?
    let url: String?
    let width, height: Int?
}

struct Breeds: Codable { }

// MARK: - 업로드

/// 업로드  고양이 이미지 응답
struct UploadCatImageResponse: Encodable & Decodable {
    let id: String?
    let url: String?
    let width, height: Int?
    let originalFilename: String?
    let pending, approved: Int?

    enum CodingKeys: String, CodingKey {
        case id, url, width, height
        case originalFilename = "original_filename"
        case pending, approved
    }
}

/// 업로드 된 고양이 이미지 조회 응답
struct UploadCatImage: Decodable {
    let id: String
    let breeds: [Breeds]
    let url: String?
    let width: Int?
    let height: Int?
    let subID: String?
    let createdAt: String?
    let originalFilename: String?
    let breedIDs: String?
    
    enum CodingKeys: String, CodingKey {
        case id, breeds, url, width, height
        case subID = "sub_id"
        case createdAt = "created_at"
        case originalFilename = "original_filename"
        case breedIDs = "breed_ids"
    }
}

struct DeleteUploadResponse: Encodable & Decodable {
  
}

// MARK: - 즐겨찾기

/// 즐겨찾기 등록 응답
struct CreateFavoriteResponse: Encodable & Decodable {
    let message: String?
    let id: Int?
}

/// 즐겨찾기 삭제 응답
struct DeleteFavoriteResponse: Encodable & Decodable {
    let message: String?
    let id: Int?
}

/// 즐겨찾기 전체조회 응답
struct AllFavoriteResponse: Encodable & Decodable {
    let id: Int?
    let userID: String?
    let imageID: String?
    let subID: String?
    let createdAt: String?
    let image: FavouriteImage
    
    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case imageID = "image_id"
        case subID = "sub_id"
        case createdAt = "created_at"
        case image
    }
}

struct FavouriteImage: Encodable & Decodable {
    let id: String?
    let url: String?
}
