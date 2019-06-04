//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {

    // MARK: - Properties
    
   var timer = Timer()
    var seconds = 0
    var questionAnswer = ""
    var lightningMode = true
    
    var gameSound: SystemSoundID = 0
    var gameSound1: SystemSoundID = 1
    
    let trivia: [[String : String]] = [
        ["Question": "Only female koalas can whistle", "Answer": "False"],
        ["Question": "Blue whales are technically whales", "Answer": "True"],
        ["Question": "Camels are cannibalistic", "Answer": "False"],
        ["Question": "All ducks are birds", "Answer": "True"]
    ]

    let quizManager = QuizManager()
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var lightingModeButton: UIButton!
    @IBOutlet weak var normalModeButton: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var choice3Button: UIButton!
    @IBOutlet weak var choice4Button: UIButton!
    @IBOutlet weak var choice1Button: UIButton!
    @IBOutlet weak var choice2Button: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameStartSound()
        loadCorrectAnsweSound()
        playGameStartSound()
        quizManager.createQuiz()
        mainMenu()
       
        
    }
    
    // MARK: - Helpers
    func mainMenu(){
        timerLabel.isHidden = true
        choice1Button.isHidden = true
        choice2Button.isHidden = true
        choice3Button.isHidden = true
        choice4Button.isHidden = true
        playAgainButton.isHidden = true
        questionField.text = "choose what game mode you will like to play"
    }
    
    func runTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer(){
        seconds+=1
        timerLabel.text = String(seconds)
        if seconds == 15 {
            timer.invalidate()
            displayScore()
        }
    }
    
    func loadCorrectAnsweSound(){
        let path = Bundle.main.path(forResource: "correct", ofType: "mp3")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound1)
    }
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    func playCorrectSound() {
        AudioServicesPlaySystemSound(gameSound1)
    }
    
    func displayQuestion() {
         choice1Button.backgroundColor = UIColor.blue
         choice2Button.backgroundColor = UIColor.blue
         choice3Button.backgroundColor = UIColor.blue
         choice4Button.backgroundColor = UIColor.blue
            let randomQuestion = quizManager.quiz.questions[quizManager.quiz.questionIndex]
            questionField.text = randomQuestion.question
            
            var  answers:[String] = []
            answers.append(randomQuestion.wrongAnswers[2])
            answers.append(randomQuestion.wrongAnswers[1])
            answers.append(randomQuestion.wrongAnswers[0])
            answers.append(randomQuestion.answer)
            var last = answers.count - 1
            
            while(last > 0)
            {
                let rand = Int(arc4random_uniform(UInt32(last)))
                
                
                answers.swapAt(last, rand)
                
                last -= 1
            }
            
            choice1Button.setTitle(answers[3], for: [])
            choice2Button.setTitle(answers[1], for: [])
            choice3Button.setTitle(answers[2], for: [])
            choice4Button.setTitle(answers[0], for: [])
            questionAnswer = randomQuestion.answer
        
        playAgainButton.isHidden = true
    }
    
    func displayScore() {
        // Hide the answer uttons
        choice1Button.isHidden = true
        choice2Button.isHidden = true
        choice3Button.isHidden = true
        choice4Button.isHidden = true
        
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go! You got \(quizManager.quiz.score) out of \(quizManager.quiz.questionsPerRound) correct!"
    }
    
    func nextRound() {
        if quizManager.quiz.questionsAsked == quizManager.quiz.questionsPerRound {
            // Game is over
            displayScore()
             quizManager.createQuiz()
          
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
    
    // MARK: - Actions
    
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        
        if (sender === choice1Button && quizManager.checkAnswer(choice1Button.titleLabel!.text!) ||
            sender === choice2Button &&  quizManager.checkAnswer(choice2Button.titleLabel!.text!) ||
            sender === choice3Button &&  quizManager.checkAnswer(choice3Button.titleLabel!.text!) ||
            sender === choice4Button &&  quizManager.checkAnswer(choice4Button.titleLabel!.text!))  {
   
            playCorrectSound()
            questionField.text = "Correct!"
            
            quizManager.quiz.correctAnswer()
        } else {
            if quizManager.checkAnswer(choice1Button.titleLabel!.text!) {
               
                choice1Button.backgroundColor = UIColor.green
            } else if quizManager.checkAnswer(choice2Button.titleLabel!.text!) {
               
                choice2Button.backgroundColor = UIColor.green
            }else if quizManager.checkAnswer(choice3Button.titleLabel!.text!) {
                
                choice3Button.backgroundColor = UIColor.green
            } else if quizManager.checkAnswer(choice4Button.titleLabel!.text!) {
               
                choice4Button.backgroundColor = UIColor.green
            }
            quizManager.quiz.wrongAnswer()
            questionField.text = "Sorry, wrong answer!"
        }
        
       
        loadNextRound(delay: 2)
    }
    
    
    @IBAction func playAgain(_ sender: UIButton) {
        // Show the answer buttons
        choice1Button.isHidden = false
        choice2Button.isHidden = false
        choice3Button.isHidden = false
        choice4Button.isHidden = false
        
     
        nextRound()
        if lightningMode == true {
            seconds = 0
            runTimer()
        }
        
    }
    @IBAction func startLightningMode(_ sender: UIButton) {
        // Show the answer buttons
        choice1Button.isHidden = false
        choice2Button.isHidden = false
        choice3Button.isHidden = false
        choice4Button.isHidden = false
        timerLabel.isHidden = false
        lightingModeButton.isHidden = true
        normalModeButton.isHidden = true 
        lightningMode = true
        displayQuestion()
        runTimer()
        
    }
    @IBAction func startNormalMode(_ sender: UIButton) {
        
        choice1Button.isHidden = false
        choice2Button.isHidden = false
        choice3Button.isHidden = false
        choice4Button.isHidden = false
        lightingModeButton.isHidden = true
        normalModeButton.isHidden = true
        lightningMode = false
        displayQuestion()
        
        
    }
    

}

