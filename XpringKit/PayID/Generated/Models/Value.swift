//
// Value.swift
//
// Generated by swagger-codegen
// https://github.com/swagger-api/swagger-codegen
//

import Foundation

public struct Value: Codable {

    public var amount: String
    public var scale: String

    public init(amount: String, scale: String) {
        self.amount = amount
        self.scale = scale
    }

}
