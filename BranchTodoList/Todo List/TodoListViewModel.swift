//
//  TodoListVIewModel.swift
//  BranchTodoList
//
//  Created by Michael Sevy on 1/11/21.
//

import Foundation
import Combine
import SwiftUI

protocol ToDoListProtocol: class {
    func addList(name: String, toDos: [ToDo])
    func removeList(indexSet: IndexSet)
    func fetchLists()
}

final class TodoListViewModel: ObservableObject, Identifiable, ToDoListProtocol {
    @Published var testLists: [ToDoList] =  [ToDoList(title: "List 1",
                                         toDos: [
                                        ToDo(done: false, detail: "List One detail 1"),
                                        ToDo(done: false, detail: "List One detail 2"),
                                        ToDo(done: true, detail: "List One detail 3")]),
                                 ToDoList(title: "List 2", toDos: [
                                        ToDo(done: false, detail: "List Two detail 1"),
                                        ToDo(done: false, detail: "List Two detail 2")])
    ]
    @Published var lists = [ToDoList]()
    private var listTitles = NSMutableArray()
    
    func addList(name: String, toDos: [ToDo]) {
        // Copy the [List] to the titles NSString list from UserDefaults
        for list in lists {
            listTitles.add(list.title as NSString)
        }
        listTitles.add(name as NSString)
        
        // Now add the lsit name to the self.lists
        let newList = ToDoList(title: name, toDos: toDos)
        lists.append(newList)
        // Persist via UserDefaults
        UserDefaults.standard.set(listTitles, forKey: "lists")
    }
    
    func removeList(indexSet: IndexSet) {
        lists.remove(atOffsets: indexSet)
        // Update UserDefaults
        for list in lists {
            listTitles.add(list.title as NSString)
        }
        UserDefaults.standard.set(listTitles, forKey: "lists")
    }
    
    func fetchLists() {
        guard let listArray = UserDefaults.standard.array(forKey: "lists") else { return }
        for name in listArray {
            guard let listName = name as? String else { return }
            let toDoList = ToDoList(title: listName)
            self.lists.append(toDoList)
        }
    }
}
