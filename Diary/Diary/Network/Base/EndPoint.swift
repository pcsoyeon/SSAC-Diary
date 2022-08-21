//
//  EndPoint.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import Foundation

enum EndPoint {
    case image
    
    var requestURL: String {
        switch self {
        case .image:
            return URL.makeEndPointString("/image")
        }
    }
}
