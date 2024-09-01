<p align="center">
  <a href="https://github.com/agescura/swift-urlrequest-builder">
    <img src="https://img.shields.io/badge/Release-v0-red?style=flat-square"/>
  </a>
  <a href="https://github.com/agescura/swift-urlrequest-builder">
    <img src="https://img.shields.io/badge/Platform_Compatibility-iOS_iPadOS_macOS_watchOS_tvOS_visionOS-yellowgreen?style=flat-square" alt="Swift Package Manager Platforms" />
  </a>
  <a href="https://github.com/agescura/swift-urlrequest-builder">
    <img src="https://img.shields.io/badge/Swift-5.4_5.5_5.6_5.7_5.8_5.9-red?style=flat-square" alt="Swift Versions" />
  </a>
  <a href="https://github.com/agescura/swift-urlrequest-builder/blob/master/LICENSE">
    <img src="https://img.shields.io/badge/License-MIT-yellowgreen?style=flat-square"/>
  </a>
</p>

# Swift UrlRequest Builder

A library extending a URLRequest instance in a ergonomic, scalable, composable and testable manner.

## Motivation

Using Foundation framework we have the URLSession class, successor to NSURLSession, which is responsible for making requests in the Internet layer.

We have two ways to make calls, a simple one by passing a URL and another, more complex, with URLRequest.

```swift
    try await URLSession
        .shared
        .data(
            from: URL(
                string: "https://api.github.com/users/agescura/repos"
            )!
        )
```


```swift
    var request = URLRequest(
        url: url,
        cachePolicy: .returnCacheDataDontLoad
    )
    request.httpMethod = "GET"
    request.httpBody = nil
    try await URLSession.shared.data(for: request)
```

In small applications that do not make many calls, it does not make much sense to ergonomicize the system. But, as we have to manage many calls, the complexity of the system will appear.



## Functionalities

### Simplify UrlRequests

### Builders for simplifying even more

## Use Cases

### Mappable (decoding and encoding)

### CRUD
