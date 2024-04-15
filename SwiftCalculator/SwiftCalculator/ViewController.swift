import UIKit

enum CalculationError: Error {
    case dividedByZero
}

enum Operation: String{
    case add = "+"
    case substract = "-"
    case multiply = "x"
    case divide = "/"
    
    func calculate (_ number1: Double, _ number2: Double) throws -> Double {
        switch self{
        case .add:
            return number1 + number2
        case .substract:
            return number1 - number2
        case .multiply:
            return number1 * number2
        case .divide:
            if number2 == 0{
                throw CalculationError.dividedByZero
            }
            return number1 / number2
        }
    }
}

enum CalculationHistoryItem {
    case number (Double)
    case operation (Operation)
}

class ViewController: UIViewController {
    
    @IBAction func buttonPassed(_ sender: UIButton) {
        guard let buttonText = sender.currentTitle else {return
        }
        if buttonText == "," && label.text?.contains(",") == true {
            return
        }
        if label.text == "0"{
            label.text = buttonText
        } else {
            label.text?.append(buttonText)
        }
    }
    
    @IBAction func operationButtonPassed(_ sender: UIButton) {
        guard
            let buttonText = sender.currentTitle,
            let buttonOperation = Operation(rawValue: buttonText)
        else {return}
        
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculationHistory.append(.number(labelNumber))
        calculationHistory.append(.operation(buttonOperation))
        
        resetLabelText()
    }
    
    @IBAction func clearButtonPassed(_ sender: UIButton) {
        calculationHistory.removeAll()
        
        resetLabelText()
    }
    
    
    @IBAction func calculateButtonPassed(_ sender: UIButton) {
        guard
            let labelText = label.text,
            let labelNumber = numberFormatter.number(from: labelText)?.doubleValue
        else {return}
        
        calculationHistory.append(.number(labelNumber))
        do {
            let result = try calculate()
            label.text = numberFormatter.string(from: NSNumber(value: result))
        } catch{
            label.text = "Ошибка"
        }
        calculationHistory.removeAll()
    }
    
    var calculationHistory: [CalculationHistoryItem] = []
    
    @IBOutlet weak var label: UILabel!
    
    lazy var numberFormatter: NumberFormatter = {
       let numberFormatter = NumberFormatter()
        
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.locale = Locale(identifier: "ru_RU")
        numberFormatter.numberStyle = .decimal
        return numberFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetLabelText()
    }
    
    func calculate () throws -> Double {
        guard case .number(let firstNumber) = calculationHistory[0] else { return 0 }
        
        var currentResult = firstNumber
        for i in stride(from: 1, to: calculationHistory.count - 1, by: 2){
            guard
                case .operation (let operation) = calculationHistory[i],
                case .number (let number) = calculationHistory[i + 1]
            else {break}
            
            currentResult = try operation.calculate(currentResult, number)
        }
        return currentResult
    }
    
    func resetLabelText () {
        label.text = "0"
    }

}

