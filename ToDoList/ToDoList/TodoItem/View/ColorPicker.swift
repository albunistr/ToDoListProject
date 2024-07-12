//
//  ColorPicker.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 08.07.2024.
//

import SwiftUI

struct ColorPickerView: View {
    @Binding var selectedColor: Color
    @State var opacityValue: Double = 0.5
    @State var brightness: Double = 1.0

    var body: some View {
        VStack {
            HStack {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(selectedColor.adjust(brightness: brightness))
                    .frame(width: 50, height: 50)
                    .padding(.leading, 8)
                Spacer(minLength: 1)
                Text("#" + String(format: "%06X", selectedColor.rgbColor))
                    .padding()
                Spacer()
                ColorPicker("", selection: $selectedColor)
                    .padding()
            }

            Slider(value: $brightness, in: 0.0 ... 1.0)
                .padding()
        }
    }
}
