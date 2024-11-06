# ``TeliQKit``

Framework for TeliQ

## Overview

Welcome to use TeliQKit. It is a framework for TeliQ, which is a Chat GUI.

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

```

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
