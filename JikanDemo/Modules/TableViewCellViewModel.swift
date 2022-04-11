//
//  TableViewCellViewModel.swift
//  JikanDemo
//
//  Created by ice on 2022/4/11.
//

import Foundation
import RxSwift
import RxCocoa
import UIKit

class TableViewCellViewModel: NSObject {
    let title = BehaviorRelay<String>(value: "")
    let iconURL = BehaviorRelay<URL?>(value: nil)
    let date = BehaviorRelay<String>(value: "")
    let rank = BehaviorRelay<String>(value: "")
    
    let id: Int
    let type: String
    
    init(with anime: Anime) {
        title.accept(anime.title)
        iconURL.accept(anime.image)
        rank.accept(anime.rank != nil ? "\(anime.rank ?? 0)" : "-")
        date.accept("\(anime.startDate)-\(anime.endDate)")
        
        id = anime.id
        type = "anime"
    }
    
    init(with manga: Manga) {
        title.accept(manga.title)
        iconURL.accept(manga.image)
        rank.accept(manga.rank != nil ? "\(manga.rank ?? 0)" : "-")
        date.accept("\(manga.startDate)-\(manga.endDate)")
        
        id = manga.id
        type = "manga"
    }
}
