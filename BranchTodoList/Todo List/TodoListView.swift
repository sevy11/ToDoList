//
//  ContentView.swift
//  BranchTodoList
//
//  Created by Michael Sevy on 1/11/21.
//

import SwiftUI
import Combine
import UIKit

struct TodoListView: View {
    @ObservedObject var viewModel = TodoListViewModel()
    @State var newListTitle = ""
    
    var body: some View {
        NavigationView {
            List {
                HStack {
                    TextField("Add A New List", text: $newListTitle)
                    Button(action: {
                        self.addList()
                    }) {
                        Text("Add")
                            .foregroundColor(.blue)
                            .bold()
                    }
                }.padding()
                ForEach(viewModel.lists, id: \.title) { list in
                    NavigationLink(destination: TodoListDetailView(toDoListTitle: list.title)) {
                        Text(list.title)
                            .bold()
                    }
                }.onDelete(perform: removeItem)
            }
            .navigationTitle("Todo Lists")
        }
        .onAppear(perform: fetchLists)
        .navigationViewStyle(DoubleColumnNavigationViewStyle())
        .padding()
        .onDisappear(perform: clearLists)
    }
    
    func fetchLists() {
        viewModel.fetchLists()
    }
    
    func addList() {
        if self.newListTitle.count > 0 {
            viewModel.addList(name: self.newListTitle, toDos: [ToDo]())
            // Clear TextField
            self.newListTitle = ""
        }
    }
    
    func removeItem(at offset: IndexSet) {
        viewModel.removeList(indexSet: offset)
    }
    
    func clearLists() {
        viewModel.lists.removeAll()
    }
}

struct TodoListView_Previews: PreviewProvider {
    static var previews: some View {
        TodoListView()
    }
}
