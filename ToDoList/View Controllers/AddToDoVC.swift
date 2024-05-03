//
//  AddToDoVC.swift
//  ToDoList
//
//  Created by Khalid Gad on 14/04/2024.
//

import UIKit

class AddToDoVC: UIViewController {

    var isCreationSC = true
    var editedTodo: ToDo?
    var editedTodoIndex: Int?

    @IBOutlet weak var titleAddTodoSC: UILabel!
    @IBOutlet weak var newImageToDo: UIImageView!
    @IBOutlet weak var newToDoTitle: UITextField!
    @IBOutlet weak var newToDoDetails: UITextView!
    @IBOutlet weak var addTodoBTN: UIButton!
    @IBOutlet weak var changeImageBTN: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addTodoBTN.layer.cornerRadius = 18
        addTodoBTN.layer.masksToBounds = true
        
        if !isCreationSC {
            
            navigationItem.title = "Update"
            titleAddTodoSC.text = "Edit a To-do"
            addTodoBTN.setTitle("Update", for: .normal)
            
            if let todo = editedTodo{
                newToDoTitle.text = todo.title
                newToDoDetails.text = todo.details
                newImageToDo.image = todo.image
                
                changeImageBTN.setImage(UIImage.init(systemName: "pencil"), for: .normal)
            }
        }
        
        changeImageBTN.layer.cornerRadius = 10
        changeImageBTN.layer.masksToBounds = true
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addToDoButtton(_ sender: Any) {

        if isCreationSC { // if the VC opened for Add
            
            let todo = ToDo(title: newToDoTitle.text ?? "", image: newImageToDo.image, details: newToDoDetails.text, date: getCurrentShortDate())
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil, userInfo: ["addTodo":todo])
            
            let alert = UIAlertController(title: "To-Do Added", message: "Your To-Do is Added Successfully", preferredStyle: UIAlertController.Style.alert)
            
            let closeAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {_ in self.tabBarController?.selectedIndex = 0
                self.newToDoTitle.text = ""
                self.newToDoDetails.text = ""
                self.newImageToDo.image = UIImage.noimg
            })
            
            alert.addAction(closeAction)
            
            self.present(alert, animated: true, completion: nil)
        
        } else { // if the VC opened for update
            
            let todo = ToDo(title: newToDoTitle.text ?? "", image: newImageToDo.image, details: newToDoDetails.text, date: getCurrentShortDate())
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "CurrentToDoUpdated"), object: nil, userInfo: ["TodoUpdated": todo, "TodoUpdatedIndex": editedTodoIndex!])
            
            
            let alert = UIAlertController(title: "To-Do Updated", message: "Your To-Do is Updated Successfully", preferredStyle: UIAlertController.Style.alert)

            let closeAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default, handler: {_ in self.navigationController?.popViewController(animated: true)
             //   self.navigationController?.popViewController(animated: true)
                self.newToDoTitle.text = ""
                self.newToDoDetails.text = ""
            })
            
            alert.addAction(closeAction)
            
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func getCurrentShortDate() -> String {
        var todaysDate = NSDate()
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        var DateInFormat = dateFormatter.string(from: todaysDate as Date)
        
        return DateInFormat
    }
    
    
    
    @IBAction func changeImageButton(_ sender: Any) {
        
        let imagePaker = UIImagePickerController()
        imagePaker.delegate = self
        imagePaker.allowsEditing = true
        present(imagePaker, animated: true, completion: nil)
        
    }

}

extension AddToDoVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        dismiss(animated: true)
        newImageToDo.image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage
    }
    
}
