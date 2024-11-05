# ``TeliQKit``

<!--@START_MENU_TOKEN@-->Summary<!--@END_MENU_TOKEN@-->

## Overview

Welcome to use TeliQKit! It's a Swift Kit for TeliQ, which is a bot framework.

> TeliQKit itself does not contain any network request functionality. It only handles the message sending and receiving information types related to the protocol. 
> 
> If you need to use the network request functionality, you need to implement it yourself.

## Example

Here is an example of how to use TeliQKit:

```swift
import TeliQKit

let message = NCMessageBuilder.text("Hello, World!")
let sender = NCSocketSender.sendPrivateMsg(userId: 123456, message: [message])

// Then you can use your own network library to send the message
// via WebSocket
// You can use NCSocketSendReturn.SendMsgReturn to get the message response type
// For example: here is a websocket client
let client = WebSocketClient()
client.send(sender) // sender is a tuple (action: String, param: T)

// If you want to automatically handle the response, you can write a function like this:
func send<T: Codable, R: Codable>(action: String, param: T) -> R {
    // send the message
    // and return the response
}
client.send<NCSocketSendParam.SendPrivateMsg, NCSocketSendReturn.SendMsgReturn>(action: sender.action, param: sender.param)
```

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
