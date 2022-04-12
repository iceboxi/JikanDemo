//
//  AnimeModel.swift
//  JikanDemo
//
//  Created by ice on 2022/4/9.
//

import Foundation
import ObjectMapper

struct AnimeList: Mappable {
    var data: [Anime]
    var pagination: PageInfo

    init?(map: Map) {
        data = []
        pagination = PageInfo()
    }
    
    mutating func mapping(map: Map) {
        data <- map["data"]
        pagination <- map["pagination"]
    }
}

protocol MalModel: Mappable {
    var id: Int { get }
    var image: URL? { get }
    var title: String { get }
    var rank: Int? { get }
    var startDate: Date { get }
    var endDate: Date { get }

    var type: String { get }
    var favorite: Bool { get set }
}

struct Anime: MalModel {
    var id: Int
    var image: URL?
    var title: String
    var rank: Int?
    var startDate: Date
    var endDate: Date
    var type: String
    var favorite: Bool
    
    init?(map: Map) {
        id = 0
        title = ""
        startDate = Date()
        endDate = Date()
        type = "anime"
        favorite = false
    }
    
    mutating func mapping(map: Map) {
        id <- map["mal_id"]
        image <- (map["images.jpg.small_image_url"], URLTransform())
        title <- map["title"]
        rank <- map["rank"]
        startDate <- (map["aired.from"], ISO8601DateTransform())
        endDate <- (map["aired.end"], ISO8601DateTransform())
        type <- map["mal_type"]
        favorite <- map["local_favorite"]
    }
}

struct PageInfo: Mappable {
    var lastVisiblePage: Int = 0
    var hasNextPage: Bool = false
    
    init?(map: Map) {}
    init() {}

    mutating func mapping(map: Map) {
        lastVisiblePage <- map["last_visible_page"]
        hasNextPage <- map["has_next_page"]
    }
}
