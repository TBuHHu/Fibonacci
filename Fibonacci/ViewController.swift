//
//  ViewController.swift
//  Fibonacci
//
//  Created by Александр Исмаилов on 11/08/2019.
//  Copyright © 2019 Александр Исмаилов. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var stepField: UITextField!
    @IBOutlet weak var resultField: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var reverseResult: UISwitch!
    
    let defaultMessageInfoLabel = "About Program:"
    let defaultMessageResultField = "🔲 The Fibonacci Sequence is the series of numbers: 0, 1, 1, 2, 3, 5, 8, 13, 21,34...\n\n🔲 The next number is found by adding up the two numbers before it:\n▫️ The 2 is found by adding the two numbers before it (1+1)\n▫️ The 3 is found by adding the two numbers before it (1+2)\n▫️ And the 5 is (2+3)\n▫️ and so on!\n\n🔲 For calculating enter a step and tap on squares."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Чтобы клава двигала textField
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        resultField.setContentOffset(.zero, animated: false) //Чтобы при открытии приложения UITextView отображал текст сверху, а не снизу
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if ((notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue) != nil {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 290
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    //Когда касаешься экрана вне textField - скрывает клаву
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        stepField.resignFirstResponder()
        getResult((Any).self) //+ запуск функции
    }
    
//    //Выполняет код по нажатии кнопки return на клаве
//    func textFieldShouldReturn(_ stepField: UITextField) -> Bool {
//        getResult((Any).self)
//        return true
//    }
    
    //Пошла движуха
    func getResult(_ sender: Any) {
        stepField.resignFirstResponder()
        
        //Всплывающее уведомление
        func showAlert(_ title: String, _ message: String) {
            infoLabel.text = defaultMessageInfoLabel
            resultField.text = defaultMessageResultField
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "I understand.", style: .default)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
            resultField.scrollRangeToVisible(NSRange(location:0, length:0))
        }
        
        //Сама логика приложения
        var counter = Int(stepField.text!)
        var resultNumbers: [Int] = [1, 1]
        
        if !stepField.hasText {
            showAlert("Really? ;)", "I can't multiply on nothing!")
        }
        else if counter! <= 2 {
            showAlert("I'm sorry but...", "Minimum possible step is 3.")
        }
        else if counter! >= 93 {
            showAlert("Holy sh*t!", "Maximum possible step is 92.")
        } else {
            for _ in 3...counter! {
            let newLastValue = resultNumbers[resultNumbers.endIndex - 1] + resultNumbers[resultNumbers.endIndex - 2]
                resultNumbers.append(newLastValue)
            }
            
            if reverseResult.isOn {
                resultNumbers = resultNumbers.reversed()
            }
            
            let resultNumbersString = resultNumbers.map { String($0) }
            var resultAsString = ""
            var resultCounter = 0
            
            for nextValue in resultNumbersString {
                resultCounter += 1
                resultAsString += ("Step \(resultCounter) - \(nextValue);\n")
            }
            
            func forInfoLabel(counterString: String) {
                infoLabel.text = "Result for step \(counterString):"
            }
            
            forInfoLabel(counterString: counter.map { String($0) }!)
            resultAsString.removeLast(2)
            resultAsString += "."
            print(resultAsString)
            resultField.text = resultAsString
        }
        
        stepField.text = nil
    
    }
}

