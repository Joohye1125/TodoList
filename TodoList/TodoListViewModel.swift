//
//  TodoListViewModel.swift
//  TodoList
//
//  Created by 이주혜 on 2021/11/13.
//

import Foundation

class TodoListViewModel{
    
    private let todoManager = TodoManager.shared
    
    enum Section : Int, CaseIterable {
        case today 
        case upcoming
        
        var title: String {
            switch self {
            case .today: return "Today"
            default : return "Upcoming"
            }
        }
    }
    
    var todos: [Todo] {
        return todoManager.todos
    }
    
    var todayTodos: [Todo]{
        return todos.filter { todo in
            return todo.isToday
        }
    }
    
    var upcomingTodos: [Todo] {
        return todos.filter { todo in
            return !todo.isToday
        }
    }
    
    var numOfSections: Int {
        return Section.allCases.count
    }
    
    func loadTodos(){
        todoManager.retrieveTodo()
    }
    
    func addTodo(_ todo: Todo){
        todoManager.addTodo(todo)
    }
    
    func deleteTodo(_ todo: Todo){
        todoManager.deleteTodo(todo)
    }
    
    func updateTodo(_ todo: Todo){
        todoManager.updateTodo(todo)
    }
    
}
