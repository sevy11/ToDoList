//
//  ToodListDetailViewModel.swift
//  BranchTodoList
//
//  Created by Michael Sevy on 1/12/21.
//

import Foundation
import Combine
import SwiftUI

protocol ToDoListDetailProtocol: class {
    func fetchToDosForList(named: String)
    func addToDo(detail: String, listName: String)
    func removeToDoItem(offset: IndexSet, listName: String)
    func checkUnCheck(item: ToDo, listName: String)
}

final class TodoListDetailViewModel: ObservableObject, Identifiable, ToDoListDetailProtocol {
    @Published var testItems: [ToDo] =  [ToDo(detail: "detail one"),
                                         ToDo(detail: "detail two"),
                                         ToDo(detail: "detail three")]
    
    @Published var detailedItems = [ToDo]()
    private var details = NSMutableArray()
    private var detailDones = NSMutableArray()
    
    func fetchToDosForList(named: String) {
        guard let todoDetailsArray = UserDefaults.standard.array(forKey: "\(named)_details"),
              let detailsDoneArray = UserDefaults.standard.array(forKey: "\(named)_dones") else { return }
        
        // so now we have two arrays of type nsstring and Bool, now lets combine to one of [ToDo]
        var doneCounter = 0
        for detail in todoDetailsArray {
            guard let toDoDetails = detail as? String,
                  let done = detailsDoneArray[doneCounter] as? Bool else { return }
            
            let toDoItem = ToDo(done: done, detail: toDoDetails)
            detailedItems.append(toDoItem)
            
            doneCounter += 1
        }
    }
    
    func addToDo(detail: String, listName: String) {
        details.add(detail as NSString)
        detailDones.add(false)
      
        // Now add to local list toDos
        let newToDo = ToDo(done: false, detail: detail)
        detailedItems.append(newToDo)
        
        // Persist it
        // Key is listName_details
        UserDefaults.standard.set(details, forKey: "\(listName)_details")
        UserDefaults.standard.set(detailDones, forKey: "\(listName)_dones")
    }

    func removeToDoItem(offset: IndexSet, listName: String) {
        detailedItems.remove(atOffsets: offset)
        saveData(listName: listName)
    }
    
    func checkUnCheck(item: ToDo, listName: String) {
        let newItem = ToDo(done: !item.done, detail: item.detail)
        // Update the data source with new item, ugly way
        var updatedDetailedItems = [ToDo]()
        for todo in detailedItems {
            if todo.detail == item.detail {
                updatedDetailedItems.append(newItem)
            } else {
                updatedDetailedItems.append(todo)
            }
        }
        detailedItems = updatedDetailedItems
        
        // Persist it
        saveData(listName: listName)
    }
    
    private func saveData(listName: String) {
        details.removeAllObjects()
        detailDones.removeAllObjects()
        // Update Defaults
        for todo in detailedItems {
            details.add(todo.detail)
            detailDones.add(todo.done)
        }
        UserDefaults.standard.set(details, forKey: "\(listName)_details")
        UserDefaults.standard.set(detailDones, forKey: "\(listName)_dones")
    }
}

