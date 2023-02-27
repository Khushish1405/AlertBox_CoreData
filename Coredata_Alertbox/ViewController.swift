//
//  ViewController.swift
//  Coredata_Alertbox
//
//  Created by Jaimin Solanki on 24/02/23.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    var names: [NameData] = []
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadName()
    }
    
    @IBAction func addButton(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Data", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add", style: .default) { (action) in
            
            let newName = NameData(context: self.context)
            newName.name = textField.text!
            
            self.names.append(newName)
            
            self.saveName()
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            print("Cancel")
        })
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Enter Your name:"
        }
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Data Manipulation Methods
    
    func saveName() {
        do {
            try context.save()
        } catch {
            print("Error saving category \(error)")
        }
        
        tableview.reloadData()
    }
    
    func loadName() {
        
        let request : NSFetchRequest<NameData> = NameData.fetchRequest()
        
        do{
            names = try context.fetch(request)
        } catch {
            print("Error loading names \(error)")
        }
        
        tableview.reloadData()
    }
}

//MARK: - Delegate and Datasource Methods

extension ViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return names.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! TableViewCell
        cell.nameLabel.text = names[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        var name = names[indexPath.row]
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Update Data", message: "", preferredStyle: .alert)
        let alert1 = UIAlertController(title: "Data Updated...!", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Update", style: .default) { (action) in
            
            let newName = NameData(context: self.context)
            newName.name = textField.text!
            
//            let fetchrequest: NSFetchRequest<NameData> = NameData.fetchRequest()
//            fetchrequest.predicate = NSPredicate(format: "name", newName)
//            let person = try? NSManagedObjectContext.fetch(fetchrequest).first
            
            
            self.names.append(newName)

            self.saveName()
            
            let action1 = UIAlertAction(title: "Ok", style: .default) { action1 in

                print("data Updated")
            }

            alert1.addAction(action1)
            
            self.present(alert1, animated: true, completion: nil)
            
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .destructive, handler: { action in
            print("Cancel")
        })
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        alert.addTextField { (field) in
            textField = field
            textField.placeholder = "Update data:"
        }
        
        present(alert, animated: true, completion: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            
            let commit = names[indexPath.row]
            context.delete(commit)
            names.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            saveName()
        }
    }
}



