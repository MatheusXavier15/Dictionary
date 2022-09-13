//
//  WordListTableViewCell.swift
//  Dictionary
//
//  Created by Matheus Xavier on 13/09/22.
//

import UIKit

class WordListTableViewCell: UITableViewCell {
    // MARK: -> Properties
    
    var word: String? {
        didSet {
            self.label.text = word
        }
    }
    
    private let label: UILabel = {
       let lb = UILabel()
        lb.textAlignment = .left
        lb.textColor = dynamicColor
        lb.font = .systemFont(ofSize: 18, weight: .semibold)
        lb.setDimensions(height: nil, width: 200)
        return lb
    }()

    
    // MARK: -> LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: -> Configure/Helpers
    func configureUI(){
        self.backgroundColor = .systemGray6
        self.selectionStyle = .none
        self.accessoryType = .disclosureIndicator
        self.addSubview(label)
        label.anchor(left: leftAnchor, paddingLeft: 15)
        label.centerY(inView: self)
    }
}
