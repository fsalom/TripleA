[![Swift](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-orange?style=flat-square)](https://img.shields.io/badge/Swift-5.3_5.4_5.5_5.6-Orange?style=flat-square)
[![Swift Package Manager](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)](https://img.shields.io/badge/Swift_Package_Manager-compatible-orange?style=flat-square)


# tripleA: Async Await API

## ✍️ About
tripleA is an acronym for Async Await API in swift. It is a package created to simplify task of using REST API. It is main purpose is to be used with Rudo APIs.

## How it works

**Container.swift**
```swift
let authManager = AuthManager(baseURL: "This is base URL",
							  clientId: "This is the client ID",
							  clientSecret: "This is the client Secret")

let network = Network(authManager: authManager)
```

## 👨‍💻 Author
Fernando Salom
