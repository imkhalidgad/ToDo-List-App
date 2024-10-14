import UIKit
import Foundation
import CoreData

class TodoStorage {
    
    // function to Store the todo in CoreData(DataBase)
    static func storeTodo(todo:ToDo){
        // As we know that container is set up in the AppDelegates so we need to refer that container.
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        // We need to create a context from this container
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Now let's create an entity and new todo records.
        guard let todoEntity = NSEntityDescription.entity(forEntityName: "Todo", in: managedContext) else {return}
        
        // final, we need to add some data to our newly created record for each keys using
        let todoObject = NSManagedObject.init(entity: todoEntity, insertInto: managedContext)
        todoObject.setValue(todo.title, forKey: "title")
        todoObject.setValue(todo.details, forKey: "details")
        todoObject.setValue(todo.date, forKey: "date")
        if let image = todo.image{
            let imageData = image.jpegData(compressionQuality: 1)
            todoObject.setValue(imageData, forKey: "image")
        }
        
        // Now we have set all the values. The next step is to save them inside the Core Data
        do {
            try managedContext.save()
            print("======== Success ========")
        } catch let error as NSError {
            
            //                let alert = UIAlertController(title: "Error !!", message: "Can't Store This ToDo, Please Try Again!", preferredStyle: UIAlertController.Style.alert)
            //
            //                let action = UIAlertAction(title: "Okay", style: UIAlertAction.Style.default, handler: nil)
            //
            //                alert.addAction(action)
            //                self.present(alert, animated: true, completion: nil)
            
            print("======== Error ========")
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    // function to return the todo from CoreData(DataBase) to show it
    static func getTodos() -> [ToDo] {
        var todos: [ToDo] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return []}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            for managedTodo in result {
                let title = managedTodo.value(forKey: "title") as? String
                let details = managedTodo.value(forKey: "details") as? String
                let date = managedTodo.value(forKey: "date") as? String
                
                var image:UIImage? = nil
                if let imageFromContext = managedTodo.value(forKey: "image") as? Data {
                    image = UIImage(data: imageFromContext)
                }
                
                
                let todo = ToDo(title: title ?? "", image: image, details: details ?? "", date: date ?? "")
                todos.append(todo)
            }
        } catch {
            print("======= Failed =======")
        }
        
        return todos
    }
    
    
    
    // function to update the todo from CoreData(DataBase) to updated
    static func updateTodo(todo: ToDo, index:Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            result[index].setValue(todo.title, forKey: "title")
            result[index].setValue(todo.details, forKey: "details")
            result[index].setValue(todo.date, forKey: "date")
            if let image = todo.image{
                let imageData = image.jpegData(compressionQuality: 1)
                result[index].setValue(imageData, forKey: "image")
            }
            
            try context.save()
        } catch {
            print("======= Failed =======")
        }
    }
    
    
    // function to delete the todo from CoreData(DataBase) to deleted
    static func deleteTodo(index:Int){
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {return}
        
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Todo")
        
        do {
            let result = try context.fetch(fetchRequest) as! [NSManagedObject]
            
            let todoToDelete = result[index]
            context.delete(todoToDelete)
            
            try context.save()
        } catch {
            print("======= Failed =======")
        }
    }
    
}
