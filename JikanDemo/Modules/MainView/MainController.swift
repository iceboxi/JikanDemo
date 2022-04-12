//
//  ViewController.swift
//  JikanDemo
//
//  Created by ice on 2022/4/10.
//

import UIKit
import RxSwift
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
    
    let footerRefreshTrigger = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bindViewModel()
    }

    func makeUI() {
        view.backgroundColor = .white
        
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
        
        let favorite = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(showFavorite))
        self.navigationItem.rightBarButtonItem = favorite
    }
    
    @objc func showFavorite() {
        let vc = FavoriteViewController()
        let nav = UINavigationController(rootViewController: vc)
        present(nav, animated: true, completion: nil)
    }
    
    func bindViewModel() {
        let refresh = Observable.of(Observable.just(()), footerRefreshTrigger).merge()
        let input = MainViewModel.Input(footerRefresh: refresh,
                                        type: segment.rx.selectedSegmentIndex.asDriver(),
                                        selection: tableView.rx.modelSelected(TableViewCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: identify, cellType: TableViewCell.self)) { _, model, cell in
                cell.bind(to: model)
            }
            .disposed(by: rx.disposeBag)
        
        tableView.rx.willDisplayCell
            .map { $0.indexPath.item }
            .distinctUntilChanged()
            .withLatestFrom(output.items) { (item, list) -> Bool in
                return item == list.count - 3
            }
            .subscribe(onNext: { [weak self] bool in
                if bool {
                    self?.footerRefreshTrigger.onNext(())
                }
            })
            .disposed(by: rx.disposeBag)
        
        output.navigationTitle.drive(onNext: { [weak self] title in
            self?.title = title
        })
            .disposed(by: rx.disposeBag)
        
        viewModel.malSelected
            .subscribe(onNext: { [weak self] (url) in
                let vc = WebViewController()
                vc.url = url
                self?.navigationController?.pushViewController(vc, animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
}
