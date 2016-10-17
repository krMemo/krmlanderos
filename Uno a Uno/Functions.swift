//
//  Functions.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 02/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import Foundation

var mensaje: String = ""

func post(phpFile: String, postString: String) -> (String) {
    let url = URL(string: "http://ec2-52-52-32-4.us-west-1.compute.amazonaws.com/" + phpFile)
    var request = URLRequest(url: url!)
    request.httpMethod = "POST"
    request.httpBody = postString.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))

    let task = URLSession.shared.dataTask(with: request, completionHandler: { data, response, error in guard error == nil && data != nil else {
        print("error=\(error)")
            return
        }
        if let httpStatus = response as? HTTPURLResponse, httpStatus.statusCode != 200 {
            print("\(httpStatus.statusCode) = \(response)")
        }
        mensaje = String(data: data!, encoding: String.Encoding(rawValue: String.Encoding.utf8.rawValue))!
    })
    task.resume()
    return mensaje
}

extension String {
    var lang: String {
        return NSLocalizedString(self, comment: "")
    }
}
