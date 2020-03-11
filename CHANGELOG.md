# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Add a new `paymentHistory` method to `XRPClient`. This method allows clients to retrieve payment history for an address.

### Removed

- `XpringClient` is removed from XpringKit. This class has been deprecated since 1.5.0. Clients should use `XRPClient` instead.

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
