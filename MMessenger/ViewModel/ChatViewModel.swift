//
//  ChatViewModel.swift
//  MMessenger
//
//  Created by Koushal, Kumar Ajitesh | Ajitesh | TID on 2021/03/15.
//

import Foundation

protocol ChatViewModelDelegate: class {
    func onSendCompleted(with text: String)
    func onMessageReceived()
}

final class ChatViewModel {
    private weak var delegate: ChatViewModelDelegate?
    
    private var lastSentMessage: String?
    private var total = 0
    
    var messagesArray: [String] = []
    
    var totalCount: Int {
        return total
    }
    
    init(delegate: ChatViewModelDelegate) {
        self.delegate = delegate
    }
    
    func sendMessage(text: String?) {
        guard let message = text else {
            return
        }
        lastSentMessage = message
        total += 1
        messagesArray.append(message)
        self.delegate?.onSendCompleted(with: message)
    }
    
    func receiveMessage() {
        guard let lastMessage = lastSentMessage else {
            return
        }
        total += 1
        messagesArray.append(lastMessage + " " + lastMessage)
        self.delegate?.onMessageReceived()
    }
}
