//
//  ExtensionDelegate.swift
//  watchOS Example Extension
//
//  Created by Apollo Zhu on 12/27/17.
//  Copyright © 2017 EyreFree. All rights reserved.
//

import WatchKit

class ExtensionDelegate: NSObject, WKExtensionDelegate {

    func applicationDidFinishLaunching() { }

    func applicationDidBecomeActive() { }

    func applicationWillResignActive() { }

    @available(watchOSApplicationExtension 3.0, *)
    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        // Sent when the system needs to launch the application in the background to process tasks. Tasks arrive in a set, so loop through and process each one.
        for task in backgroundTasks {
            // Use a switch statement to check the task type
            switch task {
            case let backgroundTask as WKApplicationRefreshBackgroundTask:
                // Be sure to complete the background task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    backgroundTask.setTaskCompletedWithSnapshot(false)
                } else { backgroundTask.setTaskCompleted() }
            case let snapshotTask as WKSnapshotRefreshBackgroundTask:
                // Snapshot tasks have a unique completion call, make sure to set your expiration date
                snapshotTask.setTaskCompleted(restoredDefaultState: true, estimatedSnapshotExpiration: Date.distantFuture, userInfo: nil)
            case let connectivityTask as WKWatchConnectivityRefreshBackgroundTask:
                // Be sure to complete the connectivity task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    connectivityTask.setTaskCompletedWithSnapshot(false)
                } else { connectivityTask.setTaskCompleted() }
            case let urlSessionTask as WKURLSessionRefreshBackgroundTask:
                // Be sure to complete the URL session task once you’re done.
                if #available(watchOSApplicationExtension 4.0, *) {
                    urlSessionTask.setTaskCompletedWithSnapshot(false)
                } else { urlSessionTask.setTaskCompleted() }
            default:
                // make sure to complete unhandled task types
                if #available(watchOSApplicationExtension 4.0, *) {
                    task.setTaskCompletedWithSnapshot(false)
                } else { task.setTaskCompleted() }
            }
        }
    }

}
