Create Websocket connection

* endpoint
* with params: token - gchat token
* example: https://chat.ghtk.vn?token=c_ren8zytea6ygcyfac8zfsjxna1qhzeuycowuwfho8hkcyhoefaoj2zhwlejcdg7y

Client websocket protocol

* Using `jsonrpc` websocket protocol
* Request Object

```
jsonrpc: string - default is "2.0"
method: string - is one of those method:
  CALL    = "CALL"
  CANCEL  = "CANCEL"
  REJECT  = "REJECT"
  LEAVE   = "LEAVE"
  ACCEPT  = "ACCEPT"
  HANGUP  = "HANGUP"
  PING    = "PING"
  JOIN    = "JOIN"
  TRICKLE = "TRICKLE"
  OFFER   = "OFFER"
  ANSWER  = "ANSWER"

  Those method were seperate into 3 groups:
  1. Business methods, includes: CALL, CANCEL, REJECT, LEAVE, ACCEPT, HANGUP.
  2. Media methods, includes: JOIN, TRICKLE, OFFER, ANSWER.
  3. Keep ws connection: PING.

params: json - params will be like this
  {
    originId: "user_123",
    destinationId: "user_456",
    callType: "DIRECT",
    payload: {}
  }
  callType has 2 options: DIRECT, GROUP

Example:
{
  jsonrpc: "2.0",
  method: "CALL",
  params: {
    originId: "user_123",
    destinationId: "user_456",
    callType: "DIRECT"
    payloadl: {
      channelId: "1x2y3z"
    }
  }
}

```
+ Response Object
```
jsonrpc: string - default value is "2.0"
params: json

Example
REQUEST_CALL message
{
  jsonrpc: "2.0",
  method: "request_call",
  params: {
    originId: "user_123",
    destinationId: "user_456",
    conversationId: "1:,
    callType: "DIRECT",
    channelId: "1x2y3z",
  }
}
```

WebRTC
Create 2 WebRTCPeerConnection, one is responsiable for publishing media, the other is responsible for subscribing media