//
//  TableViewCell.swift
//  JikanDemo
//
//  Created by ice on 2022/4/11.
//

import UIKit
import Kingfisher

class TableViewCell: UITableViewCell {
    let icon = UIImageView()
    let title = UILabel()
    let rank = UILabel()
    let date = UILabel()
    let button = UIButton()

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeUI()
    }
    
    override func prepareForReuse() {
        icon.kf.cancelDownloadTask()
    }
    
    func makeUI() {
        let vStack = UIStackView(arrangedSubviews: [title, date])
        vStack.axis = .vertical
        
        let hStack = UIStackView(arrangedSubviews: [rank, icon, vStack])
        hStack.axis = .horizontal
        hStack.spacing = 8
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        
        rank.snp.makeConstraints { make in
            make.width.equalTo(25)
        }
        
        icon.snp.makeConstraints { make in
            make.width.height.equalTo(50)
        }
        
        contentView.addSubview(button)
        button.snp.makeConstraints { make in
            make.height.width.equalTo(30)
            make.trailing.top.equalToSuperview()
        }
        
        updateUI()
    }
    
    func updateUI() {
        setNeedsDisplay()
    }
    
    func bind(to viewModel: TableViewCellViewModel) {
        viewModel.iconURL
            .subscribe { [weak self] url in
                self?.icon.kf.setImage(with: url, placeholder: nil, options: [.transition(.fade(1)), .cacheOriginalImage])
            }
            .disposed(by: rx.disposeBag)

        viewModel.title.asDriver()
            .drive(title.rx.text)
            .disposed(by: rx.disposeBag)
        viewModel.rank.asDriver()
            .drive(rank.rx.text)
            .disposed(by: rx.disposeBag)
        viewModel.date.asDriver()
            .drive(date.rx.text)
            .disposed(by: rx.disposeBag)
        viewModel.favorite.asDriver()
            .drive(onNext: { [weak self] bool in
                self?.button.setTitle(bool ? "❤️" : "🖤", for: .normal)
            })
            .disposed(by: rx.disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
