//
//  TodoItemModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 23.06.2024.
//

import Foundation
import SwiftUI

enum ColorsSupport {
    static let separator: Color = Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.2)
    static let overlay: Color = Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.06)
    static let NavBarBlur: Color = Color(red: 0.98, green: 0.98, blue: 0.98, opacity: 0.8)
}
enum ColorsLabel {
    static let primary: Color = Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 1.0)
    static let secondary: Color = Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.6)
    static let tertiary: Color = Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.3)
    static let disable: Color = Color(red: 0.0, green: 0.0, blue: 0.0, opacity: 0.15)
}

enum Colors {
    static let red: Color = Color(red: 1.0, green: 0.23, blue: 0.19, opacity: 1.0)
    static let green: Color = Color(red: 0.2, green: 0.78, blue: 0.35, opacity: 1.0)
    static let blue: Color = Color(red: 0.0, green: 0.48, blue: 1.0, opacity: 1.0)
    static let gray: Color = Color(red: 0.56, green: 0.56, blue: 0.58, opacity: 1.0)
    static let grayLight: Color = Color(red: 0.82, green: 0.82, blue: 0.84, opacity: 1.0)
    static let white: Color = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
}

enum ColorsBack {
    static let iosPrimary: Color = Color(red: 0.95, green: 0.95, blue: 0.97, opacity: 1.0)
    static let primary: Color = Color(red: 0.97, green: 0.97, blue: 0.95, opacity: 1.0)
    static let secondary: Color = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
    static let elevated: Color = Color(red: 1.0, green: 1.0, blue: 1.0, opacity: 1.0)
}

struct ToDoItemModel: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss
    @State var todoItem: TodoItem?
    @State var deadlineDate: Date = Date() + 86400
    @State private var selectedOption = 0
    @State var textEditor = "Что надо сделать?"
    
    let importanceOptions = ["↓", "нет", "‼️"]
    @State var isOnDeadline = false
    @State var isShowDatePicker = false

    
    var body: some View {
        NavigationStack {
            
            ZStack {
                ColorsBack.primary
                    .ignoresSafeArea()
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 17) {
                        TextEditor(text: $textEditor)
                            .frame(minHeight: 100, maxHeight: nil)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 16).fill(ColorsBack.secondary))
                            .padding(.top)
                            .foregroundColor(textEditor == "Что надо сделать?" ? ColorsLabel.tertiary : ColorsLabel.primary)
                        
                        VStack(spacing: 17) {
                            
                            HStack {
                                Text("Важность")
                                
                                Spacer()
                                
                                Picker(selection: $selectedOption, label: Text("")) {
                                    ForEach(0..<importanceOptions.count, id: \.self) { index in
                                        Text(self.importanceOptions[index])
                                    }
                                }
                                .frame(width: 170, height: 35)
                                .background(Colors.white)
                                .pickerStyle(SegmentedPickerStyle())
                                
                            }
                            
                            Divider()
                            
                            HStack {
                                VStack (alignment: .leading) {
                                    Text("Сделать до")
                                    
                                    if isOnDeadline {
                                        Text(deadlineDate.formatted(.dateTime.day().month().year()))
                                            .font(.footnote).bold()
                                            .foregroundColor(Colors.blue)
                                            .onTapGesture {
                                                isShowDatePicker.toggle()
                                            }
                                    }
                                    
                                }
                                
                                Spacer()
                                
                                Toggle("", isOn: $isOnDeadline)
                                    .onChange(of: isOnDeadline) { newValue in
                                        isShowDatePicker = !newValue ? false : true
                                    }
                            }
                            
                            if isShowDatePicker {
                                Divider()
                                
                                DatePicker("Picker", selection: $deadlineDate, in: Date()..., displayedComponents: .date)
                                    .datePickerStyle(.graphical)

                                    .onChange(of: deadlineDate) { newValue in
                                        isShowDatePicker = false
                                    }
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 17).fill(ColorsBack.secondary))
                        
                        Button {
                            
                        } label: {
                            Text("Удалить")
                                .tint(Colors.red)
                                .frame(width: 350)
                                .padding(.vertical, 17)
                                .background(RoundedRectangle(cornerRadius: 17).fill(ColorsBack.secondary))
                        }
                        Spacer()
                    
                    }
                    .padding(.horizontal)
                    .navigationTitle("Дело")
                    .navigationBarBackButtonHidden(true)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button("Отменить") {
                                dismiss()
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                
                            } label: {
                                Text("Сохранить")
                                    .bold()
                            }
                        }
                    }
                }
            }
            .onAppear() {
                if let todoItem = todoItem {
                    textEditor = todoItem.text
                    isOnDeadline = todoItem.deadline == nil ? false : true
                    switch todoItem.importance {
                    case .unimportant:
                        selectedOption = 0
                    case .usual:
                        selectedOption = 1
                    case .important:
                        selectedOption = 2
                    }
                }
            }
            
        }
        
    }
    
}

// MARK: PreView
struct TodoItemModelPreview: PreviewProvider {
    static var previews: some View {
        ToDoItemModel(todoItem: nil)
    }
}
