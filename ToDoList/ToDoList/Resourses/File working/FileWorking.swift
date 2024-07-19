//
//  FileWorking.swift
//  ToDoList
//
//  Created by Albina Akhmadieva on 18.07.2024.
//

import Foundation

extension FileCache {
    func generatingFilePath(file: String, fileType: String) -> URL? {
        guard let directory = FileManager.default.urls(for: .documentDirectory,
                                                       in: .userDomainMask).first else {
            return nil
        }
        
        let filePath = directory.appending(path: "\(file).\(fileType)")
        return filePath
    }
}
