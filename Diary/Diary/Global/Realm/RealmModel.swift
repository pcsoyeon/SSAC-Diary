//
//  RealmModel.swift
//  Diary
//
//  Created by 소연 on 2022/08/22.
//

import Foundation
import RealmSwift

// MARK: - User Diary

// User Diary: 테이블 이름
// @Persisted: 컬럼

class UserDiary: Object {
    @Persisted var diaryTitle: String // 제목 (필수)
    @Persisted var diaryContent: String? // 내용 (옵션)
    @Persisted var diaryDate = Date() // 작성 날짜 (필수)
    @Persisted var regDate = Date() // 등록 날자 (필수)
    @Persisted var favorite: Bool // 즐겨찾기 (필수)
    @Persisted var photo: String? // 사진 String (옵션)
    
    // PK(필수): Int, UUID, ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId
    
    convenience init(diaryTitle: String, diaryContent: String?, diaryDate: Date, regDate: Date, favortie: Bool, photo: String?) {
        self.init()
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryDate = diaryDate
        self.regDate = regDate
        self.favorite = false
        self.photo = photo
    }
}

