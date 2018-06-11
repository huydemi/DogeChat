//
//  ChatRoom.swift
//  DogeChat
//
//  Created by Dang Quoc Huy on 6/11/18.
//  Copyright © 2018 Luke Parham. All rights reserved.
//

import UIKit

protocol ChatRoomDelegate: class {
  func receivedMessage(message: Message)
}

class ChatRoom: NSObject {
  
  weak var delegate: ChatRoomDelegate?
  
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
    
    inputStream.delegate = self
    
    inputStream.schedule(in: .current, forMode: .commonModes)
    outputStream.schedule(in: .current, forMode: .commonModes)
    
    inputStream.open()
    outputStream.open()
  }
  
  func joinChat(username: String) {
    // construct message using the simple chat room protocol
    let data = "iam:\(username)".data(using: .ascii)!
    // save off the name that gets passed in so can use it when sending chat messages later
    self.username = username
    
    // write message to the output stream
    _ = data.withUnsafeBytes { outputStream.write($0, maxLength: data.count) }
  }
}

extension ChatRoom: StreamDelegate {
  
  func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
    switch eventCode {
    case Stream.Event.hasBytesAvailable:
      print("new message received")
      readAvailableBytes(stream: aStream as! InputStream)
    case Stream.Event.endEncountered:
      print("new message received")
    case Stream.Event.errorOccurred:
      print("error occurred")
    case Stream.Event.hasSpaceAvailable:
      print("has space available")
    default:
      print("some other event...")
      break
    }
  }
  
  private func readAvailableBytes(stream: InputStream) {
    // set up a buffer, into which can read the incoming bytes
    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
    
    // loop for as long as the input stream has bytes to be read
    while stream.hasBytesAvailable {
      // read bytes from the stream and put them into the buffer
      let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
      
      // If returns a negative value, some error occurred
      if numberOfBytesRead < 0 {
        if let _ = stream.streamError {
          break
        }
      }
      
      //Construct the Message object
      if let message = processedMessageString(buffer: buffer, length: numberOfBytesRead) {
        //Notify interested parties
        delegate?.receivedMessage(message: message)
      }
    }
  }
  
  private func processedMessageString(buffer: UnsafeMutablePointer<UInt8>,
                                      length: Int) -> Message? {
    // initialize a String using the buffer and length that's passed in
    guard let stringArray = String(bytesNoCopy: buffer,
                                   length: length,
                                   encoding: .ascii,
                                   freeWhenDone: true)?.components(separatedBy: ":"),
      let name = stringArray.first,
      let message = stringArray.last else {
        return nil
    }
    // figure out if you or someone else sent the message based on the name
    let messageSender:MessageSender = (name == self.username) ? .ourself : .someoneElse
    // construct a Message with gathered parts and return it.
    return Message(message: message, messageSender: messageSender, username: name)
  }
}
