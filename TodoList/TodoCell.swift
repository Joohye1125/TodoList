//
//  CollectionViewCell.swift
//  TodoList
//
//  Created by 이주혜 on 2021/11/12.
//

import UIKit

class TodoCell: UICollectionViewCell {
    
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var strikeThroughView: UIView!
    @IBOutlet weak var strikeThoughViewWidth: NSLayoutConstraint!
    
    var doneButtonHandler: ((Bool) -> Void)?
    var deleteButtonHandelr: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        reset()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        reset()
    }
    
    func update(_ todo : Todo){
        self.checkButton.isSelected = todo.isDone
        self.deleteButton.isHidden = !todo.isDone
        detailLabel.text = todo.detail
        detailLabel.alpha = todo.isDone ? 0.2 : 1
        showStrikeThroughView(todo.isDone)
    }
    
    func showStrikeThroughView(_ isDone: Bool){
        
        if isDone {
            strikeThoughViewWidth.constant = detailLabel.bounds.width
        } else {
            strikeThoughViewWidth.constant = 0
        }
    }
    
    func reset(){
        
        showStrikeThroughView(false)
        checkButton.isSelected = false
        deleteButton.isHidden = false
        detailLabel.alpha = 1
        
    }
    
    @IBAction func checkButtonTapped(_ sender: Any){
        
        checkButton.isSelected = !checkButton.isSelected
        
        let isDone = checkButton.isSelected
        showStrikeThroughView(isDone)
        detailLabel.alpha = isDone ? 0.2 : 1
        deleteButton.isHidden = !isDone
        
        doneButtonHandler?(isDone)
    }
    
    @IBAction func deleteButtonTapped(_ sender : Any){
        deleteButtonHandelr?()
    }
    
}
