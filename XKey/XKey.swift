//
//  XKey.swift
//  XKey
//
//  Created by AtsuyaSato on 2018/05/12.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation

public protocol XKeyDelegate: class {
    func xKey(_ xKey: XKey, logger log: String)
}

public class XKey {
    public static let shared = XKey()
    public static var enabled = true
    public static var logger: [KeyLogger] = []
    public weak var delegate: XKeyDelegate?

    private var shouldForceKeyDownCall = false

    private var keyRepeatTime: Int {
        var keyRepeatTime: Int = 30

        if let globalDomain = UserDefaults.standard.persistentDomain(forName: UserDefaults.globalDomain), let keyRepeatString = globalDomain["KeyRepeat"] as? String, let keyRepeat = Int(keyRepeatString) {
            keyRepeatTime = Int(keyRepeat * 15)
        }
        return keyRepeatTime
    }
    private var keysDownList = [Key]() // For storing key orders.
    private var lastKey: Key? {
        return keysDownList.last
    }
    private var timestamp: TimeInterval {
        var host_clock = clock_serv_t()
        let status = host_get_clock_service(mach_host_self(), SYSTEM_CLOCK, &host_clock)
        if status == KERN_FAILURE { return 0.0 }

        var now = mach_timespec_t()
        clock_get_time(host_clock, &now)

        return TimeInterval(now.tv_sec) + (TimeInterval(now.tv_nsec) / 1000000000.0)
    }

    public func extend() {
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp) { [weak self] event in
            guard let `self` = self else {
                return event
            }
            self.keyLogging(event: event)

            let key = Key(event: event)
            let lastKey = self.lastKey

            self.keysDownList.remove(object: key)
            self.shouldForceKeyDownCall = false

            if lastKey == key,
                XKey.enabled,
                let repeatKey = self.lastKey,
                let nextEvent = self.createKeyEvent(event: event, key: repeatKey) {
                self.shouldForceKeyDownCall = true

                NSApplication.shared.sendEvent(nextEvent)
            }

            return event
        }

        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyDown) { [weak self] event in
            guard let `self` = self else {
                return event
            }
            self.keyLogging(event: event)

            let key = Key(event: event)
            if self.lastKey != key {
                self.shouldForceKeyDownCall = false
            }
            self.keysDownList.insert(key)

            if XKey.enabled,
                self.shouldForceKeyDownCall {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.keyRepeatTime)) {
                    if self.shouldForceKeyDownCall,
                        XKey.enabled,
                        let repeatKey = self.lastKey,
                        let nextEvent = self.createKeyEvent(event: event, key: repeatKey) {
                        NSApplication.shared.sendEvent(nextEvent)
                    }
                }
            }

            return event
        }
    }

    deinit {
        NSEvent.removeMonitor(NSEvent.EventTypeMask.keyDown)
        NSEvent.removeMonitor(NSEvent.EventTypeMask.keyUp)
    }

    private init() {}
    private func keyLogging(event: NSEvent) {
        for keyLogger in XKey.logger {
            if case let .keyDown(loggerType) = keyLogger,
                event.type == NSEvent.EventType.keyDown {
                switch loggerType {
                case .keyCode:
                    print(log: "KeyDown: \(event.keyCode)")
                case .characters:
                    print(log: "KeyDown: \(event.characters ?? "")")
                case .charactersIgnoringModifiers:
                    print(log: "KeyDown: \(event.charactersIgnoringModifiers ?? "")")
                }
            } else if case let .keyUp(loggerType) = keyLogger,
                event.type == NSEvent.EventType.keyUp {
                switch loggerType {
                case .keyCode:
                    print(log: "KeyUp: \(event.keyCode)")
                case .characters:
                    print(log: "KeyUp: \(event.characters ?? "")")
                case .charactersIgnoringModifiers:
                    print(log: "KeyUp: \(event.charactersIgnoringModifiers ?? "")")
                }
            }
        }
    }

    private func print(log: String) {
        delegate?.xKey(self, logger: log)
        Swift.print(log)
    }

    private func createKeyEvent(event: NSEvent, key: Key) -> NSEvent? {
        return NSEvent.keyEvent(
            with: .keyDown,
            location: event.locationInWindow,
            modifierFlags: event.modifierFlags,
            timestamp: self.timestamp,
            windowNumber: event.windowNumber,
            context: NSGraphicsContext.current,
            characters: key.characters ?? "",
            charactersIgnoringModifiers: key.charactersIgnoringModifiers ?? "",
            isARepeat: true,
            keyCode: key.keyCode
        )
    }
}
