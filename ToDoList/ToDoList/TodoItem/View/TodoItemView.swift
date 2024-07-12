//
//  TodoItemView.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import Foundation
import SwiftUI
import UIKit

struct TodoItemView: View {
    // MARK: - Class Properties

    @ObservedObject var todoItemViewModel: TodoItemViewModel
    @Binding var isShowed: Bool

    // MARK: - Delete button

    var deleteButton: some View {
        Button {
            todoItemViewModel.didTapDeleteButton()
            isShowed = false
        } label: {
            Text(TodoItemViewConstants.delete)
                .tint(todoItemViewModel.text.isEmpty && 
                      todoItemViewModel.text != TodoItemViewConstants.defaultTextEditor ?
                      Colors.labelTertiary : 
                        Colors.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .background(RoundedRectangle(cornerRadius: 17).fill(Colors.backSecondary))
        }
        .disabled(todoItemViewModel.todoItem?.id == nil)
    }

    // MARK: - Controls

    var controls: some View {
        VStack(spacing: 17) {
            TextField(text: $todoItemViewModel.text)
            VStack(spacing: 17) {
                ImportanceFieldView(importance: $todoItemViewModel.importance)
                Divider()
                CategoryFieldView(category: $todoItemViewModel.category)
                Divider()
                ColorPickerView(selectedColor: $todoItemViewModel.color)
                Divider()
                DeadlineFieldView(isOnDeadline: $todoItemViewModel.isOnDeadline, 
                                  deadline: $todoItemViewModel.deadline)
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 17).fill(Colors.backSecondary))

            deleteButton

            Spacer()
        }
        .padding(.horizontal)
        .navigationTitle(TodoItemViewConstants.task)
        .navigationBarBackButtonHidden(true)
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack {
                Colors.backPrimary
                    .ignoresSafeArea()

                ScrollView(.vertical, showsIndicators: false) {
                    controls
                        .toolbar {
                            ToolbarItem(placement: .navigationBarLeading) {
                                Button("Отменить") {
                                    isShowed = false
                                }
                            }

                            ToolbarItem(placement: .navigationBarTrailing) {
                                Button {
                                    if todoItemViewModel.text != TodoItemViewConstants.defaultTextEditor && 
                                        !todoItemViewModel.text.isEmpty {
                                        todoItemViewModel.didTapSaveButton()
                                        isShowed = false
                                    }

                                } label: {
                                    Text("Сохранить")
                                }
                                .disabled(todoItemViewModel.text.isEmpty || 
                                          todoItemViewModel.text == TodoItemViewConstants.defaultTextEditor)
                            }
                        }
                }
                .scrollContentBackground(.hidden)
                .background(Colors.backPrimary)
            }
        }
    }
}

extension Binding {
    init(_ source: Binding<Value?>, replacingNilWith defaultValue: Value) {
        self.init(
            get: { source.wrappedValue ?? defaultValue },
            set: { newValue in source.wrappedValue = newValue }
        )
    }
}
