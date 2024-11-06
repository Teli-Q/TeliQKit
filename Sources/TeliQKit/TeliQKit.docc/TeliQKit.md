# ``TeliQKit``

Framework for TeliQ

## Overview

Welcome to use TeliQKit. It is a framework for TeliQ, which is a Chat GUI.

> TeliQKit itself does not contain any network request functionality. It only handles the message sending and receiving information types related to the protocol. 
> 
> If you need to use the network request functionality, you need to implement it yourself.

## Example

Here is an example of how to use TeliQKit:

```swift
import TeliQKit

// First, build the message
let message = NCMessageBuilder.text("Hello, World!")
// Then, build the sender
let sender = NCSocketSender.sendPrivateMsg(userId: 123456, message: [message])
// And then, you can use your own network library to send the message
// via WebSocket
// For example: here is a websocket client
let client = WebSocketClient()
client.send(sender) // sender is a tuple (action: String, param: T)
// If you want to automatically handle the response, you can write a function like this:
func send<R: Codable>(sender: NCSocketSendParam) -> R {
    let action = sender.action
    let param = sender.param
    // send the message
    // and return the response
}
client.send<NCSocketSendReturn.SendMsgReturn>(sender: sender) // R is NCSocketSendReturn.SendMsgReturn
```

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
