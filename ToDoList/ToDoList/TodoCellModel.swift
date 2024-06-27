//
//  TodoCellModel.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 25.06.2024.
//

import Foundation
import SwiftUI

enum Images: String {
    case calendar
    case completed
    case highPriority
    case iconPickerHighPriority
    case iconPickerLowPriority
    case modeLight
    case plus
    case plusLight
    case propOff
}

struct TodoCellModel: View {
    var todoItem: TodoItem
    
    var body: some View {
        ZStack {
            ColorsBack.primary
                .ignoresSafeArea()
            HStack(spacing: 10) {
                Image(todoItem.isCompleted ? Images.completed.rawValue : (todoItem.importance == .important ? Images.highPriority.rawValue : Images.propOff.rawValue))
                
                if todoItem.importance == .important {
                    Image(Images.iconPickerHighPriority.rawValue)
                }
                
                if todoItem.importance == .unimportant {
                    Image(Images.iconPickerLowPriority.rawValue)
                }
                
                Text(todoItem.text)
                    .strikethrough(todoItem.isCompleted)
                    .foregroundColor(todoItem.isCompleted ? ColorsLabel.tertiary : ColorsLabel.primary)
                Spacer()
                Image(Images.modeLight.rawValue)
            }
            .padding()
            .frame(idealWidth: 375, minHeight: 56, maxHeight: 98, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 10).fill(ColorsBack.secondary))
            .padding()
        }
    }
}

// MARK: PreView
struct TodoCellPreview: PreviewProvider {
    
    static var previews: some View {
        TodoCellModel(todoItem: TodoItem(text: "Cook", importance: .usual, isCompleted: false))
    }
}
