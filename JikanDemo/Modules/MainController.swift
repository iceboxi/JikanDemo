//
//  ViewController.swift
//  JikanDemo
//
//  Created by ice on 2022/4/10.
//

import UIKit
import RxSwift
import Moya
import RxMoya
import NSObject_Rx
import ObjectMapper
import SnapKit
import RxDataSources
import RxRelay

class MainController: UIViewController {
    let tableView: UITableView = UITableView()
    
    var items = BehaviorRelay<[Anime]>(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        view.backgroundColor = .gray
        
        
        let identify = R.reuseIdentifier.tableViewCell.identifier
        items.asDriver()
            .drive(tableView.rx.items(cellIdentifier: identify, cellType: TableViewCell.self)) { tableView, model, cell in
                cell.config(with: model)
            }
            .disposed(by: rx.disposeBag)
        
        
        let provider = MoyaProvider<JikanAPI>()
        provider.rx.request(.getTopAnime(page: 0))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(AnimeList.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { list in
                logDebug("\(list.data)")
                self.items.accept(list.data)
            })
            .disposed(by: rx.disposeBag)
        
        provider.rx.request(.getTopManga(page: 0))
            .filterSuccessfulStatusCodes()
            .asObservable()
            .mapObject(MangaList.self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { list in
                logDebug("\(list.data)")
            })
            .disposed(by: rx.disposeBag)
        
        makeUI()
        
        
    }

    func makeUI() {
        let segment = UISegmentedControl(items: ["Top Anime", "Top Manga"])
        segment.selectedSegmentIndex = 0
        view.addSubview(segment)
        segment.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.height.equalTo(44)
        }
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(segment.snp.bottom)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        tableView.register(R.nib.tableViewCell)
    }
}

