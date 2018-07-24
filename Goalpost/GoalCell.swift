//
//  GoalCell.swift
//  Goalpost
//
//  Created by Rayhan on 8/31/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import UIKit

class GoalCell: UITableViewCell {
    
    @IBOutlet weak var goalDescriptionLbl: UILabel!
    @IBOutlet weak var goalTypeLbl: UILabel!
    @IBOutlet weak var goalProgressLbl: UILabel!
    @IBOutlet weak var goalCompleteView: UIView!
    
    func configureCell(goal: Goal) {
        goalDescriptionLbl.text = goal.goalDescription
        goalTypeLbl.text = goal.goalType
        goalProgressLbl.text = String(describing: goal.goalProgress)
        
        if goal.goalProgress == goal.goalValue {
            goalCompleteView.isHidden = false
        } else {
            goalCompleteView.isHidden = true
        }
    }
    
}
