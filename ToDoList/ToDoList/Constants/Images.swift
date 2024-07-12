//
//  Images.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/27/24.
//

import SwiftUI
import UIKit

enum Images {
    static let calendar = Image("Calendar" )
    static let completed = Image("completed")
    static let highPriority = Image("highPriority")
    static let iconPickerHighPriority = Image("iconPickerHighPriority")
    static let iconPickerLowPriority = Image("iconPickerLowPriority")
    static let modeLight = Image("modeLight")
    static let plus = Image("Plus")
    static let plusLight = Image("plusLight")
    static let propOff = Image("propOff")
    static let cell = Image("cell")
    static let trash = Image(systemName: "trash")
    static let calendarButton = Image("CalendarButton")
    static let info = Image(systemName: "info.circle")
}

enum ImagesUIKit {
    static let completed = UIImage(named: "completed")
    static let plus = UIImage(named: "Plus")
}
