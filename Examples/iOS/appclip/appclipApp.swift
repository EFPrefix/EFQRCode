//
//  appclipApp.swift
//  appclip
//
//  Created by EyreFree on 2020/9/27.
//  Copyright © 2020 EyreFree. All rights reserved.
//

import SwiftUI

@main
struct appclipApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: { userActivity in
                    guard let incomingURL = userActivity.webpageURL,
                          let components = NSURLComponents(url: incomingURL, resolvingAgainstBaseURL: true),
                          let queryItems = components.queryItems else {
                        return
                    }
                    print(incomingURL)
                    print(components)
                    print(queryItems)
                })
        }
    }
}
