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
    
    var page = 0
    let malSelected = PublishSubject<URL>()
    
    let provider = MoyaProvider<JikanAPI>()
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[TableViewCellViewModel]>(value: [])
        let title = BehaviorRelay<String>(value: "")
        
        input.type.asObservable()
            .flatMapLatest { [weak self] index -> Observable<[TableViewCellViewModel]> in
                guard let self = self else { return Observable.just([]) }
                self.page = 0
                title.accept(index == 0 ? "Top Anime" : "Top Manga")
                elements.accept([])
                return self.request(index)
            }
            .subscribe { list in
                elements.accept(list)
            }
            .disposed(by: rx.disposeBag)
        
        input.selection.asObservable()
            .map { $0.id }
            .subscribe(onNext: { id in
                let path = title.value == "Top Anime" ? "anime" : "manga"
                self.malSelected.onNext(URL(string: "https://myanimelist.net/\(path)/\(id)")!)
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
                list.data.map { item in
                    let viewModel = TableViewCellViewModel(with: item)
                    return viewModel
                }
            })
    }
    
    func requestManga() -> Observable<[TableViewCellViewModel]> {
        return provider.rx.request(.getTopManga(page: page))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(MangaList.self)
            .map({ list in
                list.data.map { item in
                    let viewModel = TableViewCellViewModel(with: item)
                    return viewModel
                }
            })
    }
}
