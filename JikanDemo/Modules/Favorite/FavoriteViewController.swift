//
//  FavoriteViewController.swift
//  JikanDemo
//
//  Created by ice on 2022/4/12.
//

import UIKit
import RxSwift
import NSObject_Rx
import ObjectMapper
import SnapKit
import RxDataSources
import RxRelay

class FavoriteViewController: UIViewController {
    let tableView: UITableView = UITableView()
    
    let identify = R.reuseIdentifier.tableViewCell.identifier
    let viewModel = FavoriteViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        makeUI()
        bindViewModel()
    }

    func makeUI() {
        view.backgroundColor = .white
        title = "Favorite"
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.register(R.nib.tableViewCell)
        
        let favorite = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(closeVC))
        self.navigationItem.leftBarButtonItem = favorite
    }
    
    @objc func closeVC() {
        dismiss(animated: true, completion: nil)
    }
    
    func bindViewModel() {
        let input = FavoriteViewModel.Input(selection: tableView.rx.modelSelected(TableViewCellViewModel.self).asDriver())
        let output = viewModel.transform(input: input)
        
        output.items.asDriver(onErrorJustReturn: [])
            .drive(tableView.rx.items(cellIdentifier: identify, cellType: TableViewCell.self)) { _, model, cell in
                cell.bind(to: model)
            }
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
