//
//  HistoryTableViewCell.swift
//  Dictionary
//
//  Created by Matheus Xavier on 13/09/22.
//

import Foundation
import UIKit

protocol HistoryListDelegate: AnyObject {
    func handleDelete(word: HistoryModel)
}

class HistoryTableViewCell: UITableViewCell {
     
    // MARK: -> Properties
    
    weak var delegate: HistoryListDelegate!
    
    var state: WordFavStatus? {
        didSet {
            switch state {
            case .normal:
                self.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            case .fav:
                self.favBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            case .none:
                self.favBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            }
        }
    }
    
    var word: HistoryModel? {
        didSet {
            self.label.text = word?.word
            FavoritesDataModel().verifyIfItsFavorite(word: word!.word) { result, fav in
                if result {
                    self.state = .fav
                    if let fav = fav {
                        self.id = fav.id
                    }
                } else {
                    self.state = .normal
                }
            }
        }
    }
    
    var id: String?
    
    private let label: UILabel = {
       let lb = UILabel()
        lb.textAlignment = .left
        lb.textColor = dynamicColor
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.setDimensions(height: nil, width: 200)
        return lb
    }()
    
    private lazy var favBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "heart"), for: .normal)
        btn.setDimensions(height: 16, width: 19)
        btn.addTarget(self, action: #selector(handleToggleFavBtn), for: .touchUpInside)
        return btn
    }()
    
    private lazy var deleteBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        btn.setDimensions(height: 18, width: 18)
        btn.addTarget(self, action: #selector(handleToggleDeleteBtn), for: .touchUpInside)
        return btn
    }()
    
    // MARK: -> LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Selectors
    
    @objc func handleToggleFavBtn(){
        self.favBtn.setImage(UIImage(systemName: state == .normal ? "heart.fill" : "heart"), for: .normal)
        if state == .normal {
            FavoritesDataModel.uploadFavorite(word: word!.word)
        } else {
            FavoritesDataModel().deleteRegister(id: id!)
        }
        self.state = self.state == .fav ? .normal : .fav
    }
    
    @objc func handleToggleDeleteBtn(){
        self.delegate.handleDelete(word: word!)
    }
    
    // MARK: -> Configure/Helpers
    func configureUI(){
        self.backgroundColor = .systemGray6
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        self.addSubview(label)
        label.anchor(left: leftAnchor, paddingLeft: 15)
        label.centerY(inView: self)
        self.contentView.addSubview(favBtn)
        favBtn.anchor(right: safeAreaLayoutGuide.rightAnchor, paddingRight: 55)
        favBtn.centerY(inView: self)
        self.contentView.addSubview(deleteBtn)
        deleteBtn.anchor(right: favBtn.leftAnchor, paddingRight: 15)
        deleteBtn.centerY(inView: self)
    }
}
