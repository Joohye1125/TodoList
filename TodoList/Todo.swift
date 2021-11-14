//
//  Todo.swift
//  TodoList
//
//  Created by 이주혜 on 2021/11/13.
//

import Foundation

struct Todo : Codable, Equatable {
    let id: Int
    
    var isDone: Bool
    var isToday: Bool
    var detail: String
    
    mutating func update(isDone: Bool, isToday: Bool, detail: String){
        self.isDone = isDone
        self.isToday = isToday
        self.detail = detail
    }
    
    static func == (lhs: Todo, rhs: Todo) -> Bool{
        return lhs.id == rhs.id
    }
}

class TodoManager{
    
    static let shared = TodoManager()
    static var lastId: Int = 0
    
    var todos: [Todo] = []
    
    func createTodo(isToday: Bool, detail: String) -> Todo{
        
        let id = TodoManager.lastId + 1
        TodoManager.lastId = id
        let todo = Todo(id: id, isDone: false, isToday: isToday, detail: detail)
        
        return todo
    }
    
    func addTodo(_ todo: Todo){
        todos.append(todo)
        saveTodo()
    }
    
    func deleteTodo(_ todo: Todo){
        let todos = self.todos.filter { existingTodo in
            return existingTodo.id != todo.id
        }
        
        self.todos = todos
        
        saveTodo()
    }
    
    func updateTodo(_ todo: Todo){
        guard let index = todos.firstIndex(of: todo) else { return }
        todos[index].update(isDone: todo.isDone, isToday: todo.isToday, detail: todo.detail)
        
        saveTodo()
    }
    
    func saveTodo(){
        Storage.store(todos, to: .documents, as: "todos.json")
    }
    
    func retrieveTodo(){
        self.todos = Storage.retrive("todos.json", from: .documents, as: [Todo].self) ?? []
        let lastId = todos.last?.id ?? 0
        TodoManager.lastId = lastId
       
    }
    
}
