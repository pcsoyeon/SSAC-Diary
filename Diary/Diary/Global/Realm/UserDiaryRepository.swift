//
//  UserDiaryRespository.swift
//  Diary
//
//  Created by 소연 on 2022/08/26.
//

import UIKit

import RealmSwift

class UserDiaryRepository {
    // 1. local Realm 생성
    let localRealm = try! Realm()
    
    // 2. 데이터 반환하는 함수 
    func fetch() -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "diaryDate", ascending: false)
    }
    
    // 3. sort 함수
    func fetchSort(sortKey: String) -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).sorted(byKeyPath: "\(sortKey)", ascending: false)
    }
    
    // 4. filter 함수
    func fetchFilter(filterKey: String) -> Results<UserDiary> {
        return localRealm.objects(UserDiary.self).filter("diaryTitle CONTAINS '\(filterKey)'")
    }
}
