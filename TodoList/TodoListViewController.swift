//
//  ViewController.swift
//  TodoList
//
//  Created by 이주혜 on 2021/11/12.
//

import UIKit

class TodoListViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var textInputField: UITextField!
    @IBOutlet weak var todayButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    let viewModel = TodoListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        viewModel.loadTodos()
    }

    @IBAction func todayTapped(_ sender: Any) {
        todayButton.isSelected = !todayButton.isSelected
    }
    
    @IBAction func addTapped(_ sender: Any) {
        guard let input = textInputField.text else { return }
        
        if input.isEmpty { return }
        
        let todo = TodoManager.shared.createTodo(isToday: todayButton.isSelected, detail: textInputField.text!)
        
        viewModel.addTodo(todo)
        collectionView.reloadData()
        textInputField.text = ""
        todayButton.isSelected = false
    }
    
    @IBAction func bgTapped(_ sender: Any) {
        textInputField.resignFirstResponder()
    }
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
       
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
        
        print("--> keyboard end frame: \(keyboardFrame)")
    }
}

extension TodoListViewController : UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case 0:
            return viewModel.todayTodos.count
        default:
            return viewModel.upcomingTodos.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TodoCell", for: indexPath) as? TodoCell else {
            return UICollectionViewCell()
        }
        
        var todo: Todo
        if indexPath.section == 0 {
            todo = viewModel.todayTodos[indexPath.item]
        } else {
            todo = viewModel.upcomingTodos[indexPath.item]
        }
        
        cell.update(todo)
        
        cell.doneButtonHandler = { isDone in
            todo.isDone = isDone
            self.viewModel.updateTodo(todo)
            self.collectionView.reloadData()
        }
        
        cell.deleteButtonHandelr = {
            self.viewModel.deleteTodo(todo)
            self.collectionView.reloadData()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else { return UICollectionReusableView() }
            
            guard let section = TodoListViewModel.Section(rawValue: indexPath.section) else { return UICollectionReusableView() }
            header.title.text = section.title
            
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
}

extension TodoListViewController : UICollectionViewDelegate {
    
}

extension TodoListViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width
        let height: CGFloat = 50
        
        return CGSize(width: width, height: height)
    }
}

