//
//  todoListModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 25.06.2024.
//

import Foundation
import SwiftUI

struct TodoListModel: View {
    var body: some View {
        NavigationStack {
            ZStack {
                ColorsBack.primary
                    .ignoresSafeArea()
                ScrollView(.vertical, showsIndicators: false) {
                    VStack {
                        Text("Мои дела")
                            .padding(.top, 20)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.largeTitle).bold()
                        HStack {
                            Text("Выполнено")
                                .padding()
                                .foregroundColor(ColorsLabel.disable)
                            Spacer()
                            Text("Показать")
                                .padding()
                                .font(.headline).bold()
                                .foregroundColor(Colors.blue)
                        }
                        
                        List {
                            
                        }
                        .background(RoundedRectangle(cornerRadius: 16).fill(Colors.blue))
                    }
                }
            }
        }
        
    }
}

// MARK: PreView
struct TodoListModelPreview: PreviewProvider {
    static var previews: some View {
        TodoListModel()
    }
}
