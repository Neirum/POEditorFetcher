//
//  Service.swift
//  POExporter
//
//  Created by prog on 20.10.16.
//  Copyright © 2016 prog. All rights reserved.
//

import Foundation

enum ResultCode {
    case ResultCodeError
    case ResultCodeSuccess
}

let projectName = "VPN_Unlimited_strings"
let endpoint = "https://poeditor.com/api/"
let listServersFormatString = "api_token=%@&action=list_languages&id=27060"
let exportFormatString = "api_token=%@&action=export&id=27060&language=%@&type=apple_strings"

let languageCodeMap = ["ar":"ar",
                       "zh-CN":"zh-Hans",
                       "en":"en",
                       "de":"de",
                       "ja":"ja",
                       "ko":"ko",
                       "pt-br":"pt-BR",
                       "ru":"ru",
                       "es":"es",
                       "tr":"tr",
                       "Base":"Base"]

class Service {
    
    class func exportStringsWithAPIToken(_ apiToken : String) -> ResultCode {
        
        var result : Bool = true
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = String(format:listServersFormatString, apiToken).data(using: String.Encoding.utf8)
        
        let sem = DispatchSemaphore(value: 0)
        
        let dataTask = defaultSession.dataTask(with: urlRequest, completionHandler:{ (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        if let list = jsonResult["list"] as? [[String:AnyObject]] {
                            for language : [String:AnyObject] in list {
                                let code : String = language["code"] as! String
                                result = result && exportLanguage(apiToken:apiToken, languageCode:code)
                                if code == "en" {
                                    result = result && exportLanguage(apiToken:apiToken, languageCode:"Base")
                                }
                            }
                        }
                    }
                } catch let error {
                    result = false
                    print(error.localizedDescription)
                }
            } else {
                result = false
                print(error?.localizedDescription as Any)
            }
            sem.signal()
        })
        
        dataTask.resume()
        let _ = sem.wait(timeout: DispatchTime.distantFuture)
        
        return result ? .ResultCodeSuccess : .ResultCodeError
    }
    
    private class func exportLanguage(apiToken: String, languageCode: String) -> Bool {
        
        var result = true
        
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
        let url = URL(string: endpoint)!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = String(format:exportFormatString, apiToken, (languageCode == "Base") ? "en" : languageCode).data(using: String.Encoding.utf8)
        
        let sem = DispatchSemaphore(value: 0)
        
        let dataTask = defaultSession.dataTask(with: urlRequest, completionHandler:{ (data: Data?, response: URLResponse?, error: Error?) -> Void in
            if error == nil {
                do {
                    if let jsonResult = try JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                        if let item = jsonResult["item"] as? String {
                            do {
                                let data = try Data(contentsOf: URL(string:item)!)
                                let saveDirectoryURL = FileManager.default.urls(for: .downloadsDirectory, in: .userDomainMask)[0].appendingPathComponent(projectName).appendingPathComponent(languageCodeMap[languageCode]! + ".lproj")
                                let fileURL = saveDirectoryURL.appendingPathComponent("Localizable.strings", isDirectory: false)
                                
                                do {
                                    try FileManager.default.createDirectory(at: saveDirectoryURL, withIntermediateDirectories: true, attributes: nil)
                                    do {
                                        try unescapeSequences(data: data).write(to: fileURL, options:NSData.WritingOptions.atomicWrite)
                                        print("EXPORTED: " + fileURL.path)
                                    }
                                    catch let error {
                                        result = false
                                        print(error.localizedDescription)
                                    }
                                }
                                catch let error{
                                    result = false
                                    print(error.localizedDescription)
                                }
                                
                            }
                            catch let error{
                                result = false
                                print(error.localizedDescription)
                            }
                        }
                    }
                } catch let error {
                    result = false
                    print(error.localizedDescription)
                }
            }
            else {
                result = false
                print(error?.localizedDescription as Any)
            }
            sem.signal()
        })
        dataTask.resume()
        
        let _ = sem.wait(timeout: DispatchTime.distantFuture)
        
        return result
    }
    
    class func unescapeSequences(data : Data) -> Data {
        let string = NSString(data:data, encoding:String.Encoding.utf8.rawValue)
        let unescapedString = string!.replacingOccurrences(of: "\\\\", with: "\\")
        let data = unescapedString.data(using: String.Encoding.utf8)
        return data!
    }
}
