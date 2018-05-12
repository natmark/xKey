//
//  ViewController.swift
//  XKeyExample
//
//  Created by AtsuyaSato on 2018/05/12.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
            self.keyDown(with: event)
            return event
        }
    }

    override func keyDown(with event: NSEvent) {
        print("key press: \(event.characters)")
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
}

