//
//  JSONValue.swift
//
//  Created by BJ Homer on 2/26/20.
//

import Foundation

@dynamicMemberLookup
public struct JSONObject: Codable, Hashable {
    private var dict: [String: JSONValue]

    public init(_ dict: [String: Any]) throws {
        self.dict = try dict.mapValues({ try JSONValue($0) })
    }

    public init(_ dict: [String: JSONValue]) {
        self.dict = dict
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(dict)
    }

    public init() {
        self.dict = [:]
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.dict = try container.decode([String: JSONValue].self)
    }

    public init(with data: Data) throws {
        let any = try JSONSerialization.jsonObject(with: data)
        guard let dict = any as? [String: Any] else {
            throw JSONValue.JSONError.valueIsNotJSON(any)
        }

        try self.init(dict)
    }

    public init(with string: String) throws {
        let data = Data(string.utf8)
        try self.init(with: data)
    }

    public subscript(key: String) -> JSONValue? {
        get { return dict[key] }
        set { dict[key] = newValue }
    }

    public subscript(dynamicMember key: String) -> JSONValue? {
        return dict[key]
    }

    public var rawValue: [String: Any] {
        return dict.mapValues({ $0.rawValue })
    }

    public var keys: [String] {
        return Array(dict.keys)
    }

    public var values: [JSONValue] {
        return Array(dict.values)
    }
}

extension JSONObject: CustomStringConvertible {
    public var description: String {
        return description(padding: 0)
    }

    fileprivate func description(padding: Int) -> String {
        let values = dict
            .mapValues({ $0.description(padding: padding + 2) })
            .map { "\"\($0.0)\": \($0.1)"}
        if dict.count <= 1 {
            let inlineValues = values.joined(separator: ", ")
            return "{ \(inlineValues) }"
        }

        let paddingStr = String(repeating: " ", count: padding)
        let separatedValues = values.map { paddingStr + "  " + $0 }
            .sorted()
            .joined(separator: ",\n")
        return "{\n\(separatedValues)\n\(paddingStr)}"
    }
}

extension JSONObject: CustomDebugStringConvertible {
    public var debugDescription: String {
        return description
    }
}

extension JSONObject: CustomReflectable {
    public var customMirror: Mirror { Mirror(self, children: []) }
}

extension JSONObject: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSONValue)...) {
        let dict = Dictionary(uniqueKeysWithValues: elements)
        self = JSONObject(dict)
    }
}


// MARK: -
@dynamicMemberLookup
public enum JSONValue: Codable, Hashable {
    case int(Int)
    case double(Double)
    case string(String)
    case bool(Bool)
    case null
    case array([JSONValue])
    case object(JSONObject)

    enum JSONError: Error {
        case valueIsNotJSON(Any)
    }

    public init(_ value: Any) throws {
        switch value {
        case let x as NSNumber where x.isBool: self = .bool(x.boolValue)
        case let x as Int: self = .int(x)
        case let x as Double: self = .double(x)
        case let x as String: self = .string(x)
        case let x as Bool: self = .bool(x)
        case is NSNull: self = .null
        case let x as [Any]: self = .array(try x.map({ try JSONValue($0) }))
        case let x as [String: Any]: self = .object(try JSONObject(x))
        case let x as Any? where x == nil: self = .null
        default: throw JSONError.valueIsNotJSON(value)
        }
    }

    public func encode(to encoder: Encoder) throws {
        switch self {
        case .int(let x):
            var container = encoder.singleValueContainer()
            try container.encode(x)
        case .double(let x):
            var container = encoder.singleValueContainer()
            try container.encode(x)
        case .string(let x):
            var container = encoder.singleValueContainer()
            try container.encode(x)
        case .bool(let x):
            var container = encoder.singleValueContainer()
            try container.encode(x)
        case .null:
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        case .array(let values):
            var container = encoder.singleValueContainer()
            try container.encode(values)
        case .object(let obj):
            var container = encoder.singleValueContainer()
            try container.encode(obj)
        }
    }

    public init(from decoder: Decoder) throws {

        // Try single value
        let container = try decoder.singleValueContainer()
        if let int = try? container.decode(Int.self) {
            self = .int(int)
        }
        else if let double = try? container.decode(Double.self) {
            self = .double(double)
        }
        else if let string = try? container.decode(String.self) {
            self = .string(string)
        }
        else if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        }
        else if container.decodeNil() {
            self = .null
        }
        else if let array = try? container.decode([JSONValue].self) {
            self = .array(array)
        }
        else if let obj = try? container.decode(JSONObject.self) {
            self = .object(obj)
        }
        else {
            throw DecodingError.typeMismatch(JSONValue.self, .init(codingPath: container.codingPath, debugDescription: "Value is not a JSON type"))
        }
    }

    public subscript(dynamicMember path: String) -> JSONValue? {
        if case .object(let obj) = self {
            return obj[path]
        }
        return nil
    }

    public subscript(index: Int) -> JSONValue? {
        if case .array(let array) = self {
            return array[index]
        }
        return nil
    }

    public var rawValue: Any {
        switch self {
        case .int(let x): return x
        case .double(let x): return x
        case .bool(let x): return x
        case .string(let x): return x
        case .null: return NSNull()
        case .array(let x): return x.map({ $0.rawValue })
        case .object(let x): return x.rawValue
        }


    }

}

extension JSONValue: ExpressibleByNilLiteral {
    public init(nilLiteral: ()) { self = .null }
}

extension JSONValue: ExpressibleByFloatLiteral {
    public init(floatLiteral value: Double) { self = .double(value) }
}

extension JSONValue: ExpressibleByStringLiteral {
    public init(stringLiteral value: String) { self = .string(value) }
}

extension JSONValue: ExpressibleByIntegerLiteral {
    public init(integerLiteral value: Int) { self = .int(value) }
}

extension JSONValue: ExpressibleByBooleanLiteral {
    public init(booleanLiteral value: Bool) { self = .bool(value) }
}

extension JSONValue: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: JSONValue...) { self = .array(elements) }
}

extension JSONValue: ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (String, JSONValue)...) {
        let dict = Dictionary(uniqueKeysWithValues: elements)
        let obj = JSONObject(dict)
        self = .object(obj)
    }
}

extension JSONValue: CustomStringConvertible {
    public var description: String {
        return self.description(padding: 0)
    }

    fileprivate func description(padding: Int) -> String {
        switch self {
        case .int(let x): return x.description
        case .string(let x): return "\"\(x)\""
        case .double(let x): return x.description
        case .bool(let x): return x.description
        case .null: return "null"
        case .array(let values):
            let valueStrings = values.map({ $0.description(padding: padding )}).joined(separator: ", ")
            return "[\(valueStrings)]"
        case .object(let obj):
            return obj.description(padding: padding)
        }
    }
}

extension JSONValue: CustomDebugStringConvertible {
    public var debugDescription: String { description }
}

extension JSONValue: CustomReflectable {
    public var customMirror: Mirror { Mirror(self, children: []) }
}

extension JSONValue {
    public init(with jsonData: Data) throws {
        let jsonObj = try JSONSerialization.jsonObject(with: jsonData)
        try self.init(jsonObj)
    }
}


private extension NSNumber {
    var isBool: Bool {
        let objcTypeCode = UnicodeScalar(UInt8(self.objCType.pointee))
        return objcTypeCode == "c"
    }
}
