//
//  Key.swift
//  XKey
//
//  Created by AtsuyaSato on 2018/05/12.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation

internal struct Key: Hashable {
    public var hashValue: Int {
        return Int(keyCode)
    }

    public let keyCode: UInt16
    public let characters: String?
    public let charactersIgnoringModifiers: String?
    public let modifierFlags: NSEvent.ModifierFlags

    init(event: NSEvent) {
        self.keyCode = event.keyCode
        self.characters = event.characters
        self.charactersIgnoringModifiers = event.charactersIgnoringModifiers
        self.modifierFlags = event.modifierFlags
    }

    public static func == (lhs: Key, rhs: Key) -> Bool {
        return lhs.keyCode == rhs.keyCode
    }
}

extension Array where Element == Key {
    mutating func remove(object: Element) {
        if let index = index(of: object) {
            remove(at: index)
        }
    }
    mutating func insert(_ newElement: Key) {
        if !contains(newElement) {
            append(newElement)
        }
    }
}
