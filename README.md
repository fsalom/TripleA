[![Swift](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-Orange?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)


# TripleA: Async Await API

## ✍️ About
TripleA is an acronym for Async Await API in swift. It is a package created to simplify task of using REST API.
It is main purpose is to be used with Rudo APIs.  At the core of the system is [`URLSession`](https://developer.apple.com/documentation/foundation/urlsession) and the [`URLSessionTask`](https://developer.apple.com/documentation/foundation/urlsessiontask) subclasses. 
TripleAAA wraps these APIs and provide a way to simplify and reduce code to make it easier to use calls to APIs

## 📦 Installation 

#### Swift Package Manager
To install TripleA using Swift Package Manager you can follow the tutorial published by Apple using the URL for the TipleAAA repo with the current version:

In Xcode, select “File” → “Swift Packages” → “Add Package Dependency”

Enter https://github.com/fsalom/TripleA

## 🦾 Core elements
There are 4 main pieces in this system. Each one of them is responsable of their own area.

- **Endpoint**: Its the way endpoint request are built for TripleA.
- **AuthManager**: responsable of managing tokens and refresh them.
- **Network**: responsable of making calls and parse objects.
- **TokenStore**: responsable of storing token information (by default UserDefaults)

## 🚀 Usage non authorized API
As an example we will use https://coincap.io and their crypto list. This API is free to use and do not have any kind of authentication system

### Defining dependency injection
**Container.swift**
```swift
Network(baseURL: "https://api.coincap.io/v2/")
```

### DTO declaration
**CryptoDTO**
```swift
struct ListDTO: Codable {
    let data : [CryptoDTO]
}

struct CryptoDTO: Codable {
    let name : String!
    let priceUsd : String!
    let changePercent24Hr : String!
}
```

### Endpoint
**CryptoAPI**
```swift
enum CryptoAPI {
    case assets
    var endpoint: Endpoint {
        get {
            switch self {
            case .assets:
                return Endpoint(path: "assets", httpMethod: .get)
            }
        }
    }
}
```

### Making request
**ViewModel**
```swift
Task{
    do {
        _ = try await network.load(endpoint: CryptoAPI.assets.endpoint, of: ListDTO.self)
    } catch {

    }
}
```

## 🔒 Usage authorized API
An example for OAUTH2 grant_type = password

### Defining dependency injection
**Container.swift**
```swift
    let storage = AuthTokenStoreDefault()
    let remoteDataSource = OAuthGrantTypePasswordManager(storage: storage, startController: getLoginController(), refreshTokenEndpoint: OAuthAPI.refresh(parametersRefresh).endpoint, tokensEndPoint: OAuthAPI.login(parametersLogin).endpoint)
    let authManager = AuthManager(storage: storage,
                                  remoteDataSource: remoteDataSource,
                                  parameters: [:])
    static let network = Network(baseURL: "https://dashboard.rudo.es/", authManager: authManager)
```

### DTO declaration
**UserDTO**
```swift
struct UserDTO: Codable {
    let firstName,
        email: String

    private enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case email = "email"
    }
}
```

### Endpoint
**OauthAPI**
```swift
enum OAuthAPI {
    case login([String: Any])
    case refresh([String: Any])
    case me
    var endpoint: Endpoint {
        get {
            switch self {
            case .login(let parameters):
                return Endpoint(baseURL: "https://dashboard.rudo.es/", path: "auth/token/", httpMethod: .post, parameters: parameters)
            case .refresh(let parameters):
                return Endpoint(baseURL: "https://dashboard.rudo.es/", path: "auth/token/", httpMethod: .post, parameters: parameters)
            case .me:
                return Endpoint(path: "users/me/", httpMethod: .get)
            }
        }
    }
}
```

### Usage
**Login**
```swift
                let parameters = ["grant_type": "password",
                                  "username": "XXXX",
                                  "password": "XXXX",
                                  "client_id": "XXXX",
                                  "client_secret": "XXXX"]
                try await Container.network.getNewToken(with: parameters)
```

**Calls**
```swift
            return try await Container.network.loadAuthorized(endpoint: OAuthAPI.me.endpoint, of: UserDTO.self)
```

## 📚 Examples
This repo includes an iOS example, which is attached to [Example.xcodeproj](https://github.com/fsalom/TripleA/tree/main/Example)

## 👨‍💻 Author
[Fernando Salom](https://github.com/fsalom)
