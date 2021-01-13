//
//  TodoListDetailView.swift
//  BranchTodoList
//
//  Created by Michael Sevy on 1/12/21.
//

import SwiftUI
import Combine

struct TodoListDetailView: View {
    var toDoListTitle: String
    @ObservedObject var viewModel = TodoListDetailViewModel()
    @State private var toDoDetails = ""
    
    var body: some View {
        List {
            HStack {
                TextField("Add item to list", text: $toDoDetails)
                Button(action: {
                    self.addItem()
                }) {
                    Text("Add")
                        .foregroundColor(.blue)
                        .bold()
                }
            }.padding()
            ForEach(viewModel.detailedItems) { todo in
                HStack {
                    // List with all the todo details
                    Button(action: {
                        checkUnCheck(item: todo)
                    }) {
                        if todo.done {
                            ZStack {
                                Rectangle()
                                    .stroke(Color.red, lineWidth: 5)
                                    .frame(width: 25, height: 25)
                                    .cornerRadius(2)
                                Image(systemName: "checkmark")
                                    .foregroundColor(.red)
                                    .frame(width: 25, height: 25)
                            }
                        } else {
                            Rectangle()
                                .stroke(Color.gray, lineWidth: 5)
                                .frame(width: 25, height: 25)
                                .cornerRadius(2)
                        }
                    }
                    Text(todo.detail)
                }
            }.onDelete(perform: removeItem)
        }.onAppear(perform: fetchToDos)
        .navigationTitle(toDoListTitle)
        .onDisappear(perform: clearToDos)
    }
    
    private func fetchToDos() {
        viewModel.fetchToDosForList(named: toDoListTitle)
    }
    
    private func addItem() {
        if self.toDoDetails.count > 0 {
            viewModel.addToDo(detail: self.toDoDetails, listName: toDoListTitle)
            // Clear TextField
            self.toDoDetails = ""
        }
    }
    
    func removeItem(at offset: IndexSet) {
        viewModel.removeToDoItem(offset: offset, listName: toDoListTitle)
    }
    
    func checkUnCheck(item: ToDo) {
        viewModel.checkUnCheck(item: item, listName: toDoListTitle)
    }
    
    func clearToDos() {
        viewModel.detailedItems.removeAll()
    }
}

struct TodoListDetailView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListDetailView(toDoListTitle: "Test List 1")
    }
}
