//
//  TransactionData.swift
//  Driip
//
//  Created by Denis Angell on 4/1/18.
//  Copyright © 2018 Harp Angell. All rights reserved.
//

import Foundation

public enum TransactionData {
    private static let ledgerIndex: Int = 0
    private static let timeStamp: Int = 0
    private static let hash: String = ""
    private static let transactionIndex: Int = 0
    private static let transactionResult: String = ""
    private static let transactionType: String = ""
    private static let sender: String = ""
    private static let to: String = ""
    private static let value: String = ""
    private static let fee: Int = 0
    private static let sequence: Int = 0
    private static let validated: Bool = false
}

public enum TransactionResult: String {
    case tesSUCCESS
    case tecCLAIM
    case tecCRYPTOCONDITION_ERROR
    case tecDIR_FULL
    case tecDUPLICATE
    case tecDST_TAG_NEEDED
    case tecEXPIRED
    case tecFAILED_PROCESSING
    case tecFROZEN
    case tecHAS_OBLIGATIONS
    case tecINSUF_RESERVE_LINE
    case tecINSUF_RESERVE_OFFER
    case tecINSUFFICIENT_RESERVE
    case tecINTERNAL
    case tecINVARIANT_FAILED
    case tecNEED_MASTER_KEY
    case tecNO_ALTERNATIVE_KEY
    case tecNO_AUTH
    case tecNO_DST
    case tecNO_DST_INSUF_XRP
    case tecNO_ENTRY
    case tecNO_ISSUER
    case tecKILLED
    case tecNO_LINE
    case tecNO_LINE_INSUF_RESERVE
    case tecNO_LINE_REDUNDANT
    case tecNO_PERMISSION
    case tecNO_REGULAR_KEY
    case tecNO_TARGET
    case tecOVERSIZE
    case tecOWNERS
    case tecPATH_DRY
    case tecPATH_PARTIAL
    case tecTOO_SOON
    case tecUNFUNDED
    case tecUNFUNDED_ADD
    case tecUNFUNDED_PAYMENT
    case tecUNFUNDED_OFFER
}

public enum TransactionType: String {
    case Payment
    case EscrowCreate
    case EscrowCancel
    case EscrowFinish
}

public struct XRPTransactionData {

    var ledgerIndex: Int?
    var timeStamp: Int?
    var hash: String?
    var transactionIndex: Int?
    var transactionResult: TransactionResult?
    var transactionType: TransactionType?
    var sender: String?
    var to: String?
    var value: String?
    var fee: Int?
    var sequence: Int?
    var validated: Bool?

    init(
        ledgerIndex: Int?,
        timeStamp: Int?,
        hash: String?,
        transactionIndex: Int?,
        transactionResult: TransactionResult?,
        transactionType: TransactionType?,
        sender: String?,
        to: String?,
        value: String?,
        fee: Int?,
        sequence: Int?,
        validated: Bool?) {

        self.ledgerIndex = ledgerIndex
        self.timeStamp = timeStamp
        self.hash = hash
        self.transactionIndex = transactionIndex
        self.transactionResult = transactionResult
        self.transactionType = transactionType
        self.sender = sender
        self.to = to
        self.value = value
        self.fee = fee
        self.sequence = sequence
        self.validated = validated
    }

    init() {
        ledgerIndex = nil
        timeStamp = nil
        hash = nil
        transactionIndex = nil
        transactionResult = nil
        transactionType = nil
        sender = nil
        to = nil
        value = nil
        fee = nil
        sequence = nil
        validated = nil
    }

    init(dict: [String: AnyObject]) {
        ledgerIndex = dict["ledgerIndex"] as? Int ?? 0
        timeStamp = dict["timeStamp"] as? Int ?? 0
        hash = dict["hash"] as? String ?? ""
        transactionIndex = dict["transactionIndex"] as? Int ?? 0
        let transactionResultString = dict["transactionResult"] as? String ?? ""
        transactionResult = TransactionResult(rawValue: transactionResultString)
        let transactionTypeString = dict["transactionType"] as? String ?? ""
        transactionType = TransactionType(rawValue: transactionTypeString)
        sender = dict["sender"] as? String ?? ""
        to = dict["to"] as? String ?? ""
        value = dict["value"] as? String ?? ""
        fee = dict["fee"] as? Int ?? 0
        sequence = dict["sequence"] as? Int ?? 0
        validated = dict["validated"] as? Bool ?? false
    }
}
