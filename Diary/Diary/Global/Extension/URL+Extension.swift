//
//  URL+Extension.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import Foundation

extension URL {
    static let BaseURL = "https://openapi.naver.com/v1/search"
    
    static func makeEndPointString(_ endPoint: String) -> String {
        return BaseURL + endPoint
    }
}
