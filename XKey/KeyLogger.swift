//
//  KeyLogger.swift
//  XKey
//
//  Created by AtsuyaSato on 2018/05/12.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation

extension XKey {
    public enum KeyLogger {
        case keyDown(KeyLoggerType)
        case keyUp(KeyLoggerType)
    }

    public enum KeyLoggerType {
        case keyCode
        case characters
        case charactersIgnoringModifiers
    }
}
