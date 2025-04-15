//
//  TestCodeTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2025/02/25.
//

import SwiftUI

class MockAPIClient {
    func getPlayers() async throws -> [String] {
        try await Task.sleep(nanoseconds: 2_000_000_000)
        return ["伊東純也", "三笘薫", "堂安律"]
    }
}

class MockViewModel {
    let mockAPIClient = MockAPIClient()
    var contents: [String] = []
    func fetch() async {
        Task {
            do {
                let response = try await mockAPIClient.getPlayers()
                await setContents(contents: response)
            } catch {
                // エラー処理
            }
        }
    }

    @MainActor private func setContents(contents: [String]) {
        self.contents = contents
    }
}

//class MockViewModelTest: XCTestCase {
//    func testAPIリクエストをして表示() async throws {
//        let viewModel = MockViewModel()
//        
//        await viewModel.fetch()
//        
//        XCTAssertEqual(viewModel.contents.isEmpty, false)
//        XCTAssertEqual(viewModel.contents[0], "伊東純也")
//    }
//}


//import XCTest
//
//class MockViewModelTest: XCTestCase {
//    func testAPIリクエストをして表示() {
//        let viewModel = MockViewModel()
//
//        let exp = expectation(description: "コンテンツのロードを待つ")
//        viewModel.fetch {
//            exp.fulfill()
//        }
//
//        wait(for: [exp], timeout: 0.05)
//        XCTAssertEqual(viewModel.contents.isEmpty, false)
//        XCTAssertEqual(viewModel.contents[0], "伊東純也")
//    }
//}
