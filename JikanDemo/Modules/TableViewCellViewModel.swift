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
    let favorite = BehaviorRelay<Bool>(value: false)
    
    var item: MalModel
    
    init(with anime: MalModel, isFavorite: Bool) {
        item = anime
        item.favorite = isFavorite
        
        super.init()
        
        title.accept(anime.title)
        iconURL.accept(anime.image)
        rank.accept(anime.rank != nil ? "\(anime.rank ?? 0)" : "-")
        date.accept("\(anime.startDate)-\(anime.endDate)")
        favorite.accept(isFavorite)
        
        UserConfigs.shared.favorates.asDriver()
            .drive(onNext: { [weak self] list in
                guard let self = self else { return }
                let bool = list.contains(where: { $0.id == self.item.id })
                self.favorite.accept(bool)
                self.item.favorite = bool
            })
            .disposed(by: rx.disposeBag)
    }
}
