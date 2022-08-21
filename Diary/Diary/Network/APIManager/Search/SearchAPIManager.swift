//
//  ImageAPIManager.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import Foundation

import Alamofire
import SwiftyJSON

class SearchAPIManger {
    static let shared = SearchAPIManger()
    
    private init() { }
    
    typealias completionHandler = ([String], (Int)) -> ()
    
    func fetchImage(keyword: String, startPage: Int, completionHandler: @escaping completionHandler) {
        guard let keywordData = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = EndPoint.image.requestURL + "query=\(keywordData)&display=30&start=\(startPage)"
        
        let header: HTTPHeaders = ["Content-Type" : "application/x-www-form-urlencoded; charset=UTF-8",
                                  "X-Naver-Client-Id" : APIKey.NAVER_ID,
                                  "X-Naver-Client-Secret" : APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                
                let statusCode = HTTPStatus(statusCode: response.response?.statusCode ?? 500)
                
                switch statusCode {
                case .continueStatus, .multipleChoice, .error:
                    print(statusCode)
                case .badRequest:
                    print("=================== 🔴 잘못된 요청 🔴 ===================")
                case .internalServerError:
                    print("=================== 🟡 서버 내부 오류 🟡 ===================")
                case .ok:
                    let imageList = json["items"].arrayValue.map { $0["link"].stringValue }
                    let totalCount = json["total"].intValue
                    
                    completionHandler(imageList, totalCount)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
