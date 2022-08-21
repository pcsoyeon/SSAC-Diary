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
    
    typealias completionHandler = ([String]) -> ()
    
    func fetchImage(keyword: String, page: Int, completionHandler: @escaping completionHandler) {
        guard let keywordData = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else { return }
        
        let url = EndPoint.image.requestURL + "query=\(keywordData)&display=30&start=\(page)"
        
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
                    print("=================== 🔴 잘못된 요청 🔴 ===================", json)
                case .internalServerError:
                    print("=================== 🟡 서버 내부 오류 🟡 ===================", json)
                case .ok:
                    let imageList = json["items"].arrayValue.map { $0["link"].stringValue }
                    completionHandler(imageList)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
}
