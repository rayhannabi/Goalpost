//
//  GoalsViewController.swift
//  Goalpost
//
//  Created by Rayhan on 8/31/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import UIKit
import CoreData

let appDelegate = UIApplication.shared.delegate as? AppDelegate

class GoalsViewController: UIViewController {

    @IBOutlet weak var goalTableView: UITableView!
    @IBOutlet weak var undoView: UIView!
    
    var goals: [Goal] = []
    var goalDeleted: Goal!
    var indexDeleted: IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        goalTableView.dataSource = self
        goalTableView.delegate = self
        goalTableView.isHidden = true
        undoView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetch()
        goalTableView.reloadData() 
    }
    
    @IBAction func addGoalPressed(_ sender: Any) {
        guard let createGoalVC = storyboard?.instantiateViewController(withIdentifier: "CreateGoalVC")
            else {
                return
        }
        
        presentDetail(createGoalVC)
    }
    
    @IBAction func undoPressed(_ sender: Any) {
        print(goalDeleted.goalDescription!)
        self.undoDelete(goal: goalDeleted) { (complete) in
            if complete {
                undoView.isHidden = true
                fetch()
            }
        }
    }
    
    func fetch() {
        self.fetchFromCoreData { (complete) in
            if complete {
                if goals.count >= 1 {
                    goalTableView.isHidden = false
                } else {
                    goalTableView.isHidden = true
                }
            }
        }
        
        undoView.isHidden = true
    }
}

extension GoalsViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return goals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "goalCell")
            as? GoalCell else {
            return UITableViewCell()
        }
        
        let oneGoal = goals[indexPath.row]
        cell.configureCell(goal: oneGoal)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /*
     func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) ->
        UITableViewCellEditingStyle {
        return .none
    }
    */
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (rowAction, indexPath) in
            self.removeFromCoreData(atIndexPath: indexPath)
            self.fetch()
            self.goalTableView.deleteRows(at: [indexPath], with: .automatic)
            self.undoView.isHidden = false
        }
        
        let addAction = UITableViewRowAction(style: .normal, title: "Add 1") { (rowAction, indexPath) in
            self.setProgress(atIndexPath: indexPath)
            self.goalTableView.reloadRows(at: [indexPath], with: .automatic)
        }
        
        deleteAction.backgroundColor = #colorLiteral(red: 1, green: 0.1491314173, blue: 0, alpha: 1)
        addAction.backgroundColor = #colorLiteral(red: 0.2996588051, green: 0.7706694007, blue: 0.4634178281, alpha: 1)
        
        let goal = goals[indexPath.row]
        
        if goal.goalProgress == goal.goalValue {
            return [deleteAction]
        }
        return [deleteAction, addAction]
    }
}

extension GoalsViewController {
    
    func fetchFromCoreData(completion: (_ complete: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let fetchRequest = NSFetchRequest<Goal>(entityName: "Goal")
        
        do {
            goals = try managedContext.fetch(fetchRequest)
            completion(true)
        } catch {
            debugPrint("Could not fetch - \(error.localizedDescription)")
            completion(false)
        }
    }
    
    func removeFromCoreData(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let goalToDelete = goals[indexPath.row]
        // goalDeleted = Goal(context: managedContext)
        goalDeleted = goalToDelete
        indexDeleted = indexPath
                
        managedContext.delete(goalToDelete)
        
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not save - \(error.localizedDescription)")
        }
    }
    
    func setProgress(atIndexPath indexPath: IndexPath) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        
        let chosenGoal = goals[indexPath.row]
        
        if chosenGoal.goalProgress < chosenGoal.goalValue {
            chosenGoal.goalProgress += 1
        } else {
            return
        }
        
        do {
            try managedContext.save()
        } catch {
            debugPrint("Could not set: \(error.localizedDescription)")
        }
    }
    
    func undoDelete(goal: Goal, completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext else { return }
        let goalToUndo = Goal(context: managedContext)
        
        goalToUndo.goalDescription = goal.goalDescription
        goalToUndo.goalType = goal.goalType
        goalToUndo.goalProgress = goal.goalProgress
        goalToUndo.goalValue = goal.goalValue
        
        do {
            try managedContext.save()
            
            completion(true)
        } catch {
            debugPrint("Could not save - \(error.localizedDescription)")
            completion(false)
        }
        
    }
    
}











