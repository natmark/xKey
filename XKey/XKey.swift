//
//  XKey.swift
//  XKey
//
//  Created by AtsuyaSato on 2018/05/12.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Foundation

public class XKey {
    public static let shared = XKey()

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

    private init() {}

    public func extend() {
        NSEvent.addLocalMonitorForEvents(matching: NSEvent.EventTypeMask.keyUp) { [weak self] event in
            guard let `self` = self else {
                return event
            }

            let key = Key(event: event)
            let lastKey = self.lastKey

            self.keysDownList.remove(object: key)
            self.shouldForceKeyDownCall = false

            if lastKey == key,
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

            let key = Key(event: event)
            if self.lastKey != key {
                self.shouldForceKeyDownCall = false
            }
            self.keysDownList.insert(key)

            if self.shouldForceKeyDownCall {
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(self.keyRepeatTime)) {
                    if self.shouldForceKeyDownCall,
                        let repeatKey = self.lastKey,
                        let nextEvent = self.createKeyEvent(event: event, key: repeatKey) {
                        NSApplication.shared.sendEvent(nextEvent)
                    }
                }
            }

            return event
        }
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
