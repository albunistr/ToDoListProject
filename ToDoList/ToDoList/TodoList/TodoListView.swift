//
//  TodoListView.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import Foundation
import SwiftUI


struct TodoListViewModelData {
    let value: TodoListViewModel
}

struct UIKitControllerWrapper: UIViewControllerRepresentable {
    var todoListViewModel: TodoListViewModel
    typealias UIViewControllerType = TodoCalendarViewController
    
    func makeUIViewController(context: Context) -> TodoCalendarViewController {
        return TodoCalendarViewController(items: todoListViewModel.items
        )
    }
    
    func updateUIViewController(_ uiViewController: TodoCalendarViewController, context: Context) {
        //
    }

}
struct TodoListView: View {
    @StateObject var todoListViewModel: TodoListViewModel
    @State private var selectedItem: TodoItemViewModel?
    @State private var isTapped: Bool = false
    @State private var showCalendar = false
    
    // MARK: - Body
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Colors.backPrimary
                    .ignoresSafeArea()
     
                VStack(spacing: 0){
                        title
                        topBar
                        list
                    }

                addNewButton
            }
            .sheet(item: $selectedItem, onDismiss: {
                todoListViewModel.loadTodos()
            }) { selectedItem in
                if let index = todoListViewModel.items.firstIndex(where: { $0.todoItem.id == selectedItem.id}) {
                    ToDoItemView(todoItemViewModel: $todoListViewModel.items[index])
                }
            }
            .fullScreenCover(isPresented: $showCalendar) {
                UIKitControllerWrapper(todoListViewModel: todoListViewModel)
            }
            
        }
    }
    
    // MARK: - Title
    
    var title: some View {
        HStack{ Text(TodoListConstants.myTodos)
                .padding(.top, 60)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .font(.largeTitle).bold()
            Spacer()
            Text("Календарь")
                .padding(.top, 60)
                .padding()
                .frame(maxWidth: .infinity, alignment: .trailing)
                .font(.title).bold()
                .foregroundColor(Colors.labelTertiary)
                .onTapGesture {
                    showCalendar = true
                }
        }
    }
    
    // MARK: - Top bar
    
    var topBar: some View {
        HStack {
            Text("\(TodoListConstants.done) - \(todoListViewModel.countOfCompleted)")
                .padding()
                .foregroundColor(Colors.labelDisable)
            Spacer()
            Text(todoListViewModel.isNeedCompleted ? TodoListConstants.hide : TodoListConstants.show)
                .padding()
                .font(.headline).bold()
                .foregroundColor(Colors.blue)
                .onTapGesture {
                    todoListViewModel.isNeedCompleted.toggle()
                }
            
        }
    }
    
    // MARK: - Add new item button
    
    var addNewButton: some View {
        Button(action: {
            todoListViewModel.addNew()
            selectedItem = todoListViewModel.items.last
        }) {
            Image(Images.plus)
                .frame(width: 44, height: 44, alignment: .center)
        }
        .padding(.bottom, 32)
    }
    
    // MARK: - Add new in List
    var aaddNewInList: some View {
        Button {
            todoListViewModel.addNew()
            selectedItem = todoListViewModel.items.last
        } label: {
            Text(TodoListConstants.new)
        }
    }
        
    // MARK: - Items list
    
    var list: some View {
        List {
                ForEach($todoListViewModel.items, id: \.id) { $viewModel in
                    VStack(spacing: 0) {
                        HStack{
                            
                            TodoCellView(todoItemViewModel: $viewModel, isCompleted: viewModel.todoItem.isCompleted)
                            
                            Image(Images.modeLight)
                                .onTapGesture {
                                    selectedItem = viewModel
                                }
                        }
                            .contentShape(Rectangle())
                            .swipeActions(edge: .leading) {
                                
                                Button {
                                    if let index = todoListViewModel.items.firstIndex(where: { $0.id == viewModel.id }) {
                                        todoListViewModel.didSwitchToggle(index: index)
                                    }
                                } label: {
                                    Image(Images.completed)
                                }
                                .tint(Color.green)
                                
                            }
                            .swipeActions(edge: .trailing) {
                                
                                Button(role: .destructive) {
                                    todoListViewModel.didTapDeleteButton(todoItem: viewModel.todoItem)
                                } label: {
                                    Image(systemName: "trash")
                                }
                                
                                Button {
                                    selectedItem = viewModel
                                } label: {
                                    Image(Images.cell)
                                }
                                .tint(Color.gray)
                                
                            }
                        Divider()
                            .padding(.leading, 38)
                            .padding(.trailing, -100)
                    }
                    
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 12))
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 12))
                    
                }
            
            aaddNewInList
                
                .foregroundColor(Colors.labelTertiary)
                .padding(.vertical, 12)
                .padding(.leading, 32)
        }
        
        .listStyle(InsetGroupedListStyle())
        .scrollContentBackground(.hidden)
        .background(Colors.backPrimary)
    }
}
    
    // MARK: PreView
    struct TodoListViewPreview: PreviewProvider {
        static var previews: some View {
            TodoListView(todoListViewModel: TodoListViewModel(fileCache: testingFileCache))
        }
    }
