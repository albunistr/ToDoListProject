//
//  TodoItemView.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import Foundation
import SwiftUI

struct ToDoItemView: View {
    
    @Binding var todoItemViewModel: TodoItemViewModel
    
    // MARK: - Environment properties
    
    @Environment(\.dismiss) var dismiss
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    // MARK: - State properties
    
    @State private var deadlineDate: Date = TodoItemViewConstants.defaultDeadline
    @State private var selectedOption = 1
    @State private var textEditor = "Что надо сделать?"
    @State private var isOnDeadline = false
    @State private var isShowDatePicker = false
    @State private var selectedColor = Colors.red
    @State private var opacityValue = 1.0
    @State private var brightness: Double = 0.5
    
    // MARK: - Text editor field
    
    var textField: some View {
        VStack {
            TextEditor(text: $textEditor)
                .onTapGesture {
                    if textEditor == TodoItemViewConstants.defaultTextEditor {
                        textEditor = " "
                    }
                }
                .frame(minHeight: 100, maxHeight: nil)
                .padding()
                .foregroundColor(textEditor == TodoItemViewConstants.defaultTextEditor ? Colors.labelTertiary : Colors.labelPrimary)
                .background(RoundedRectangle(cornerRadius: 16).fill(Colors.backSecondary))
                .padding(.top)
        }
        .toolbar {
                    ToolbarItem(placement: .keyboard) {
                        Button(TodoItemViewConstants.ready) {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                        }
                    }
                }
                    
    }
    // MARK: - Importance field
    
    var importanceField: some View {
        HStack {
            Text(TodoItemViewConstants.importance)
            
            Spacer()
            
            Picker(selection: $selectedOption, label: Text("")) {
                ForEach(0..<TodoItemViewConstants.importanceOptions.count, id: \.self) { index in
                    Text(TodoItemViewConstants.importanceOptions[index])
                }
            }
            .frame(width: 170, height: 32)
            .pickerStyle(SegmentedPickerStyle())
            .background(RoundedRectangle(cornerRadius: 12).fill(Colors.overlay))
            
        }
    }
    
    // MARK: - Deadline field
    
    var deadlineField: some View {
        HStack {
            VStack (alignment: .leading) {
                Text(TodoItemViewConstants.doBefore)
                
                if isOnDeadline {
                    Button (action: {
                        withAnimation {
                            isShowDatePicker.toggle()
                        }
                    }) {
                        Text(deadlineDate.formatted(.dateTime.day().month().year()))
                            .font(.footnote).bold()
                            .foregroundColor(Colors.blue)
                    }
                }
                
            }
            
            Spacer()
            
            Toggle("", isOn: $isOnDeadline)
                .onChange(of: isOnDeadline) { newValue in
                    isShowDatePicker = !newValue ? false : true
                }
        }
    }
    
    // MARK: - Date picker
    
    var datePicker: some View {
        DatePicker("", selection: $deadlineDate, in: Date()..., displayedComponents: .date)
            .datePickerStyle(.graphical)
            .onChange(of: deadlineDate) { newValue in
                isShowDatePicker = false
            }
    }
    
    // MARK: - Delete button
    
    var deleteButton: some View {
        Button {
            todoItemViewModel.didTapDeleteButton()
            dismiss()
        } label: {
            Text(TodoItemViewConstants.delete)
                .tint(textEditor.isEmpty && textEditor != TodoItemViewConstants.defaultTextEditor ? Colors.labelTertiary : Colors.red)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 17)
                .background(RoundedRectangle(cornerRadius: 17).fill(Colors.backSecondary))
        }
    }
    
    // MARK: - Controls
    
    var controls: some View {
        VStack(spacing: 17) {
            textField
            VStack(spacing: 17) {
                
                importanceField
                Divider()
                colorPicker
                Divider()
                deadlineField
            
                if isShowDatePicker {
                    Divider()
                    datePicker
                }
                
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
    
    // MARK: - Color picker
    
    var colorPicker: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(selectedColor.adjust(brightness: brightness))
                    .frame(width: 50, height: 50)
                    .padding(.leading, 8)
                Spacer(minLength: 1)
                Text("#" + String(format: "%06X", (selectedColor.rgbColor)))
                    .padding()
                Spacer()
                ColorPicker("", selection: $selectedColor)
                    .padding()
            }

            Slider(value: $brightness, in: 0.0...1.0)
                .padding()
                
        }
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
                            Button(TodoItemViewConstants.cancel) {
                                if todoItemViewModel.isNew {
                                    todoItemViewModel.didTapDeleteButton()
                                }
                                dismiss()
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                if !textEditor.isEmpty && textEditor != TodoItemViewConstants.defaultTextEditor {
                                    todoItemViewModel.didTapSaveButton(
                                        text: textEditor,
                                        importance: TodoItem.Importance(rawValue: selectedOption),
                                        deadline: isOnDeadline ? deadlineDate : nil,
                                        color: selectedColor.hexString
                                    )
                                    dismiss()
                                }
                            } label: {
                                Text(TodoItemViewConstants.save)
                                    .bold()
                                    .foregroundColor(textEditor.isEmpty ? Colors.labelTertiary : Colors.blue)
                            }
                            .disabled(textEditor.isEmpty)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
                .background(Colors.backPrimary)
            }
            .onAppear() {
                textEditor = todoItemViewModel.todoItem.text
                isOnDeadline = todoItemViewModel.todoItem.deadline == nil ? false : true
                selectedOption = todoItemViewModel.todoItem.importance.getOption(importance: todoItemViewModel.todoItem.importance)
                deadlineDate = todoItemViewModel.todoItem.deadline == nil ? Date() + 86400 : todoItemViewModel.todoItem.deadline!
                selectedColor = selectedColor.colorStringToColor(todoItemViewModel.todoItem.color)
            }
            
        }
        
    }
    
    
}

// MARK: PreView

struct TodoItemModelPreview: PreviewProvider {

    @State static var todoItemViewModel = TodoItemViewModel(
        fileCache: FileCache(),
        todoItem: .defaultItem(),
        isNew: false
    )

    static var previews: some View {
        ToDoItemView(todoItemViewModel: $todoItemViewModel)
    }
}
