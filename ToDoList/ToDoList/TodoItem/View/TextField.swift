//
//  TextField.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import SwiftUI

struct TextField: View {
    @Binding var text: String

    var body: some View {
        VStack {
            TextEditor(text: $text)
                .onTapGesture {
                    if text == TodoItemViewConstants.defaultTextEditor {
                        text = ""
                    }
                }
                .frame(minHeight: 100, maxHeight: nil)
                .padding()
                .foregroundColor(text == TodoItemViewConstants.defaultTextEditor ? 
                                 Colors.labelTertiary :
                                    Colors.labelPrimary)
                .background(RoundedRectangle(cornerRadius: 16).fill(Colors.backSecondary))
                .padding(.top)
        }
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                Button(TodoItemViewConstants.ready) {
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), 
                                                    to: nil,
                                                    from: nil,
                                                    for: nil)
                }
            }
        }
    }
}
