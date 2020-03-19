# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## 2.0.0 - March 19, 2020

- `XpringClient` is removed from XpringKit. This class has been deprecated since 1.5.0. Clients should use `XRPClient` instead.
- Introduces a breaking change to `IlpClient` API.
	- `IlpClient.getBalance` now returns an `AccountBalance` instead of a protobuf generated `GetBalanceResponse`.
	- `IlpClient.send` has been changed to `IlpClient.sendPayment` to better align with other versions of the Xpring SDK
	- `IlpClient.sendPayment` now consumes a `PaymentRequest` instead of individual parameters, and now returns a `PaymentResult` instead of a protobuf generated `SendPaymentResponse`
- Fixed a bug in `DefaultIlpClient`. "Bearer " prefix was not being prepended to auth tokens, which caused authentication issues on Hermes.
	- "Bearer " prefix now gets prepended to auth tokens, if it is not already there

## 1.5.0 - March 9, 2020

This version introduces a public API to retrieve balances and send payments over ILP.
Additionally, the deployment target for XpringKit is now explicitly set to macOS 10.13 and higher.

### Changed
- `XpringClient` has been renamed to `XRPClient`, along with all associated classes, and should be used going forward.
	Top-level class `XpringClient` still exists alongside `XRPClient` and will be deprecated in the future.
- `getTransactionStatus` will now return `TransactionStatus.unknown` if the transaction hash provided references a transaction that is a partial payment or a non payment transaction. This behavior is only enabled when using the rippled protocol buffer implementation.

## 1.4.0 - Feb 28, 2020

This version uses new protocol buffers from rippled which have breaking changes in them. Specifically, the breaking changes include:
- Re-ordering and repurposing of fields in order to add additional layers of abstraction
- Change package from `rpc.v1` to `org.xrpl.rpc.v1`

This change is transparent to public API users. However, clients will need to connect to a rippled node which is built at any commit after [#3254](https://github.com/ripple/rippled/pull/3254).

## 1.3.0 - Feb 4, 2020
