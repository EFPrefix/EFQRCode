//
//  InterfaceController.swift
//  watchOS Example Extension
//
//  Created by Apollo Zhu on 12/27/17.
//  Copyright © 2017 EyreFree. All rights reserved.
//

import WatchKit
import Foundation
import EFQRCode

class InterfaceController: WKInterfaceController {
    @IBOutlet var qrcodeImage: WKInterfaceImage!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        let link = "https://github.com/EyreFree/EFQRCode"
        let qrcode = EFQRCode.generate(content: link,
                                       backgroundColor: .black,
                                       foregroundColor: .white)!
        qrcodeImage.setImage(UIImage(cgImage: qrcode))
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
