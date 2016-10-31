//
//  IEFeedManager.swift
//  DHEnglish
//
//  Created by Dareen Hsu on 05/10/2016.
//  Copyright © 2016 D.H. All rights reserved.
//

import UIKit

//let ResourceURL = "http://localhost:8888/wjson"
//let ResourceURL = "http://192.168.1.104:8888/wjson"
let ResourceURL = "http://172.20.10.4:8888/wjson"

class IEFeedManager: NSObject {
    static let sharedInstance = IEFeedManager()

    func requestWord(success: (() -> Void)?, faild: (() -> Void)? ) {

        let url = URL(string: ResourceURL)
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"

        let configuration = URLSessionConfiguration.default
        let sessionManager = AFURLSessionManager(sessionConfiguration: configuration)
        sessionManager.responseSerializer = AFHTTPResponseSerializer.init()

        let dataTask = sessionManager .dataTask(with: request, uploadProgress: nil, downloadProgress: nil) { (requestObj, responseObj, error) in
            if error != nil {
                success?()
                NSLog("<AFHTTP> \(error!) ");
            }else {
                if let parsedData = try? JSONSerialization.jsonObject(with: responseObj as! Data) {

                    WordEntity.addWord(parsedData as? [Any], success: {
                        success?()
                    })

                    NSLog("<AFHTTP> \(parsedData)")
                }else {
                    NSLog("<AFHTTP> error result \(String.init(data: responseObj as! Data, encoding: .utf8))")
                }

                faild?()
            }
        }
        dataTask.resume()
    }
}
