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

struct Anime: Mappable {
    var id: Int
    var image: URL?
    var title: String
    var rank: Int?
    var startDate: Date
    var endDate: Date

    init?(map: Map) {
        id = 0
        title = ""
        startDate = Date()
        endDate = Date()
    }

    mutating func mapping(map: Map) {
        id <- map["mal_id"]
        image <- (map["images.jpg.small_image_url"], URLTransform())
        title <- map["title"]
        rank <- map["rank"]
        startDate <- (map["aired.from"], ISO8601DateTransform())
        endDate <- (map["aired.end"], ISO8601DateTransform())
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
