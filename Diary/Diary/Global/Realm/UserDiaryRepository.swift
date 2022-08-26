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
    
    // 5. '좋아요' 적용 함수
    func updateFavorite(item: UserDiary) {
        do {
            try localRealm.write {
                // 하나의 레코드에서 특정 컬럼 하나만 변경
                item.favorite.toggle()
                
                // 하나의 테이블에 특정 컬럼 전체 값을 변경
                // self.tasks.setValue(true, forKey: "favorite")
                
                // 하나의 레코드에서 여러 컬럼을 변경
                // localRealm.create(UserDiary.self, value: ["objectId" : self.tasks[indexPath.row].objectId, "diaryContent" : "내용뿡뿡", "diaryTitle" : "제목뿡뿡"],update: .modified)
            }
        } catch {
            print("ERROR")
        }
    }
    
    // 6. 삭제
    func deleteItem(item: UserDiary) {
        do {
            try localRealm.write {
                removeImageFromDocument(fileName: "\(item.objectId).jpg")
                localRealm.delete(item)
            }
            
        } catch {
            print("ERROR")
        }
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
        } catch let error {
            print(error)
        }
    }
}
