//
//  ViewController.swift
//  simple-calc
//
//  Created by Elizabeth on 10/21/16.
//  Copyright © 2016 Elizabeth. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var equation: UITextView!
    @IBOutlet weak var calculated: UILabel!
    @IBOutlet weak var rpnButton: UIButton!
    var num = ""
    var calculatedNum = 0.0
    var numArray = [Double]()
    var mathOp = ""
    var rpn = false
    var rpnNum = [Double]()
    var current = ""
    var history = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // This function is called before the segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // get a reference to the second view controller
        let historyViewController = segue.destination as! HistoryViewController
        
        // set a variable in the second view controller with the data to pass
        historyViewController.data = history
    }
    
    func displayResult() {
        num = ""
        self.calculated.text = String(calculatedNum)
        
        if calculatedNum.isNaN || calculatedNum.isInfinite {
            mathOp = ""
            current = ""
            numArray.removeAll()
            calculatedNum = 0.0
        }
    }
    
    @IBAction func clearCalc(_ sender: AnyObject) {
        num = ""
        mathOp = ""
        current = ""
        numArray.removeAll()
        calculatedNum = 0.0
        self.calculated.text = "0"
    }
    
    @IBAction func switchRPN(_ sender: AnyObject) {
        rpn = !rpn
        if rpn {
            if calculatedNum != 0.0 {
                numArray.append(calculatedNum)
                current = "\(calculatedNum) "
            }
            
            rpnButton.backgroundColor = UIColor(red: (236/255.0), green: (126/255.0), blue: (189/255.0), alpha: 1.0)
            rpnButton.setTitleColor(UIColor.white, for: .normal)
        } else {
            current = ""
            rpnButton.backgroundColor = UIColor(red: (190/255.0), green: (191/255.0), blue: (193/255.0), alpha: 1.0)
            rpnButton.setTitleColor(self.view.tintColor, for: .normal)
            numArray.removeAll()
        }
    }
    
    
    @IBAction func operation(_ sender: AnyObject) {
        let op = (sender.titleLabel!?.text)!
        
        if rpn {
            mathOp = op
            calculate()
        } else {
            if (num == "") {
                current.append("\(calculatedNum) ")
            }
            
            if (mathOp == "" && num != "") {
                calculatedNum = Double(num)!
                current.append("\(calculatedNum) ")
            }
            
            if (mathOp != "" && num != "") {
                calculate()
            }
            
            mathOp = op
            num = ""
        }
    }
    
    @IBAction func multiOperation(_ sender: AnyObject) {
        let op = (sender.titleLabel!?.text)!
        
        if rpn {
            if op != "fact" {
                mathOp = op
                calculate()
            } else {
                if (num != "") {
                    calculatedNum = Double(num)!
                }
                
                let factNum: Int? = Int(calculatedNum)
                
                if factNum == nil{
                    calculatedNum = Double.nan
                } else if factNum == 0 {
                    calculatedNum = 1
                } else {
                    var result = factNum!
                    var temp = factNum! - 1
                    while temp > 0 {
                        result = result * temp
                        temp = temp - 1
                    }
                    
                    calculatedNum = Double(result)
                    current = ("\(factNum!) \(op) = \(calculatedNum)")
                    history.append(current)
                    current = String(calculatedNum)
                }
                displayResult()
            }
        } else {
            if mathOp == "" || mathOp == op {
                switch op {
                case "count":
                    mathOp = "count"
                    if (num == "") {
                        num = String(calculatedNum)
                    }
                    
                    current.append("\(Double(num)!) \(mathOp) ")
                    
                    numArray.append(Double(num)!)
                    calculatedNum = Double(num)!
                    displayResult()
                case "avg":
                    mathOp = "avg"
                    if (num == "") {
                        num = String(calculatedNum)
                    }
                    
                    current.append("\(Double(num)!) \(mathOp) ")
                    
                    numArray.append(Double(num)!)
                    calculatedNum = Double(num)!
                    displayResult()
                case "fact":
                    if (num != "") {
                        calculatedNum = Double(num)!
                    }
                    
                    let factNum: Int? = Int(calculatedNum)
                    
                    if factNum == nil{
                        calculatedNum = Double.nan
                    } else if factNum == 0 {
                        calculatedNum = 1
                    } else {
                        var result = factNum!
                        var temp = factNum! - 1
                        while temp > 0 {
                            result = result * temp
                            temp = temp - 1
                        }
                        calculatedNum = Double(result)
                        current = ("\(factNum!) \(op) = \(calculatedNum)")
                        history.append(current)
                        current = String(calculatedNum)
                    }
                default:
                    calculatedNum = Double.nan
                    current.append("\(calculatedNum) ")
                    break
                }
            } else {
                calculatedNum = Double.nan
                current.append("\(calculatedNum) ")
            }
            displayResult()
        }
    }
    
    func calculate() {
        if rpn {
            if num != "" {
                numArray.append(Double(num)!)
                current += "\(Double(num)!) "
            }
            
            switch mathOp {
            case "+":
                let count = numArray.count
                if count == 0 {
                    current = "\(calculatedNum) "
                }
                
                if count > 0 && count != 1{
                    calculatedNum = numArray[0]
                }
                
                if count == 1 {
                    calculatedNum = calculatedNum + numArray[0]
                    current = "\(calculatedNum) "
                }
                
                if count > 1 {
                    for i in 1..<count {
                        calculatedNum += numArray[i]
                    }
                }
                
                current += "+ = \(calculatedNum)"
            case "-":
                let count = numArray.count
                if count == 0 {
                    current = "\(calculatedNum) "
                }
            
                if count > 0 && count != 1{
                    calculatedNum = numArray[0]
                }
                
                if count == 1 {
                    calculatedNum = calculatedNum - numArray[0]
                    current = "\(calculatedNum) "
                }
                
                if count > 1 {
                    for i in 1..<count {
                        calculatedNum -= numArray[i]
                    }
                }
                
                current += "- = \(calculatedNum)"
            case "×":
                let count = numArray.count
                if count == 0 {
                    current = "\(calculatedNum) "
                }
                
                if count > 0 {
                    calculatedNum = numArray[0]
                }
                
                if count == 1 {
                    calculatedNum = calculatedNum * numArray[0]
                    current = "\(calculatedNum) "
                }
                
                for i in 1..<count {
                    calculatedNum = calculatedNum * numArray[i]
                }
                
                current += "× = \(calculatedNum)"
            case "÷":
                let count = numArray.count
                if count == 0 {
                    current = "\(calculatedNum) "
                }
                
                if count > 0 {
                    calculatedNum = numArray[0]
                }
                
                if count == 1 {
                    calculatedNum = calculatedNum + numArray[0]
                    current = "\(calculatedNum) "
                }
                
                
                if count > 1 {
                    for i in 1..<count {
                        calculatedNum = calculatedNum / numArray[i]
                    }
                }
                
                current += "÷ = \(calculatedNum)"
            case "%":
                let count = numArray.count
                if count == 0 {
                    current = "\(calculatedNum) "
                }
                
                if count > 0 {
                    calculatedNum = numArray[0]
                }
                
                if count == 1 {
                    calculatedNum = calculatedNum / numArray[0]
                    current = "\(calculatedNum) "
                }
                
                for i in 1..<count {
                    calculatedNum = calculatedNum.truncatingRemainder(dividingBy: numArray[i])
                }
                
                current += "% = \(calculatedNum)"
            case "count":
                calculatedNum = Double(numArray.count)
                current += "count = \(calculatedNum)"
            case "avg":
                if (numArray.count > 0) {
                    calculatedNum = (numArray.reduce(0, +)) / Double(numArray.count)
                }
                current += "avg = \(calculatedNum)"
            default:
                calculatedNum = Double.nan
            }
            
            numArray.removeAll()
            if !calculatedNum.isNaN {
                numArray.append(calculatedNum)
                history.append(current)
                current = "\(calculatedNum) "
            }
        } else {
            switch mathOp {
            case "+":
                current.append("\(mathOp) \(Double(num)!) ")
                calculatedNum += Double(num)!
            case "-":
                current.append("\(mathOp) \(Double(num)!) ")
                calculatedNum -= Double(num)!
            case "×":
                current.append("\(mathOp) \(Double(num)!) ")
                calculatedNum = calculatedNum * Double(num)!
            case "÷":
                current.append("\(mathOp) \(Double(num)!) ")
                calculatedNum = calculatedNum / Double(num)!
            case "%":
                current.append("\(mathOp) \(Double(num)!) ")
                calculatedNum = calculatedNum.truncatingRemainder(dividingBy: Double(num)!)
            case "count":
                current.append("\(Double(num)!) \(mathOp) ")
                numArray.append(Double(num)!)
                calculatedNum = Double(numArray.count)
                numArray.removeAll()
            case "avg":
                current.append("\(Double(num)!) \(mathOp)")
                numArray.append(Double(num)!)
                calculatedNum = (numArray.reduce(0, +)) / Double(numArray.count)
                numArray.removeAll()
            default:
                calculatedNum = Double(num)!
                current = "\(calculatedNum) "
            }
        }
        
        mathOp = ""
        displayResult()
    }
    
    @IBAction func equals(_ sender: AnyObject) {
        if rpn {
            if (num != "") {
                calculatedNum = Double(num)!
                numArray.append(Double(num)!)
                current.append("\(calculatedNum) ")
                displayResult()
            }
        } else {
            if (num != "") {
                calculate()
                if current != "" {
                    history.append("\(current)= \(calculatedNum)")
                }
            } else if (mathOp == "count") {
                calculatedNum = Double(numArray.count)
                history.append("\(current)= \(calculatedNum)")
                mathOp = ""
                numArray.removeAll()
                displayResult()
            } else if (mathOp == "avg") {
                calculatedNum = (numArray.reduce(0, +)) / Double(numArray.count)
                history.append("\(current)= \(calculatedNum)")
                mathOp = ""
                numArray.removeAll()
                displayResult()
            }
            current = ""
        }
    }
    
    @IBAction func decimal(_ sender: AnyObject) {
        if !num.contains(".") {
            num = num + "."
            self.calculated.text = num
        }
    }
    
    @IBAction func number(_ sender: AnyObject) {
        let pressed = (sender.titleLabel!?.text)!
        num = num + pressed
        self.calculated.text = num
    }
    
}

