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
        viewModel.removeToDoItem(indexSet: offset, listName: toDoListTitle)
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
