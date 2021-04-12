//
//  ChatRoomTableViewCell.swift
//  iphone-engineer-matching
//
//  Created by 徳富博 on 2021/04/07.
//

import UIKit

class ChatRoomTableViewCell: UITableViewCell {
    var message: Message? {
        didSet {
            if let message = message {
                messageTextView.text = message.message
                let witdh = estimateFrameForTextView(text: message.message).width + 20
                messageTextViewWidthConstraint.constant = witdh
                
                dateLabel.text = dateFormatterForDateLabel(date: message.createdAt.dateValue())
            }
        }
    }
        
    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var messageTextView: UITextView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var messageTextViewWidthConstraint: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        userImage.layer.cornerRadius = 30
        messageTextView.layer.cornerRadius = 15
        backgroundColor = .clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    private func estimateFrameForTextView(text: String) -> CGRect {
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
        
        return NSString(string: text).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
    }
    
    private func dateFormatterForDateLabel(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        formatter.locale = Locale(identifier: "ja_JP")
        return formatter.string(from: date)
    }
    
}
