//
//  Request.swift
//  INFS3202
//
//  Created by Adam Dorogi-Kaposi on 21/5/18.
//  Copyright © 2018 Adam Dorogi-Kaposi. All rights reserved.
//

import Foundation

class Request {
    
    var serverURL = "https://infs3202-842731a8.uqcloud.net/"
    
    func request(file: String, bodyData: String = "", completion: @escaping ([[String: Any]]) -> ()) {
        let url = URL(string: "\(serverURL)\(file)")
        var request = URLRequest(url: url!)
        
        request.httpMethod = "POST"
        
        request.httpBody = bodyData.data(using: .utf8)
        
        var json = [[String: Any]]()
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if (error != nil) {
                return
            }
            
            do {
                json = try JSONSerialization.jsonObject(with: data!) as! [[String: Any]]
            } catch {
                print("Parsing error: \(error)")

                let responseString = String(data: data!, encoding: .utf8)
                print("Raw response: \(responseString!)")
            }
            completion(json)
        }
        task.resume()
    }
}
