//
//  ToDosVC.swift
//  ToDoList
//
//  Created by Khalid Gad on 08/04/2024.
//

import UIKit
import CoreData

class ToDosVC: UIViewController {
    
    var todosArray:[ToDo] = [
        ToDo(title: "Waking Up", image: UIImage.wakingUpimg, details: "Get up in 5 AM"),
        ToDo(title: "Breakfast", image: UIImage.eatingimg, details: "Eating Breakfast(Honey outmeal) with my fav drink a Coffe in 6 AM"),
        ToDo(title: "Training", image: UIImage.trainingimg, details: "Go to the Gym and training Legs & Chest from 7AM to 9AM"),
        ToDo(title: "Test-1"),
        ToDo(title: "Shower", image: UIImage.showerimg),
        ToDo(title: "Studing", image: UIImage.studingimg, details: """
             Studing from 10AM to 5PM
             2 hours for a iOS Course, then have a 30min break
             2 hours for Collage Courses then 30 min break
             2 hours for doing Assignments & Tasks
             """),
        ToDo(title: "Lunch ", image: UIImage.eatingimg, details: "Have Lunch in 5:30PM"),
        ToDo(title: "Test-2"),
        ToDo(title: "Friends Time", image: UIImage.friendsimg, details: "Go to the Club with my Friends at 6PM"),
        ToDo(title: "Watch a Movie", image: UIImage.watchingMovieimg, details: "watch a movie from Marvel at 9PM with eating a dinner & some snacks"),
        ToDo(title: "Reading", image: UIImage.readingimg, details: "Reading a 20 page of The subtle art of not giving a fuck"),
        ToDo(title: "Test-3", image: nil),
        ToDo(title: "Sleeping", image: UIImage.sleepingimg, details: "Sleeping at oo:oo")
    ]
    
    @IBOutlet weak var todosTableView: UITableView!
    
    override func viewDidLoad() {
        
        // this is for Todo list with a DataBase
        self.todosArray = TodoStorage.getTodos()
        
        super.viewDidLoad()
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
        // notification for Add ToDo
        NotificationCenter.default.addObserver(self, selector: #selector (newTodoAdded), name: NSNotification.Name(rawValue: "NewTodoAdded"), object: nil)
        
        // notification for Update ToDo
        NotificationCenter.default.addObserver(self, selector: #selector (CurrentToDoUpdated), name: NSNotification.Name(rawValue: "CurrentToDoUpdated"), object: nil)
        
        // notification for Delete ToDo
        NotificationCenter.default.addObserver(self, selector: #selector (CurrentToDoDeleted), name: NSNotification.Name(rawValue: "CurrentToDoDeleted"), object: nil)
    }
    
    // function for Add ToDo
    @objc func newTodoAdded(notification: Notification){
        
        var todo = notification.userInfo?["addTodo"] as? ToDo
        
        if let myTodo = todo {
            todosArray.append(myTodo)
            todosTableView.reloadData()
            TodoStorage.storeTodo(todo: myTodo)
        }
    }
    
    // function for Update ToDo
    @objc func CurrentToDoUpdated(notification: Notification){
        
        var todo = notification.userInfo?["TodoUpdated"] as? ToDo
        
        var todoIndex = notification.userInfo?["TodoUpdatedIndex"] as? Int
        
        if let myTodo = todo {
            if let myIndex = todoIndex {
                todosArray[myIndex] = myTodo
                todosTableView.reloadData()
                TodoStorage.updateTodo(todo: myTodo, index: myIndex)
            }
        }
    }
    
    // function for Delete ToDo
    @objc func CurrentToDoDeleted(notification: Notification){
        
        var todoIndex = notification.userInfo?["TodoDeletedIndex"] as? Int
        
        if let myIndex = todoIndex {
            todosArray.remove(at: myIndex)
            todosTableView.reloadData()
            TodoStorage.deleteTodo(index: myIndex)
        }
    }
}


extension ToDosVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        125
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(identifier: "ToDoDetailsVC") as? ToDoDetailsVC
        
        let currentCell = todosArray[indexPath.row]
        
        if let viewController = vc {
            viewController.todo = currentCell
            viewController.navigationItem.title = currentCell.title
            
            viewController.index = indexPath.row
            
            navigationController?.pushViewController(viewController, animated: true)
            
            //present(viewController, animated: true)
        }
    }
}


extension ToDosVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todosArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell") as! ToDoCell
        
        let currentCell = todosArray[indexPath.row]
        
        cell.todoTitleLabel.text = currentCell.title
        cell.todoDateLabel.text = currentCell.date
        
        if currentCell.image != nil {
            cell.todoImage.image = currentCell.image
        } else {
            cell.todoImage.image = UIImage.noimg
        }
        cell.todoImage.layer.cornerRadius = cell.todoImage.frame.height/2
        
        return cell
    }
}

