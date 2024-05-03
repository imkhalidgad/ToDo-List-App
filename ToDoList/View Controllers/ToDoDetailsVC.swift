//
//  ToDoDetailsVC.swift
//  ToDoList
//
//  Created by Khalid Gad on 08/04/2024.
//

import UIKit

class ToDoDetailsVC: UIViewController {

    var todo: ToDo!
    var index: Int!
    
    @IBOutlet weak var todotitleDetailsLabel: UILabel!
    @IBOutlet weak var todoDetailsLabel: UITextView!
    @IBOutlet weak var todoImageDetails: UIImageView!
    @IBOutlet weak var todoUpdateBTN: UIButton!
    @IBOutlet weak var todoDeleteBTN: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        todoUpdateBTN.layer.cornerRadius =  todoUpdateBTN.frame.width/2
        todoUpdateBTN.layer.masksToBounds = true
        
        todoDeleteBTN.layer.cornerRadius = todoDeleteBTN.frame.width/2
        todoDeleteBTN.layer.masksToBounds = true
     
        NotificationCenter.default.addObserver(self, selector: #selector (CurrentToDoUpdated), name: NSNotification.Name(rawValue: "CurrentToDoUpdated"), object: nil)

        // Do any additional setup after loading the view.
    }
    
    @objc func CurrentToDoUpdated(notification: Notification){
       
        var todo = notification.userInfo?["TodoUpdated"] as? ToDo
        
        if let myTodo = todo {
            self.todo = todo
            setupUI()
            navigationItem.title = todo!.title
        }
    }


    func setupUI(){
        todotitleDetailsLabel.text = todo!.title + " (Details)"

        if todo?.details != nil {
            todoDetailsLabel.text = todo!.details
        } else {
            todoDetailsLabel.text = "No Details"
            todoDetailsLabel.textColor = UIColor.lightGray
        }
       
        if todo?.image != nil {
            todoImageDetails.image = todo!.image
        } else {
            todoImageDetails.image = UIImage.noimg
        }

    }
    
    
    @IBAction func todoUpdateButton(_ sender: Any) {
       if let vc = storyboard?.instantiateViewController(withIdentifier: "NewToDoVC") as? AddToDoVC
        {
           vc.isCreationSC = false
           vc.editedTodo = todo
           vc.editedTodoIndex = index
           
           navigationController?.pushViewController(vc, animated: true)
       }
        
    }
    
    
    @IBAction func todoDeleteButton(_ sender: Any) {
        
        let alertCheck = UIAlertController(title: "Alert", message: "Are You Sure You Want To Delete This To-Do", preferredStyle: UIAlertController.Style.alert)
        
        let continueAction = UIAlertAction(title: "No, Continue", style: UIAlertAction.Style.default, handler: nil)
        
        let deleteAction = UIAlertAction(title: "Yes, Delete", style: UIAlertAction.Style.destructive, handler: {_ in
            self.deleteNotification()
            self.deleteSuccessfullyAlert()
            self.navigationController?.popViewController(animated: true)
        })
        
        alertCheck.addAction(deleteAction)
        alertCheck.addAction(continueAction)
        
        self.present(alertCheck, animated: true, completion: nil)
    }
    
    func deleteSuccessfullyAlert() {
        
        let alert = UIAlertController(title: "To-Do Deleted", message: "To-Do is Deleted Succefully", preferredStyle: UIAlertController.Style.actionSheet)
        
        let confirmAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.destructive, handler: {_ in self.navigationController?.popViewController(animated: true)
        })
        
        alert.addAction(confirmAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func deleteNotification() {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentToDoDeleted"), object: nil, userInfo: ["TodoDeletedIndex": index!])
    }

}
