/**
 * Copyright (c) 2017 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
 * distribute, sublicense, create a derivative work, and/or sell copies of the
 * Software in any work that is designed, intended, or marketed for pedagogical or
 * instructional purposes related to programming, coding, application development,
 * or information technology.  Permission for such use, copying, modification,
 * merger, publication, distribution, sublicensing, creation of derivative works,
 * or sale is expressly withheld.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

enum MessageSender {
  case ourself
  case someoneElse
}

class MessageTableViewCell: UITableViewCell {
  var messageSender: MessageSender = .ourself
  let messageLabel = Label()
  let nameLabel = UILabel()
  
  func apply(message: Message) {
    nameLabel.text = message.senderUsername
    messageLabel.text = message.message
    messageSender = message.messageSender
    setNeedsLayout()
  }
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    messageLabel.clipsToBounds = true
    messageLabel.textColor = .white
    messageLabel.numberOfLines = 0
    
    nameLabel.textColor = .lightGray
    nameLabel.font = UIFont(name: "Helvetica", size: 10) //UIFont.systemFont(ofSize: 10)

    clipsToBounds = true
    
    addSubview(messageLabel)
    addSubview(nameLabel)
  }
  
  class func height(for message: Message) -> CGFloat {
    let maxSize = CGSize(width: 2*(UIScreen.main.bounds.size.width/3), height: CGFloat.greatestFiniteMagnitude)
    let nameHeight = message.messageSender == .ourself ? 0 : (height(forText: message.senderUsername, fontSize: 10, maxSize: maxSize) + 4 )
    let messageHeight = height(forText: message.message, fontSize: 17, maxSize: maxSize)
    
    return nameHeight + messageHeight + 32 + 16
  }
  
  private class func height(forText text: String, fontSize: CGFloat, maxSize: CGSize) -> CGFloat {
    let font = UIFont(name: "Helvetica", size: fontSize)!
    let attrString = NSAttributedString(string: text, attributes:[NSFontAttributeName: font,
                                                                  NSForegroundColorAttributeName: UIColor.white])
    let textHeight = attrString.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, context: nil).size.height

    return textHeight
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
