# ``TeliQKit``

Framework for TeliQ

## Overview

Welcome to use TeliQKit. It is a framework for TeliQ, which is a Chat GUI.

## Example

以下是一个使用 TeliQKit 的示例：

```swift
import TeliQKit

// 首先，构建消息
let message = NCMessageBuilder.text("Hello, World!")
// 然后，构建发送器
let sender = NCSocketSender.sendPrivateMsg(userId: 123456, message: [message])
// 然后，你可以使用你自己的网络库发送消息
// 通过 NCSocket(在 TeliQKit 中)
let socket = NCSocket(url: URL(string: "ws://localhost:8080/ws")!)
// 监听全部信息返回
socket.onText { text in
    print(text)
}
// 发送消息
socket.send(message: sender)
// 或者，直接使用 NCSocketRequest
let request = NCSocketRequest(socket: socket)
Task {
    let status = try await request.getStatus()
    print(status)
}
```

## Topics

### <!--@START_MENU_TOKEN@-->Group<!--@END_MENU_TOKEN@-->

- <!--@START_MENU_TOKEN@-->``Symbol``<!--@END_MENU_TOKEN@-->
