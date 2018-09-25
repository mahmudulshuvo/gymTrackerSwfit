//
//  EquipmentMainViewControllerSwift.swift
//  gymTracker
//
//  Created by Shuvo on 9/17/18.
//  Copyright © 2018 Third Bit. All rights reserved.
//

import UIKit

class EquipmentMainViewControllerSwift: UITableViewController {
    
    var utility: UtilitySwift!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        utility = UtilitySwift.sharedInstance
        
        // Uncomment the following line to preserve selection between presentations.
        // self.clearsSelectionOnViewWillAppear = NO;
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        utility.equipmentsList = FMDBDataAccess.getEquipments()
        self.tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return utility.equipmentsList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        
        let CellIdentifier: String = "EquipmentTableCell"
        var cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifier, for: indexPath) as? EquipmentTableCellSwift
        if cell == nil {
            cell = EquipmentTableCellSwift(style: .default, reuseIdentifier: CellIdentifier)
        }
        let equipment: Equipment? = self.utility.equipmentsList.object(at: indexPath.row) as? Equipment
        
        cell?.equipmentNameLabel.text = equipment?.equipmentName
        if(equipment?.imageName == nil || equipment?.imageName == "(null)") {
            cell?.equipmentImageView.image = utility.noImage
        }
        else {
            print(equipment?.imageName ?? "")
            cell?.equipmentImageView.image = UIImage(named: equipment?.imageName ?? "")
        }
        return cell!
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let equipment = utility.equipmentsList[indexPath.row] as? Equipment
            
            if equipment?.imageName != nil {
                var filePath: String? = nil
                if let aName = equipment?.imageName {
                    filePath = "\(utility.documentDir)/\(aName)"
                }
                let fileManager = FileManager.default
                
                if fileManager.fileExists(atPath: filePath ?? "") == true {
                    try? fileManager.removeItem(atPath: filePath ?? "")
                }
            }
            
            FMDBDataAccess.delete(equipment)
            
            utility.equipmentsList.removeObject(at: indexPath.row)
            //utility.equipmentsList.remove(at: indexPath.row)
            
            self.tableView.deleteRows(at: [indexPath], with: .fade)
            self.tableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "EquipmentDetailsNewView") {
            let equipmentDetailsView = segue.destination as? EquipmentDetailsViewControllerSwift
            equipmentDetailsView?.selectedEquipment = nil
            equipmentDetailsView?.title = "New Equipment"
        } else if (segue.identifier == "EquipmentDetailsEditView") {
            let equipmentDetailsView = segue.destination as? EquipmentDetailsViewControllerSwift
            let myIndexPath: IndexPath? = tableView.indexPathForSelectedRow
            let row: Int? = myIndexPath?.row
            equipmentDetailsView?.selectedEquipment = utility.equipmentsList[row ?? 0] as? Equipment
            equipmentDetailsView?.title = "Edit Equipment"
        }
    }
    
    
}
