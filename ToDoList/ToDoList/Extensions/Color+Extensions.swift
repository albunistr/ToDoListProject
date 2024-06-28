//
//  Colo+Extensions.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/28/24.
//
import Foundation
import SwiftUI

extension Color {
    var hexString: String {
        let components = self.cgColor?.components ?? [0, 0, 0]
        let red = Int(components[0] * 255.0)
        let green = Int(components[1] * 255.0)
        let blue = Int(components[2] * 255.0)
        
        return String(format: "#%02X%02X%02X", red, green, blue)
    }
    
    func colorStringToColor(_ colorString: String) -> Color {
            var formattedColorString = colorString

            if formattedColorString.hasPrefix("#") {
                formattedColorString.remove(at: formattedColorString.startIndex)
            }
            
            guard formattedColorString.count == 6 else {
                return .white
            }
            

            let red = Double(Int(formattedColorString.prefix(2), radix: 16) ?? 0) / 255.0
            let green = Double(Int(formattedColorString.dropFirst(2).prefix(2), radix: 16) ?? 0) / 255.0
            let blue = Double(Int(formattedColorString.dropFirst(4).prefix(2), radix: 16) ?? 0) / 255.0
            
            return Color(red: red, green: green, blue: blue)
    }
}

extension Color {
    var rgbColor: UInt32 {
        let components = UIColor(self).cgColor.components!
        let r = UInt32(components[0] * 255.0) << 16
        let g = UInt32(components[1] * 255.0) << 8
        let b = UInt32(components[2] * 255.0)
        return r + g + b
    }
    
    func adjust(brightness: Double) -> Color {
        Color(UIColor(self).adjusted(by: CGFloat(brightness)))
    }
}

extension UIColor {
    func adjusted(by factor: CGFloat) -> UIColor {
        var hue: CGFloat = 0,
            saturation: CGFloat = 0,
            brightness: CGFloat = 0,
            alpha: CGFloat = 0
        
        getHue(&hue,
               saturation: &saturation,
               brightness: &brightness,
               alpha: &alpha)
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness * factor, alpha: alpha)
    }
}


