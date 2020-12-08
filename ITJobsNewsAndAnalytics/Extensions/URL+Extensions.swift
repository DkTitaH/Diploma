//
//  URL+Extensions.swift
//  ITJobsNewsAndAnalytics
//
//  Created by iphonovv on 01.12.2020.
//

import Foundation

extension URL {
    static func + (left: URL, right: String) -> URL {
        let string = left.absoluteString + right
        let newstr = string.addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed) ?? string
        
        if let url = URL(string: newstr) {
            return url
        } else {
            fatalError("Error with convert URL when added query to right side")
        }
    }
}
