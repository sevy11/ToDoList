//
//  TodoList.swift
//  BranchTodoList
//
//  Created by Michael Sevy on 1/11/21.
//

import Foundation
import SwiftUI

struct ToDoList: Identifiable {
    var id = UUID()
    var title: String
    var toDos: [ToDo]
    
    init(title: String, toDos: [ToDo] = [ToDo]()) {
        self.title = title
        self.toDos = toDos
    }
}

struct ToDo: Identifiable {
    var id = UUID()
    var done: Bool
    var detail: String
    
    init(done: Bool = false, detail: String = "") {
        self.done = done
        self.detail = detail
    }
}
