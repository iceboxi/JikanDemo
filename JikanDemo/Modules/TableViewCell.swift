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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
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
        contentView.addSubview(hStack)
        hStack.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func config(with model: Anime) {
        icon.kf.setImage(with: model.image, placeholder: nil, options: [.transition(.fade(1)), .cacheOriginalImage])
        rank.text = "\(model.rank ?? -1)"
        title.text = model.title
        date.text = "\(model.startDate)-\(model.endDate)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
