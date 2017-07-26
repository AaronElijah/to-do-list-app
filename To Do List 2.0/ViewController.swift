//
//  ViewController.swift
//  To Do List 2.0
//
//  Created by Aaron Elijah on 25/07/2017.
//  Copyright © 2017 Aaron Elijah. All rights reserved.
//

import UIKit
import RealmSwift

class Task : Object {
    dynamic var title : String = ""
    dynamic var priorityLevel : Int = 0
    dynamic var date = NSDate()
}

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    /*
     //////////////////////// Useful code for seeing how RealmSwift works
     
     class Dog : Object {
     dynamic var name = ""
     dynamic var age = 0
     dynamic var birtdate = NSDate()
     dynamic var height = 0.0
     dynamic var vaccinated = true
     }
     
     //////// Adding new objects to a Realm
     
     let newDog = Dog()
     newDog.name = "Earl Yippie Scum III"
     newDog.age = 5
     newDog.birthdate = NSDate()
     newDog.height = 40.0
     newDog.vaccinated = true
     
     let realm = Realm()
     realm.write {
     realm.add(newDog)
     }
     
     //////// Reading objects
     
     let dogs = Realm().objects(Dog)
     let puppies = dogs.filter("age < 2")
     let sortedPuppies = puppies.sort("name")
     
     //////// Updating objects
     
     let dog = Realm().objects(Dog).first
     
     Realm.write() {
     dog.name = "Jabba the Mutt"
     }
     */
 
    
    var taskTitles : [String] = [String]()
    
    var toBeEditedTitle : String = String()
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var nameTextField: UITextField!
    
    @IBAction func addTask(_ sender: Any) {
        
        // perform it's own segue to the AddViewController
        
    }
    
    @IBAction func dateSort(_ sender: Any) {
        let realm = try! Realm()
        
        let tasks = realm.objects(Task.self)
        let dateTasks = tasks.sorted(byKeyPath: "date", ascending: true)
        
        taskTitles.removeAll()
        
        for i in 0..<dateTasks.count {
            let task = dateTasks[i]
            print(task.title)
            print(task.priorityLevel)
            print(task.date)
            taskTitles.append(task.title)
        }
        
        tableView.reloadData()
        
    }
    
    @IBAction func prioritySort(_ sender: Any) {
        let realm = try! Realm()
        
        let tasks = realm.objects(Task.self)
        let priorityTasks = tasks.sorted(byKeyPath: "priorityLevel", ascending: false)
        
        taskTitles.removeAll()
        
        for i in 0..<priorityTasks.count {
            let task = priorityTasks[i]
            print(task.title)
            print(task.priorityLevel)
            print(task.date)
            taskTitles.append(task.title)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

    }
    
    override func viewDidAppear(_ animated: Bool) {
        let realm = try! Realm()
        
        let tasks = realm.objects(Task.self)
        print(tasks.count)
        
        for i in 0..<tasks.count {
            let task = tasks[i]
            print(task.title)
            print(task.priorityLevel)
            print(task.date)
            taskTitles.append(task.title)
        }
        tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskTitles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = taskTitles[indexPath.row]
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Edit the task by sending it to the AddViewController view
        
        toBeEditedTitle = taskTitles[indexPath.row]
        
        performSegue(withIdentifier: "MainToAdd", sender: self)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
         if editingStyle == UITableViewCellEditingStyle.delete {
            
            // Delete the task from Realm
            
            let realm = try! Realm()
            
            let tasks = realm.objects(Task.self)
            
            if let deleteTask = tasks.filter("title = '\(taskTitles[indexPath.row])'").first {
            
                try! realm.write {
                    realm.delete(deleteTask)
                }
            }
            
            taskTitles.remove(at: indexPath.row)
            
            tableView.reloadData()
        }
    }
    
    @IBAction func titleSearch(_ sender: Any) {
        if nameTextField.text != "" {
            let realm = try! Realm()
            
            let tasks = realm.objects(Task.self)
            let text : String  = nameTextField.text!
            let namedTasks = tasks.filter("title = '\(text)'")
            
            if namedTasks.count > 0 {
                taskTitles.removeAll()
                
                for i in 0..<namedTasks.count {
                    let task = namedTasks[i]
                    print(task.title)
                    print(task.priorityLevel)
                    print(task.date)
                    taskTitles.append(task.title)
                }
                tableView.reloadData()
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "MainToAdd" {
            let controller = (segue.destination) as! AddViewController
            
            controller.editingMode = true
            controller.toBeEditedTitle = toBeEditedTitle
            
            
        }
    }
}

