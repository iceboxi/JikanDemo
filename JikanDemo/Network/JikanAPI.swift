//
//  JikanAPI.swift
//  JikanDemo
//
//  Created by ice on 2022/4/9.
//

import Foundation
import Moya

protocol RequestRoutable {
    var controllerName: String { get }
}

enum JikanAPI: RequestRoutable {
    case getTopAnime(page: Int)
    case getTopManga(page: Int)
    
    var controllerName: String {
        return "/top"
    }
}

extension JikanAPI: TargetType {
    var headers: [String: String]? {
        nil
    }
    
    var baseURL: URL {
        return URL(string: "https://api.jikan.moe/v4")!
    }
    
    var path: String {
        let endPoint: String
        
        switch self {
        case .getTopAnime:
            endPoint = "anime"
        case .getTopManga:
            endPoint = "manga"
        }
        
        return "\(controllerName)/\(endPoint)"
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .getTopAnime(let page):
            return .requestParameters(parameters: ["page": page], encoding: parameterEncoding)
        case .getTopManga(let page):
            return .requestParameters(parameters: ["page": page], encoding: parameterEncoding)
        }
    }

    var sampleData: Data {
        var dataUrl: URL?
        switch self {
        case .getTopAnime: dataUrl = R.file.topAnimeJson()
        case .getTopManga: dataUrl = R.file.topMangaJson()
        }
        if let url = dataUrl, let data = try? Data(contentsOf: url) {
            return data
        }
        return Data()
    }
    
    public var parameterEncoding: ParameterEncoding {
        return URLEncoding.default
    }
}
