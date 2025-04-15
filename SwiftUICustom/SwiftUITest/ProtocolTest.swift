//
//  ProtocolTest.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/12/20.
//

import SwiftUI

protocol ProtocolTestProtocol {
    func testProtocol(aaa: String, bbb: Int) -> Result<String, Error>
}

extension ProtocolTestProtocol {
    func testProtocol(aaa: String = "default Value", bbb: Int = 0) -> Result<String, Error> {
        return testProtocol(aaa: aaa, bbb: bbb)
    }
}

class ProtocolTestClass: ProtocolTestProtocol {
    func testProtocol(aaa: String, bbb: Int) -> Result<String, Error> {
        print("akb:: \(aaa) :: \(bbb)")
        return .success(aaa)
    }
}

protocol ProtocolTestProtocolAsync {
    func testProtocol(aaa: String, bbb: Int) async -> Result<String, Error>
}

extension ProtocolTestProtocolAsync {
    func testProtocol(aaa: String = "async default Value", bbb: Int = 0) async -> Result<String, Error> {
        return await testProtocol(aaa: aaa, bbb: bbb)
    }
}

class ProtocolTestClassAsync: ProtocolTestProtocolAsync {
    func testProtocol(aaa: String, bbb: Int) async -> Result<String, Error> {
        print("akb:: \(aaa) :: \(bbb)")
        return .success(aaa)
    }
}

struct ProtocolTest: View {
    var akb: ProtocolTestProtocol = ProtocolTestClass()
    var akbAsync: ProtocolTestProtocolAsync = ProtocolTestClassAsync()
    
    @State private var text: String = ""
    var body: some View {
        VStack {
            Text("success: \(text)")
//            switch akb.testProtocol() {
//            case .success(let str):
//                Text("success: \(str)")
//            case .failure(let error):
//                Text("failure: \(error)")
//            }
        }
        .task {
            switch await akbAsync.testProtocol() {
            case .success(let str):
                text = str
            case .failure(let error):
                text = error.localizedDescription
            }
        }
    }
}

#Preview {
    ProtocolTest()
}
