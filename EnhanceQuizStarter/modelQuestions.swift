//
//  modelQuestions.swift
//  EnhanceQuizStarter
//
//  Created by curtis scott on 29/05/2019.
//  Copyright © 2019 Treehouse. All rights reserved.
//

import Foundation


//questions
let q1 = Question(question: "This was the only US President to serve more than two consecutive terms. ",answer: "Franklin D. Roosevelt",wrongAnswers: ["George Washington","Woodrow Wilson","Andrew Jackson"])
let q2 = Question(question: "Which of the following countries has the most residents?",answer: "Nigeria",wrongAnswers: ["Russia","Iran","Vietnam "])
let q3 = Question(question: "In what year was the United Nations founded?",answer: "1945",wrongAnswers: ["1918"," 1919","1954"])
let q4 = Question(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive? ",answer: "New York City",wrongAnswers: ["Paris" ,   "Washington D.C.","Boston"])
let q5 = Question(question: "Which nation produces the most oil?",answer: "Canada",wrongAnswers: ["Iran","Iraq", "Brazil"])
let q6 = Question(question: "Which country has most recently won consecutive World Cups in Soccer? ",answer: "Brazil",wrongAnswers: ["Argetina" ,   "Spain", "Italy"])
let q7 = Question(question: "Which of the following rivers is longest?",answer: "Mississippi",wrongAnswers: ["Congo" ,  " Mekong" ,"Yangtze"])
let q8 = Question(question: "Which city is the oldest?",answer: "Mexico City",wrongAnswers: ["Cape Town","San Juan"   , "Sydney"])
let q9 = Question(question: "Which country was the first to allow women to vote in national elections? ",answer: "Poland",wrongAnswers: ["United States", "Sweden",    "Senegal"])
let q10 = Question(question: "Which of these countries won the most medals in the 2012 Summer Games? ",answer: "Great Britian",wrongAnswers: ["France", "Germany", "Japan"])





//model classes

class Quiz {
    var score = 0
    let questionsPerRound = 4
    var questionsAsked = 0
    var questionIndex = 0
    var questions:[Question]
    
    //increase score and chance question index
    func correctAnswer(){
        score += 1
        questionsAsked += 1
        questionIndex += 1
    }
    
    func wrongAnswer(){
        questionsAsked += 1
        questionIndex += 1
    }
    
    init(_ questions :[Question]) {
        self.questions = questions
    }
}

class QuizManager {
    var questions:[Question] = [q1,q2,q3,q4,q5,q6,q7,q8,q9]
    var quiz:Quiz
    
    func checkAnswer(_ answer:String)-> Bool {
        for question in quiz.questions{
            if answer == question.answer{
                return true
            }
        }
        return false
    }
    
    //shuffles the qeustions for the quiz
    func shuffleQuestions() {
        var last = questions.count - 1
        
        while(last > 0)
        {
            let rand = Int(arc4random_uniform(UInt32(last)))
            
            
            questions.swapAt(last, rand)
            
            last -= 1
        }
    }
    
    //creates a new quiz(set of 4 questions)
    func createQuiz() {
      shuffleQuestions()
        
        let newQuiz = Quiz([questions[0],questions[1],questions[2],questions[3]])
        
        self.quiz = newQuiz
    }
    
    init() {
        self.quiz = Quiz([questions[0],questions[1],questions[2],questions[3]])
    }
}




struct Question{
    let question: String
    let answer: String
    let wrongAnswers: [String]
    
    //reutrns an dictionary of the question and all the possible anwers in an array
    func produceQuestion()-> [String:[String]]{
        var fullReturnQuestion: [String:[String]] = [:]
        var allAnswers: [String] = []
        allAnswers.append(answer)
        for answer in wrongAnswers {
            allAnswers.append(answer)
        }
        fullReturnQuestion[question] = allAnswers
        
        return fullReturnQuestion
    }
    
}
