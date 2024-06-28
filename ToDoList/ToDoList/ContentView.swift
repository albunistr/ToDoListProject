//
//  ContentView.swift
//  ToDoList
//
//  Created by Powers Mikaela on 6/18/24.
//

import SwiftUI

struct ContentView: View {
    private let fileCache = FileCache()
    //for testing I put testingFileCache^ for opening clear app put fileCache
    
    var body: some View {
        TodoListView(todoListViewModel: TodoListViewModel(fileCache: testingFileCache))
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
