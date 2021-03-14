//
//  ChatCell.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/15.
//

import UIKit

class ChatCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with message: String, row: Int) {
        if row % 2 == 0 {
            contentView.addSubview(showOutgoingMessage(text: message))
        } else {
            contentView.addSubview(showIncomingMessage(text: message))
        }
    }
    
    func showOutgoingMessage(text: String) -> UIView {
        let outgoingMessage = UIView(frame: self.frame)
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = text
        
        let constraintRect = CGSize(width: 0.66 * frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font ?? 20],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleImageSize = CGSize(width: label.frame.width + 28,
                                     height: label.frame.height + 20)
        
        let outgoingMessageView = UIImageView(frame:
                                                CGRect(x: frame.width - bubbleImageSize.width + 80,
                   y: 0,
                   width: bubbleImageSize.width,
                   height: bubbleImageSize.height))
        
        let bubbleImage = UIImage(named: "rightBubble")?
            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        
        outgoingMessageView.image = bubbleImage
        outgoingMessage.addSubview(outgoingMessageView)
        
        label.center = outgoingMessageView.center
        outgoingMessage.addSubview(label)
        return outgoingMessage
    }

    func showIncomingMessage(text: String) ->  UIView {
        let incomingMessage = UIView(frame: self.frame)
        let label =  UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.text = text
        
        let constraintRect = CGSize(width: 0.66 * frame.width,
                                    height: .greatestFiniteMagnitude)
        let boundingBox = text.boundingRect(with: constraintRect,
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: label.font ?? 20],
                                            context: nil)
        label.frame.size = CGSize(width: ceil(boundingBox.width),
                                  height: ceil(boundingBox.height))
        
        let bubbleImageSize = CGSize(width: label.frame.width + 28,
                                     height: label.frame.height + 20)
        
        let incomingMessageView = UIImageView(frame:
            CGRect(x: 20,
                   y: 0,
                   width: bubbleImageSize.width,
                   height: bubbleImageSize.height))
        
        let bubbleImage = UIImage(named: "leftBubble")!
            .resizableImage(withCapInsets: UIEdgeInsets(top: 17, left: 21, bottom: 17, right: 21),
                            resizingMode: .stretch)
            .withRenderingMode(.alwaysTemplate)
        
        incomingMessageView.image = bubbleImage
        addSubview(incomingMessageView)
        
        label.center = incomingMessageView.center
        addSubview(label)
        return incomingMessage
    }
}
