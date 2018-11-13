//
//  TableViewController.swift
//  ShuffleTheStuff
//
//  Created by Levi Linchenko on 12/11/2018.
//  Copyright © 2018 Levi Linchenko. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let name = NameController.shared.name
        NameController.shared.name = []
        reorderSections(allNames: name)
        tableView.reloadData()
    }

   
    // MARK: - Table view data source
    var sections: [[String]] = []
    
    func shuffleSections(allNames: [String]){
        
        guard allNames.count != 0 else {return}
        if allNames.count == 1 {
            let name = allNames.first!
            sections.append([name])
            NameController.shared.name.append(name)
            return
        }
        var names = allNames
        let randomNumber = Int(arc4random_uniform(UInt32(names.count)))
        let name = names.remove(at: randomNumber)
        let randomNumber2 = Int(arc4random_uniform(UInt32(names.count)))
        let name2 = names.remove(at: randomNumber2)
        NameController.shared.name.append(contentsOf: [name, name2])
        sections.append([name, name2])
        shuffleSections(allNames: names)
        
    }
    
    func reorderSections(allNames : [String]) {
        guard allNames.count != 0 else {return}
        if allNames.count == 1 {
            let name = allNames.first!
            sections.append([name])
            NameController.shared.name.append(name)
            return
        }
        var names = allNames
        let name = names.removeFirst()
        let name2 = names.removeFirst()
        NameController.shared.name.append(contentsOf: [name, name2])
        sections.append([name, name2])
        reorderSections(allNames: names)
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
    
        return sections.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Group \(section+1)"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return sections[section].count
        
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()

        let section = sections[indexPath.section]
        let name = section[indexPath.row]
        cell.textLabel?.text = name

        return cell
    }
    

    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            let indexNumber = indexPath.section*2+indexPath.row
            sections = []
            var names = NameController.shared.name

            
            if NameController.shared.name.count % 2 != 0 {
            
                names.remove(at: indexNumber)
                NameController.shared.name = []
                reorderSections(allNames: names)
                tableView.deleteSections([tableView.numberOfSections-1], with: .fade)
            } else {
                names.remove(at: indexNumber)
                NameController.shared.name = []
                reorderSections(allNames: names)
                tableView.deleteRows(at: [IndexPath(item: 1, section: tableView.numberOfSections-1)], with: .fade)
            }
            
            
        }
        NameController.shared.saveToPersistentStorage()
        tableView.reloadData()
    }


  
    
    
    @IBAction func addTapped(_ sender: Any) {
        
        presentAlertController()
        
    }
    
    @IBAction func shuffleTapped(_ sender: Any) {
        sections = []
        let names = NameController.shared.name
        NameController.shared.name = []
        shuffleSections(allNames: names)
        tableView.reloadData()
        NameController.shared.saveToPersistentStorage()
        
    }
    
    
    func presentAlertController(){
        let alertController = UIAlertController(title: "Add a name", message: "Make it a good one", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter the name here"
        }
        let save = UIAlertAction(title: "Save", style: .default) { (_) in
            guard let name = alertController.textFields?.first?.text else {return}
            NameController.shared.name.append(name)
            NameController.shared.saveToPersistentStorage()

            if self.sections.last?.count == 1 {
                self.sections[self.sections.count-1].append(name)
            } else {
                self.sections.append([name])
            }
            alertController.dismiss(animated: true, completion: nil)
            self.tableView.reloadData()
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancel)
        alertController.addAction(save)
        self.present(alertController, animated: true)
    }
    
}
