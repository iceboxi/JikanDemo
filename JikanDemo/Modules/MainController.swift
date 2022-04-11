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
    let segment = UISegmentedControl(items: ["Top Anime", "Top Manga"])
    let tableView: UITableView = UITableView()
    
    let identify = R.reuseIdentifier.tableViewCell.identifier
    let viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bindViewModel()
        view.backgroundColor = .gray
        

    }

    func makeUI() {
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
    
    func bindViewModel() {
        let input = MainViewModel.Input(footerRefresh: Observable.just(()),
                                        selection: segment.rx.selectedSegmentIndex.asDriver())
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: identify, cellType: TableViewCell.self)) { _, model, cell in
                cell.bind(to: model)
            }
            .disposed(by: rx.disposeBag)
    }
}

