# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

#### Added
- `xrpToDrops` and `dropsToXrp` conversion utilities added to `Utils`

## 3.0.0 - March 27, 2020

This release contains serveral breaking changes that are required in order to:
- Support more protocols than just XRP Ledger (ILP, etc)
- Migrate the library to use the rippled node directly

Please note the changes and deprecations below. 

#### Removed

- All legacy services are removed from XpringKit. All RPC's go through [rippled's protocol buffer API](https://github.com/ripple/rippled/pull/3254).
- `getTransactionStatus` is removed. Please use `getPaymentStatus` instead.

#### Changed
- `XRPClient` requires a new parameter in its constructor that identifies the network it is attached to.
- `XRPClient` now uses [rippled's protocol buffer API](https://github.com/ripple/rippled/pull/3254) rather than the legacy API. Users who wish to use the legacy API should pass `false` for `useNewProtocolBuffers` in the constructor.
- `IlpClient` methods now throw `IlpError`s if something goes wrong during the call (either client side or server side).  This is only breaking if users are handling special error cases, which were previously `RPCError`s

#### Added
- A new `getPaymentStatus` is added which retrieves the status of payment transactions.

#### Deprecated
- `getTransactionStatus` is deprecated. Please use `getPaymentStatus` instead.

## 2.0.0 - March 19, 2020
- Add a new `paymentHistory` method to `XRPClient`. This method allows clients to retrieve payment history for an address.
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
