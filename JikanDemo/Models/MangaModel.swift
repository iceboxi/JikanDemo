//
//  MangaModel.swift
//  JikanDemo
//
//  Created by ice on 2022/4/11.
//

import Foundation
import ObjectMapper

struct MangaList: Mappable {
    var data: [Manga]
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

struct Manga: Mappable {
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
        startDate <- (map["published.from"], ISO8601DateTransform())
        endDate <- (map["published.end"], ISO8601DateTransform())
    }
}
