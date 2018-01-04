//
//  NumberPadInterfaceController.swift
//  watchOS Example Extension
//
//  Created by Apollo Zhu on 12/27/17.
//
//  Copyright (c) 2017 EyreFree <eyrefree@eyrefree.org>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import WatchKit

typealias NumberInputHandler = (Int) -> Void

extension WKInterfaceController {
    func presentNumberInputController(withDefault default: Int, completion handler: @escaping NumberInputHandler) {
        presentController(withName: "NumberPad", context: (abs(`default`), handler))
    }
}

class NumberPadInterfaceController: WKInterfaceController {
    @IBOutlet var display: WKInterfaceLabel!
    private var value: Int = 0 {
        didSet {
            display.setText("\(value)")
        }
    }
    private var completion: NumberInputHandler?
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        if let (preferred, handler) = context as? (Int, NumberInputHandler) {
            value = preferred
            completion = handler
        }
    }
    @IBAction func didFinishInput() {
        completion?(value)
        dismiss()
    }
    
    @IBAction func tapped0() {
        if value != 0 {
            tapped(0)
        }
    }
    @IBAction func tapped1() {
        tapped(1)
    }
    @IBAction func tapped2() {
        tapped(2)
    }
    @IBAction func tapped3() {
        tapped(3)
    }
    @IBAction func tapped4() {
        tapped(4)
    }
    @IBAction func tapped5() {
        tapped(5)
    }
    @IBAction func tapped6() {
        tapped(6)
    }
    @IBAction func tapped7() {
        tapped(7)
    }
    @IBAction func tapped8() {
        tapped(8)
    }
    @IBAction func tapped9() {
        tapped(9)
    }
    @IBAction func removeLast() {
        value /= 10
    }
    private func tapped(_ number: Int) {
        if let newValue = Int("\(value)\(number)") {
            value = newValue
        }
    }
}
