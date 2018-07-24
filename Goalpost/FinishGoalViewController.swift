//
//  FinishGoalViewController.swift
//  Goalpost
//
//  Created by Rayhan on 9/1/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import UIKit
import CoreData

class FinishGoalViewController: UIViewController {

    @IBOutlet weak var createGoalBtn: UIButton!
    @IBOutlet weak var pointsField: UITextField!
    
    private var goalDescription: String!
    private var goalType: GoalType!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createGoalBtn.bindToKeyboard()
    }

    @IBAction func createGoalPressed(_ sender: Any) {
        if pointsField.text != "" {
            saveToCoreData(completion: { (saved) in
                if saved {
                    dismiss(animated: true, completion: nil)
                }
            })
        }
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }
    
    func initData(description: String, type: GoalType) {
        goalDescription = description
        goalType = type
    }
    
    func saveToCoreData(completion: (_ finished: Bool) -> ()) {
        guard let managedContext = appDelegate?.persistentContainer.viewContext
            else { return }
        let goal = Goal(context: managedContext)
        
        goal.goalDescription = goalDescription
        goal.goalType = goalType.rawValue
        goal.goalValue = Int32(pointsField.text!)!
        goal.goalProgress = Int32(0)
        
        do {
            try managedContext.save()
            completion(true)
        } catch {
            debugPrint("Could not save - \(error.localizedDescription)")
            completion(false)
        }
    }
}








