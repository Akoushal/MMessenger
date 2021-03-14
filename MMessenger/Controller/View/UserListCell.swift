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
    static let UserImageSizeConstant: CGFloat = 50
    
    lazy var userName: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.font = UIFont.boldSystemFont(ofSize: 20)
        return lbl
    }()
    
    lazy var userImageView: UIImageView = {
        let imgV = UIImageView()
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        accessoryType = .disclosureIndicator
        // Add the UI components
        contentView.addSubview(userImageView)
        contentView.addSubview(userName)
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: UserListCell.LeadingAnchorConstant),
            userImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: UserListCell.TopAnchorConstant),
            userImageView.widthAnchor.constraint(equalToConstant: UserListCell.UserImageSizeConstant),
            userImageView.heightAnchor.constraint(equalToConstant: UserListCell.UserImageSizeConstant),
            
            userName.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: UserListCell.LeadingAnchorConstant),
            userName.centerYAnchor.constraint(equalTo: userImageView.centerYAnchor),
            userName.widthAnchor.constraint(equalToConstant: UserListCell.WidthConstant)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with user: User?) {
        if let avatarUrl = user?.avatarUrl {
            userImageView.downloaded(from: avatarUrl)
        }
        if let user = user, let username = user.login?.capitalized {
            userName.text = "@\(username)"
        }
    }
}
