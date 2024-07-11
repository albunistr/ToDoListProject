//
//  DeadlineField.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import SwiftUI

struct DeadlineFieldView: View {
    @Binding var isOnDeadline: Bool
    @Binding var deadline: Date?
    @State private var isShowDatePicker: Bool = false

    var body: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text(TodoItemViewConstants.doBefore)

                    if isOnDeadline {
                        Button(action: {
                            withAnimation {
                                isShowDatePicker.toggle()
                            }
                        }) {
                            Text(deadline?.formatted(.dateTime.day().month().year()) ?? TodoItemViewConstants.defaultDeadline.formatted(.dateTime.day().month().year()))
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
        if isShowDatePicker {
            Divider()
            datePicker
        }
    }

    var datePicker: some View {
        DatePicker("Выберите дату", selection: Binding($deadline, replacingNilWith: Date()), displayedComponents: .date)
            .datePickerStyle(GraphicalDatePickerStyle())
            .padding()
            .transition(.move(edge: .top).combined(with: .opacity))
    }
}
