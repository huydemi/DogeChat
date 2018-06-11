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
  
  func setupNetworkCommunication() {
    // set up two uninitialized socket streams that won’t be automatically memory managed
    var readStream: Unmanaged<CFReadStream>?
    var writeStream: Unmanaged<CFWriteStream>?
    
    // bind read and write socket streams together and connect them to the socket of the host
    CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                       "localhost" as CFString,
                                       80,
                                       &readStream,
                                       &writeStream)
    
    inputStream = readStream!.takeRetainedValue()
    outputStream = writeStream!.takeRetainedValue()
    
    inputStream.schedule(in: .current, forMode: .commonModes)
    outputStream.schedule(in: .current, forMode: .commonModes)
    
    inputStream.open()
    outputStream.open()
  }
}
