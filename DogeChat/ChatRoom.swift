//
//  ChatRoom.swift
//  DogeChat
//
//  Created by Dang Quoc Huy on 6/11/18.
//  Copyright © 2018 Luke Parham. All rights reserved.
//

import UIKit

class ChatRoom: NSObject {
  // input stream to receive message
  // output stream to send messages
  var inputStream: InputStream!
  var outputStream: OutputStream!
  
  // name of the current user
  var username = ""
  
  // limit data can be sent in any single message.
  let maxReadLength = 4096
}
