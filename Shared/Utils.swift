//
//  Utils.swift
//  pix
//
//  Created by Maxime Nory on 2021-12-28.
//

import Foundation
import SwiftUI

extension Color {
    init?(hex: String) {
        var str = hex
        if str.hasPrefix("#") {
            str.removeFirst()
        }
        if str.count == 3 {
            str = String(repeating: str[str.startIndex], count: 2)
            + String(repeating: str[str.index(str.startIndex, offsetBy: 1)], count: 2)
            + String(repeating: str[str.index(str.startIndex, offsetBy: 2)], count: 2)
        } else if !str.count.isMultiple(of: 2) || str.count > 8 {
            return nil
        }
        let scanner = Scanner(string: str)
        var color: UInt64 = 0
        scanner.scanHexInt64(&color)
        if str.count == 2 {
            let gray = Double(Int(color) & 0xFF) / 255
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: 1)
        } else if str.count == 4 {
            let gray = Double(Int(color >> 8) & 0x00FF) / 255
            let alpha = Double(Int(color) & 0x00FF) / 255
            self.init(.sRGB, red: gray, green: gray, blue: gray, opacity: alpha)
        } else if str.count == 6 {
            let red = Double(Int(color >> 16) & 0x0000FF) / 255
            let green = Double(Int(color >> 8) & 0x0000FF) / 255
            let blue = Double(Int(color) & 0x0000FF) / 255
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: 1)
        } else if str.count == 8 {
            let red = Double(Int(color >> 24) & 0x000000FF) / 255
            let green = Double(Int(color >> 16) & 0x000000FF) / 255
            let blue = Double(Int(color >> 8) & 0x000000FF) / 255
            let alpha = Double(Int(color) & 0x000000FF) / 255
            self.init(.sRGB, red: red, green: green, blue: blue, opacity: alpha)
        } else {
            return nil
        }
    }
    
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        
        UIColor(self).getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}

extension Date {
    static var currentTimeStamp: Int64{
        return Int64(Date().timeIntervalSince1970 * 1000)
    }
}

func convertDateToTimestamp (date: Date) -> Int64 {
    return Int64(date.timeIntervalSince1970 * 1000)
}

func dropBucket (data: [Pixel], dropIndex: Int, color: String, initialColor: String, initialData: [Pixel]) -> [Pixel] {
    var newData = data
    
    let topIndex = dropIndex - Int(ART_SIZE)
    let bottomIndex = dropIndex + Int(ART_SIZE)
    let leftIndex = dropIndex - 1
    let rightIndex = dropIndex + 1
    
    newData[dropIndex] = Pixel(color: color)
    
    if (topIndex >= 0 && newData[topIndex].color == initialColor && newData[topIndex].color != color) {
        newData = dropBucket(data: newData, dropIndex: topIndex, color: color, initialColor: initialColor, initialData: initialData)
    }
    
    if (bottomIndex < (Int(ART_SIZE * ART_SIZE)) && newData[bottomIndex].color == initialColor && newData[bottomIndex].color != color) {
        newData = dropBucket(data: newData, dropIndex: bottomIndex, color: color, initialColor: initialColor, initialData: initialData)
    }
    
    if ((leftIndex + 1) % Int(ART_SIZE) != 0 && newData[leftIndex].color == initialColor) {
        newData = dropBucket(data: newData, dropIndex: leftIndex, color: color, initialColor: initialColor, initialData: initialData)
    }
    
    if (rightIndex % Int(ART_SIZE) != 0 && newData[rightIndex].color == initialColor && newData[rightIndex].color != color) {
        newData = dropBucket(data: newData, dropIndex: rightIndex, color: color, initialColor: initialColor, initialData: initialData)
    }
    
    return newData
}

extension Bundle {
    var releaseVersionNumber: String? {
        return infoDictionary?["CFBundleShortVersionString"] as? String
    }
    var buildVersionNumber: String? {
        return infoDictionary?["CFBundleVersion"] as? String
    }
}

