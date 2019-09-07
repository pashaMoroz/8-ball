//
//  TableViewSettingControllerTableViewController.swift
//  8-Ball
//
//  Created by Pasha Moroz on 9/4/19.
//  Copyright © 2019 Pavel Moroz. All rights reserved.
//

import UIKit
import CoreData

class TableViewSettingControllerTableViewController: UITableViewController {
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let cellID = "cell"
    private var answers = [NSManagedObject]()
    
    
    // MARK: - Life cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setting()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CustAnswer")
        
        do {
            answers = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }
    
    
    // MARK: - Logic
    
    @objc private func addNewTask() {
        
        let alert = UIAlertController(title: "Add new answer", message: "", preferredStyle: .alert)
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            
            guard let task = alert.textFields?.first?.text, task.isEmpty == false else { return }
            self.saveData(task)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    private func saveData(_ taskName: String) {
        
        let managedContext = appDelegate.persistentContainer.viewContext // Создание объекта Managed Object Context
        guard let entity = NSEntityDescription.entity(forEntityName: "CustAnswer", in: managedContext) else { return } // Создаение объекта сущности
        let task = NSManagedObject(entity: entity, insertInto: managedContext) as! CustAnswer // Экземпляр модели Answer
        task.custAnswer = taskName // Присваиваем значение свойству name
        
        do {
            try managedContext.save()
            answers.append(task)
        } catch let error {
            print("Failed to save task", error.localizedDescription)
        }
    }
    
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") {
            _, indexPath in
            
            
            let container = self.appDelegate.persistentContainer
            container.viewContext.delete(self.answers[indexPath.row])
            self.appDelegate.saveContext()
            
            self.answers.remove(at: indexPath.row)
            tableView.reloadData()
            
        }
        
        return [deleteAction]
    }
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return answers.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        let task = answers[indexPath.row]
        cell.textLabel?.text = task.value(forKeyPath: "custAnswer") as? String
        
        return cell
    }
    
    private func setting() {
        
        title = "Answer Options"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Add",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(addNewTask))
        
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.backItem?.backBarButtonItem?.tintColor = .black
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
    }
}
