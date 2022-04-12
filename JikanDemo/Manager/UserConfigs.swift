//
//  UserConfigs.swift
//  JikanDemo
//
//  Created by ice on 2022/4/11.
//

import Foundation
import RxSwift
import RxCocoa
import NSObject_Rx
import ObjectMapper

class UserConfigs: NSObject {
    static let shared = UserConfigs()
    
    let favorates = BehaviorRelay(value: [MalModel]())

    private override init() {
        super.init()

        makeInit()
        subscribeChange()
        
        favorates.accept(unarchived())
    }
    
    private func makeInit() {
        if UserDefaults.standard.dictionary(forKey: Keys.favorates) == nil {
            favorates.accept([])
        }
    }
    
    private func subscribeChange() {
        favorates.skip(1).subscribe(onNext: { (obj) in
            let array = obj.map { $0.toJSONString()! }
            UserDefaults.standard.set(array, forKey: Keys.favorates)
        }).disposed(by: rx.disposeBag)
    }
    
    private func unarchived() -> [MalModel] {
        if let array = UserDefaults.standard.stringArray(forKey: Keys.favorates) {
            return array.map { string in
                if string.contains("\"mal_type\":\"anime\"") {
                    return Mapper<Anime>().map(JSONString: string)!
                } else {
                    return Mapper<Manga>().map(JSONString: string)!
                }
            }
        }
        
        return []
    }
    
    func removeAll() {
        favorates.accept([])
    }
    
    struct Keys {
        static let favorates = "favorates"
    }
}
