//
//  ViewController.swift
//  XKeyExample
//
//  Created by AtsuyaSato on 2018/05/12.
//  Copyright © 2018年 Atsuya Sato. All rights reserved.
//

import Cocoa
import XKey

class ViewController: NSViewController {

    @IBOutlet weak var segmentControl: NSSegmentedControl!
    @IBOutlet var textView: NSTextView!
    @IBOutlet weak var iImageView: NSImageView!
    @IBOutlet weak var jImageView: NSImageView!
    @IBOutlet weak var kImageView: NSImageView!
    @IBOutlet weak var lImageView: NSImageView!

    var keyCodes: Set<UInt16> = [] {
        didSet {
            self.iImageView.image = NSImage(named: NSImage.Name(rawValue: "i-key"))
            self.jImageView.image = NSImage(named: NSImage.Name(rawValue: "j-key"))
            self.kImageView.image = NSImage(named: NSImage.Name(rawValue: "k-key"))
            self.lImageView.image = NSImage(named: NSImage.Name(rawValue: "l-key"))

            for keyCode in keyCodes {
                switch keyCode {
                case 34: // i
                    self.iImageView.image = NSImage(named: NSImage.Name(rawValue: "i-key-highlight"))
                case 38: // j
                    self.jImageView.image = NSImage(named: NSImage.Name(rawValue: "j-key-highlight"))
                case 40: // k
                    self.kImageView.image = NSImage(named: NSImage.Name(rawValue: "k-key-highlight"))
                case 37: // l
                    self.lImageView.image = NSImage(named: NSImage.Name(rawValue: "l-key-highlight"))
                default: break
                }
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        segmentControl.selectedSegment = 1
        XKey.enabled = false
        XKey.shared.delegate = self
        XKey.logger = [.keyDown(.characters)]
        // Do any additional setup after loading the view.
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { (event) -> NSEvent? in
            self.keyDown(with: event)
            return event
        }
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) { (event) -> NSEvent? in
            self.keyUp(with: event)
            return event
        }
    }

    override func keyUp(with event: NSEvent) {
        keyCodes.remove(event.keyCode)
    }

    override func keyDown(with event: NSEvent) {
        keyCodes.insert(event.keyCode)
    }

    @IBAction func didTap(_ sender: NSButton) {
        textView.string = ""
    }

    @IBAction func didChange(_ sender: NSSegmentedControl) {
        if sender.indexOfSelectedItem == 0 {
            XKey.enabled = true
        } else {
            XKey.enabled = false
        }
        print(sender.indexOfSelectedItem)
    }
}

extension ViewController: XKeyDelegate {
    func xKey(_ xKey: XKey, logger log: String) {
        textView.string += log
        textView.string += "\n"
        textView.scrollRangeToVisible(NSRange(location: textView.string.count, length: 0))
    }
}
