//
//  CreateGoalViewController.swift
//  Goalpost
//
//  Created by Rayhan on 9/1/17.
//  Copyright © 2017 Rayhan. All rights reserved.
//

import UIKit

class CreateGoalViewController: UIViewController, UITextViewDelegate {

    @IBOutlet weak var goalTextView: UITextView!
    @IBOutlet weak var shortTermButton: UIButton!
    @IBOutlet weak var longTermButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    var goalType: GoalType = .shortTerm
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goalTextView.delegate = self
        
        nextButton.bindToKeyboard()
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
    }
    
    @IBAction func shortButtonPressed(_ sender: Any) {
        goalType = .shortTerm
        shortTermButton.setSelectedColor()
        longTermButton.setDeselectedColor()
    }
    
    @IBAction func longButtonPressed(_ sender: Any) {
        goalType = .longTerm
        shortTermButton.setDeselectedColor()
        longTermButton.setSelectedColor()
    }
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        if goalTextView.text != "" && goalTextView.text != "What is your goal?" {
            guard let finishGoalVC = storyboard?.instantiateViewController(withIdentifier: "finishGoalVC")
                as? FinishGoalViewController else { return }
            finishGoalVC.initData(description: goalTextView.text!, type: goalType)
            
            presentingViewController?.presentSecondaryDetail(finishGoalVC)
        }
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        dismissDetail()
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if goalTextView.text == "" || goalTextView.text == "What is your goal?" {
            goalTextView.text = ""
            goalTextView.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        }
    }
    
}
