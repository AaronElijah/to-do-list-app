//
//  AddViewController.swift
//  To Do List 2.0
//
//  Created by Aaron Elijah on 25/07/2017.
//  Copyright © 2017 Aaron Elijah. All rights reserved.
//

import UIKit
import RealmSwift

class AddViewController: UIViewController, UITextFieldDelegate {
    
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
    
    var editingMode : Bool = false
    
    var toBeEditedTitle : String = ""
    
    var priorityLevel : Int = 2
    
    @IBOutlet var titleTextField: UITextField!
    
    @IBOutlet var prioritySlider: UISlider!
    
    @IBAction func prioritySliderChanged(_ sender: Any) {
        
        priorityLevel = Int(prioritySlider.value)
        
        switch priorityLevel {
        case 0:
            priorityLabel.text = "Very Low"
        case 1:
            priorityLabel.text = "Low"
        case 2:
            priorityLabel.text = "Medium"
        case 3:
            priorityLabel.text = "High"
        case 4:
            priorityLabel.text = "Very High"
        default:
            break
        }
    }
    
    @IBOutlet var priorityLabel: UILabel!
    
    @IBOutlet var addOrUpdateButton: UIButton!

    @IBAction func add(_ sender: Any) {
        if titleTextField.text != "" {
            
            if editingMode == false {
                let newTask = Task()
                newTask.title = titleTextField.text!
                newTask.priorityLevel = priorityLevel
                newTask.date = NSDate()
            
                let realm = try! Realm()
            
                try! realm.write {
                    realm.add(newTask)
                    print("added")
                }
                
                titleTextField.text = ""
                
            } else if editingMode == true {
                let realm = try! Realm()
            
                let tasks = realm.objects(Task.self)
                let editingTask = tasks.filter("title = '\(toBeEditedTitle)'").first
                
                try! realm.write {
                    editingTask?.title = titleTextField.text!
                    editingTask?.priorityLevel = priorityLevel
                    print("updated")
                }
                
                titleTextField.text = ""
                
                if editingMode == true {
                    editingMode = false
                }
                performSegue(withIdentifier: "AddToMain", sender: self)
            }
        }
    }
    
    @IBOutlet var backButton: UIButton!
    
    @IBAction func back(_ sender: Any) {
        
        if editingMode == true {
            editingMode = false
        }
        
        performSegue(withIdentifier: "AddToMain", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(editingMode)
        print(toBeEditedTitle)
        
        if editingMode == false {
            addOrUpdateButton.setTitle("Add", for: UIControlState.normal)
            
        } else if editingMode == true {
            addOrUpdateButton.setTitle("Update", for: UIControlState.normal)
            titleTextField.text = toBeEditedTitle
            backButton.alpha = 0
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
