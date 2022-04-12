//
//  JikanDemoTests.swift
//  JikanDemoTests
//
//  Created by ice on 2022/4/10.
//

import XCTest
@testable import JikanDemo
import Moya
import ObjectMapper

class JikanDemoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testGetTopManga() throws {
        let provider = MoyaProvider<JikanAPI>(stubClosure: MoyaProvider.immediatelyStub)
        provider.rx.request(.getTopManga(page: 1))
            .mapObject(MangaList.self)
            .subscribe(onSuccess: { list in
                XCTAssertEqual(list.data.count, 25)
            })
            .disposed(by: rx.disposeBag)
    }
    
    func testGetTopAnime() throws {
        let provider = MoyaProvider<JikanAPI>(stubClosure: MoyaProvider.immediatelyStub)
        provider.rx.request(.getTopAnime(page: 1))
            .mapObject(AnimeList.self)
            .subscribe(onSuccess: { list in
                XCTAssertEqual(list.data.count, 25)
            })
            .disposed(by: rx.disposeBag)
    }
    
    func testMalModelStorage() throws {
        if let url = R.file.topAnimeJson(), let data = try? Data(contentsOf: url) {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                if let list = Mapper<AnimeList>().map(JSON: json) {
                    UserConfigs.shared.favorates.accept(list.data)
                    let temp = UserConfigs.shared.favorates.value
                    let others = UserDefaults.standard.stringArray(forKey: UserConfigs.Keys.favorates)
                    XCTAssertEqual(temp.count, others?.count)
                    return
                }
            }
        }
        
        XCTAssert(false)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
