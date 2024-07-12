//
//  TodoListView.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import SwiftUI
import CocoaLumberjackSwift

struct TodoListView: View {
    @StateObject var todoListViewModel: TodoListViewModel
    @State private var selectedItem: TodoItem?
    @State private var showCreateTodoItemView = false
    @State private var showEditTodoItemView = false
    @State private var showCompleted: Bool = false

    // MARK: - Body

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Colors.backPrimary
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    topBar
                    list
                        .toolbar {
                            ToolbarItem(placement: .topBarLeading) {
                                Text("Мои дела")
                                    .font(.title)
                                    .bold()
                            }
                            ToolbarItem(placement: .topBarTrailing) {
                                NavigationLink {
                                    TodoCalendarWrapper(todoListViewModel: todoListViewModel)
                                        .navigationTitle("Мои дела")
                                        .toolbarRole(.editor)
                                        .onDisappear {
                                            todoListViewModel.loadTodos()
                                            DDLogVerbose("Closed TodoCalendar")
                                        }
                                } label: {
                                    Image(systemName: "calendar")
                                }
                            }
                        }

                    addNewButton
                }
                .onAppear {
                    todoListViewModel.loadTodos()
                }
                .sheet(isPresented: $showEditTodoItemView) {
                    VStack {
                        TodoItemView(todoItemViewModel:
                                        TodoItemViewModel(todoItem: selectedItem,
                                                          listViewModel: todoListViewModel),
                                     isShowed: $showEditTodoItemView)
                    }
                    .onAppear {
                        DDLogInfo("Edit opened")
                    }
                }
                .sheet(isPresented: $showCreateTodoItemView) {
                    VStack{
                        TodoItemView(todoItemViewModel: TodoItemViewModel(todoItem: nil,
                                                                          listViewModel: todoListViewModel),
                                     isShowed: $showCreateTodoItemView)
                    }
                    .onAppear {
                        DDLogInfo("Create opened")
                    }
                }
            }
        }
    }

    // MARK: - Top bar

    var topBar: some View {
        HStack {
            Text("Выполнено - \(todoListViewModel.items.filter { $0.isCompleted }.count)")
                .padding()
                .foregroundColor(Colors.labelDisable)
            Spacer()
            Text(showCompleted ? "Скрыть" : "Показать")
                .padding()
                .font(.headline).bold()
                .foregroundColor(Colors.blue)
                .onTapGesture {
                    showCompleted.toggle()
                }
        }
    }

    // MARK: - Add new item button

    var addNewButton: some View {
        Button(action: {
            showCreateTodoItemView = true
        }) {
            Images.plus
                .frame(width: 44, height: 44, alignment: .center)
        }
        .padding(.bottom, 32)
    }

    // MARK: - Items list

    var list: some View {
        List {
            ForEach(todoListViewModel.items.filter { !showCompleted ? !$0.isCompleted : true }, id: \.id) { item in
                TodoCellView(
                    todoItem: item,
                    completedToggle: {
                        let updatedItem = TodoItem(
                            id: item.id,
                            text: item.text,
                            importance: item.importance,
                            deadline: item.deadline,
                            isCompleted: !item.isCompleted,
                            createdAt: item.createdAt,
                            changedAt: Date(),
                            color: item.color,
                            category: item.category
                        )
                        todoListViewModel.addNewOrUpdateItem(updatedItem)
                    },
                    infoTap: {
                        selectedItem = item
                        showCreateTodoItemView = false
                        showEditTodoItemView = true
                    },
                    deleteTap: {
                        todoListViewModel.removeItem(by: item.id)
                    }
                )
            }
            NewTodoCell {
                showEditTodoItemView = false
                showCreateTodoItemView = true
            }
            .listRowInsets(EdgeInsets())
        }
        .scrollContentBackground(.hidden)
        .background(Colors.backPrimary)
        .listStyle(InsetGroupedListStyle())
    }
}

struct NewTodoCell: View {
    let onCreate: () -> Void

    var body: some View {
        HStack {
            Text("Новое")
                .font(.system(size: 16))
                .foregroundColor(.secondary)
                .padding(.leading, 60)

            Spacer()
        }
        .padding(.vertical, 4)
        .frame(height: 50)
        .onTapGesture {
            onCreate()
        }
    }
}

// MARK: PreView

struct TodoListViewPreview: PreviewProvider {
    static var previews: some View {
        TodoListView(todoListViewModel: TodoListViewModel(fileCache: testingFileCache))
    }
}
