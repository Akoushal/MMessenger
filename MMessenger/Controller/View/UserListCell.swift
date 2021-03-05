//
//  UserListCell.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/02.
//

import UIKit

class UserListCell: UITableViewCell {
    
    static let LeadingAnchorConstant: CGFloat = 25
    static let TrailingAnchorConstant: CGFloat = 50
    static let TopAnchorConstant: CGFloat = 25
    static let BottomAnchorConstant: CGFloat = 25
    static let WidthConstant: CGFloat = 200
    
    lazy var userName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .gray
        // Add the UI components
        contentView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            userName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UserListCell.LeadingAnchorConstant),
            userName.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UserListCell.TopAnchorConstant),
            userName.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -UserListCell.BottomAnchorConstant),
            userName.widthAnchor.constraint(equalToConstant: UserListCell.WidthConstant)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User?) {
        if let user = user {
            userName.text = user.login
        }
    }
}

