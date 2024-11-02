//
//  SwiftUIView.swift
//  SwiftUICustom
//
//  Created by YOO on 2024/11/02.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel = UserListViewModel()
    
    var body: some View {
        NavigationView {
            ZStack {
                switch viewModel.loadingStatus {
                case .completed:
                    UserListRow(vm: viewModel)
                case .loading:
                    ProgressView()
                        .scaleEffect(2.0, anchor: .center)
                        .progressViewStyle(CircularProgressViewStyle(tint: .red))
                default:
                    EmptyView()
                }
            }
        }
        .task {
            await viewModel.getUsers()
        }
        .alert(isPresented: $viewModel.showError) {
            switch viewModel.loadingStatus {
            case .error(let error):
                return Alert(
                    title: Text("Error"),
                    message: Text("\(error)"))
            default: break
            }
            return Alert(title: Text("Error"))
        }
    }
}

struct UserListRow: View {
    @ObservedObject var vm: UserListViewModel
    
    var body: some View {
        List(vm.users) { user in
            HStack {
                AsyncImage(url: URL(string: user.avatarURL ?? "")) { phase in
                    if let image = phase.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                    } else if phase.error != nil {
                        EmptyView()
                    } else {
                        // Acts as a placeholder.
                        Circle()
                            .foregroundStyle(.teal)
                    }
                }
                .frame(width: 50, height: 50)
                
                VStack(alignment: .leading) {
                    Text(user.login?.capitalized ?? "")
                        .font(.headline)
                    
                    Text(user.url ?? "")
                        .font(.subheadline)
                }
            }
        }
        .navigationTitle("Users")
    }
}

#Preview {
    UserListView()
}
