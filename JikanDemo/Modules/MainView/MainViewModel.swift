//
//  MainViewModel.swift
//  JikanDemo
//
//  Created by ice on 2022/4/11.
//

import Foundation
import RxCocoa
import RxSwift
import Moya
import RxMoya

class MainViewModel: NSObject, ViewModelType {
    struct Input {
        let footerRefresh: Observable<Void>
        let type: Driver<Int>
        let selection: Driver<TableViewCellViewModel>
    }
    
    struct Output {
        let navigationTitle: Driver<String>
        let items: BehaviorRelay<[TableViewCellViewModel]>
    }
    
    var index = 0
    var page = 1
    var hasNext = true
    let malSelected = PublishSubject<URL>()
    
    let provider = MoyaProvider<JikanAPI>()
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[TableViewCellViewModel]>(value: [])
        let title = BehaviorRelay<String>(value: "")
        
        input.footerRefresh.skip(1)
            .flatMapLatest({ [weak self] _ -> Observable<[TableViewCellViewModel]> in
                guard let self = self, self.hasNext else { return Observable.just([]) }
                self.page += 1
                return self.request(self.index)
            })
            .subscribe(onNext: { list in
                var all = elements.value
                all.append(contentsOf: list)
                elements.accept(all)
            })
            .disposed(by: rx.disposeBag)
        
        input.type.asObservable()
            .flatMapLatest { [weak self] index -> Observable<[TableViewCellViewModel]> in
                guard let self = self else { return Observable.just([]) }
                self.index = index
                self.page = 1
                title.accept(index == 0 ? "Top Anime" : "Top Manga")
                elements.accept([])
                return self.request(index)
            }
            .subscribe { list in
                elements.accept(list)
            }
            .disposed(by: rx.disposeBag)
        
        input.selection.asObservable()
            .map { $0.item }
            .subscribe(onNext: { model in
                self.malSelected.onNext(URL(string: "https://myanimelist.net/\(model.type)/\(model.id)")!)
            })
            .disposed(by: rx.disposeBag)

        return Output(navigationTitle: title.asDriver(), items: elements)
    }
    
    func request(_ type: Int) -> Observable<[TableViewCellViewModel]> {
        if type == 0 {
            return requestAnime()
        } else {
            return requestManga()
        }
    }
    
    func requestAnime() -> Observable<[TableViewCellViewModel]> {
        return provider.rx.request(.getTopAnime(page: page))
            .asObservable()
            .filterSuccessfulStatusCodes()
            .mapObject(AnimeList.self)
            .map({ list in
                let favorite = UserConfigs.shared.favorates.value
                return list.data.map { item in
                    let isFavorite = favorite.contains(where: { item.id == $0.id })
                    let viewModel = TableViewCellViewModel(with: item, isFavorite: isFavorite)
                    return viewModel
                }
            })
    }
    
    func requestManga() -> Observable<[TableViewCellViewModel]> {
        return provider.rx.request(.getTopManga(page: page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(MangaList.self)
            .map({ [weak self] list in
                let favorite = UserConfigs.shared.favorates.value
                self?.hasNext = list.pagination.hasNextPage
                return list.data.map { item in
                    let isFavorite = favorite.contains(where: { item.id == $0.id })
                    let viewModel = TableViewCellViewModel(with: item, isFavorite: isFavorite)
                    return viewModel
                }
            })
    }
}
