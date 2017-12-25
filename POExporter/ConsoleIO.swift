//
//  ConsoleIO.swift
//  POExporter
//
//  Created by prog on 20.10.16.
//  Copyright © 2016 prog. All rights reserved.
//

import Foundation

class ConsoleIO {
    
    class func doStuff() {
//        if CommandLine.arguments.count < 2 {
//            printUsage()
//        }
//        else {
//            let apiToken = CommandLine.arguments[1] as String
//            let resultCode = Service.exportStringsWithAPIToken(apiToken)
//
//            if (resultCode == .ResultCodeSuccess) {
//                printSuccess()
//            } else {
//                printError()
//            }
            let sem = DispatchSemaphore(value: 0)

            POEService().loadProjectsList() { projects, error in
                if let error = error {
                    print(error.localizedDescription)
                }
                
                print(projects)
                sem.signal()
            }
            sem.wait()
//        }
    }
    
    class func printUsage() {
        let executableName = (CommandLine.arguments[0] as NSString).lastPathComponent
        
        print("usage:")
        print("\(executableName) api_token")
        print("You can get this token from your POEditor account. You'll find it in My Account > API Access.")
    }
    
    class func printError() {
        print("Something went wrong. Please check your API token and/or internet connection")
    }
    
    class func printSuccess() {
        print("Export successfull.")
    }
}
