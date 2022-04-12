//
//  FavoriteViewModel.swift
//  JikanDemo
//
//  Created by ice on 2022/4/12.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import RxMoya

class FavoriteViewModel: NSObject, ViewModelType {
    struct Input {
        let selection: Driver<TableViewCellViewModel>
    }
    
    struct Output {
        let items: BehaviorRelay<[TableViewCellViewModel]>
    }
    
    var page = 0
    let malSelected = PublishSubject<URL>()
    
    let provider = MoyaProvider<JikanAPI>()
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[TableViewCellViewModel]>(value: [])
        
        UserConfigs.shared.favorates.asDriver()
            .drive(onNext: { list in
                let result = list.map { item in
                    TableViewCellViewModel(with: item, isFavorite: true)
                }
                elements.accept(result)
            })
            .disposed(by: rx.disposeBag)
        
        input.selection.asObservable()
            .map { $0.item }
            .subscribe(onNext: { model in
                var list = UserConfigs.shared.favorates.value
                if list.contains(where: { $0.id == model.id }) {
                    list.removeAll(where: { $0.id == model.id })
                } else {
                    list.append(model)
                }
                
                UserConfigs.shared.favorates.accept(list)
                
                self.malSelected.onNext(URL(string: "https://myanimelist.net/\(model.type)/\(model.id)")!)
            })
            .disposed(by: rx.disposeBag)

        return Output(items: elements)
    }
}
