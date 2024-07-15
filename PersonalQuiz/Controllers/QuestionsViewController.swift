//
//  ViewController.swift
//  PersonalQuiz
//
//  Created by NikolayD on 10.07.2024.
//

import UIKit

final class QuestionsViewController: UIViewController {
    // MARK: - IBOutlet properties
    @IBOutlet var questionsProgressView: UIProgressView!
    
    @IBOutlet var questionLabel: UILabel!
    
    @IBOutlet var singleStackView: UIStackView!
    @IBOutlet var singleAnswerButtons: [UIButton]!
    
    @IBOutlet var multipleStackView: UIStackView!
    @IBOutlet var multipleAnswerLabels: [UILabel]!
    @IBOutlet var multipleAnswerSwitches: [UISwitch]!
    
    @IBOutlet var rangedStackView: UIStackView!
    @IBOutlet var rangedAnswerSlider: UISlider!
    @IBOutlet var rangedAnswerLabels: [UILabel]!
    
    // MARK: - private properties
    private let questions = Question.getQuestions()
    
    private var questionIndex = 0
    private var currentQuestion: Question {
        questions[questionIndex]
    }
    
    private var answers: [Answer] = []

    // MARK: - view life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideAllStackViews()
        
        showProgress()
        showCurrentQuestion()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let ResultVC = segue.destination as? ResultViewController else {
            return
        }
        ResultVC.answers = answers
    }

    // MARK: - IBAction methods
    @IBAction func rangedAnswerButtonTapped() {
        let answerIndex = lrintf(rangedAnswerSlider.value)
        answers.append(currentQuestion.answers[answerIndex])
        goNextQuestion()
    }
    
    @IBAction func multipleAnswerButtonTapped() {
        for (multipleSwitch, answer) in zip(
            multipleAnswerSwitches,
            currentQuestion.answers
        ) {
            if multipleSwitch.isOn {
                answers.append(answer)
            }
        }
        goNextQuestion()
    }
    
    @IBAction func singleAnswerButtonTapped(_ sender: UIButton) {
        guard let buttonIndex = singleAnswerButtons.firstIndex(of: sender) else {
            return
        }
        answers.append(currentQuestion.answers[buttonIndex])
        goNextQuestion()
    }
    
}

// MARK: - private methods
private extension QuestionsViewController {
    func hideAllStackViews() {
        for stackView in [singleStackView, multipleStackView, rangedStackView] {
            if let stackView = stackView {
                stackView.isHidden = true
            }
        }
    }
    
    func hideCurrentQuestionStackView () {
        switch currentQuestion.type {
        case .single:
            singleStackView.isHidden.toggle()
        case .multiple:
            multipleStackView.isHidden.toggle()
        case .ranged:
            rangedStackView.isHidden.toggle()
        }
    }
    
    func showCurrentQuestion() {
        questionLabel.text = currentQuestion.title
        
        switch currentQuestion.type {
        case .single:
            showSingleAnswerStackView()
        case .multiple:
            showMultipleAnswerStackView()
        case .ranged:
            showRangedAnswerStackView()
        }
    }
    
    func goNextQuestion() {
        hideCurrentQuestionStackView()
        questionIndex += 1
        
        if questionIndex < questions.count {
            showProgress()
            showCurrentQuestion()
        } else {
            performSegue(withIdentifier: "showResult", sender: nil)
        }
    }
    
    func showSingleAnswerStackView() {
        singleStackView.isHidden.toggle()
        
        for (button, answer) in zip(singleAnswerButtons, currentQuestion.answers) {
            button.setTitle(answer.title, for: .normal)
        }
    }
    
    func showMultipleAnswerStackView() {
        multipleStackView.isHidden.toggle()
        
        for (label, answer) in zip(multipleAnswerLabels, currentQuestion.answers) {
            label.text = answer.title
        }
    }
    
    func showRangedAnswerStackView() {
        rangedStackView.isHidden.toggle()
        
        let maximumValue = Float(currentQuestion.answers.count - 1)
        rangedAnswerSlider.maximumValue = maximumValue
        rangedAnswerSlider.setValue(maximumValue / 2, animated: true)
        
        rangedAnswerLabels.first?.text = currentQuestion.answers.first?.title
        rangedAnswerLabels.last?.text = currentQuestion.answers.last?.title
    }
    
    func showProgress() {
        navigationItem.title = "Вопрос № \(questionIndex + 1)"
        
        let progress = Float(questionIndex) / Float(questions.count)
        questionsProgressView.setProgress(progress, animated: true)
    }
}
