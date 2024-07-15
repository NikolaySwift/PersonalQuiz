//
//  ResultViewController.swift
//  PersonalQuiz
//
//  Created by NikolayD on 10.07.2024.
//

import UIKit

final class ResultViewController: UIViewController {

    @IBOutlet var youAreLabel: UILabel!
    @IBOutlet var definitionLabel: UILabel!
    
    var answers: [Answer]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.setHidesBackButton(true, animated: false)
        
        if let animal = getFinalResult(from: answers) {
            youAreLabel.text = "Вы - \(animal.rawValue)"
            definitionLabel.text = animal.definition
        }
    }

    @IBAction func doneButtonTapped(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }
    
    private func getFinalResult(from answers: [Answer]) -> Animal? {
        var answersByAnimal: [Animal: Int] = [:]
        
        answers.forEach {
            let answerCount = answersByAnimal[$0.animal, default: 0]
            answersByAnimal[$0.animal] = answerCount + 1
        }
        
        let answer = answersByAnimal.max(by: { $0.value < $1.value })
        
        return answer?.key
    }
}
