//
//  ContentView.swift
//  iCalculator
//
//  Created by Asror Abdurakhmanov on 23/09/23.
//

import SwiftUI

enum CalcButton: String {
    case one = "1"
    case two = "2"
    case three = "3"
    case four = "4"
    case five = "5"
    case six = "6"
    case seven = "7"
    case eight = "8"
    case nine = "9"
    case zero = "0"
    case add = "+"
    case subtract = "-"
    case divide = "÷"
    case multiply = "×"
    case equal = "="
    case clear = "AC"
    case decimal = "."
    case percent = "%"
    case negative = "-/+"
    
    var buttonColor: Color {
        switch self {
        case .add, .subtract, .multiply, .divide, .equal:
            return Color(UIColor(red: 255/255.0, green: 121/255.0, blue: 63/255.0, alpha: 1))
        case .clear, .negative, .percent:
            return Color(UIColor(red: 64/255.0, green: 115/255.0, blue: 158/255.0, alpha: 1))
        default:
            return Color(UIColor(red: 44/255.0, green: 62/255.0, blue: 80/255.0, alpha: 1))
        }
    }
}

enum Operation {
    case add, subtract, multiply, divide, none
}

struct ContentView: View {
    
    @State var value = "0"
    @State var equation = ""
    @State var runningNumber: Double = 0.0
    @State var currentOperation: Operation = .none
    
    @State var equalPressed = false
    @State var decimalPressed = false
    
    let buttons: [[CalcButton]] = [
        [.clear, .negative, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .subtract],
        [.one, .two, .three, .add],
        [.zero, .decimal, .equal],
    ]
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Spacer()
                
                // Text display
                VStack {
                    HStack {
                        Spacer()
                        Text(equation)
                            .font(.system(size: 32))
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Spacer()
                        Text(value)
                            .font(.system(size: 100))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                .padding()
                
                // The buttons
                ForEach(buttons, id: \.self) { row in
                    HStack(spacing: 12) {
                        ForEach(row, id: \.self) { item in
                            Button(action: {
                                self.didTap(button: item)
                            }, label: {
                                Text(item.rawValue)
                                    .bold()
                                    .font(.system(size: 32))
                                    .frame(width: self.buttonWidth(item: item), height: self.buttonHeight())
                                    .background(item.buttonColor)
                                    .foregroundColor(.white)
                                    .cornerRadius(self.buttonWidth(item: item)/2)
                            })
                        }
                    }
                }
                .padding(.bottom, 3)
            }
        }
    }
    
    func didTap(button: CalcButton) {
        switch button {
        case .add, .subtract, .multiply, .divide, .equal:
            if decimalPressed == true {
                break
            }
            if button == .add {
                self.currentOperation = .add
                self.runningNumber = Double(self.value) ?? 0.0
                self.equation.append(" + ")
            }
            else if button == .subtract {
                self.currentOperation = .subtract
                self.runningNumber = Double(self.value) ?? 0.0
                self.equation.append(" - ")
            }
            else if button == .multiply {
                self.currentOperation = .multiply
                self.runningNumber = Double(self.value) ?? 0.0
                self.equation.append(" × ")
            }
            else if button == .divide {
                self.currentOperation = .divide
                self.runningNumber = Double(self.value) ?? 0.0
                self.equation.append(" ÷ ")
            }
            else if button == .equal {
                equalPressed = true
                let runningValue = self.runningNumber
                let currentValue = Double(self.value) ?? 0.0
                switch self.currentOperation {
                case .add:
                    let answer: Double = runningValue + currentValue
                    self.value = self.removeDecimal(number: answer)
                case .subtract:
                    let answer: Double = runningValue - currentValue
                    self.value = self.removeDecimal(number: answer)
                case .multiply:
                    let answer: Double = runningValue * currentValue
                    self.value = self.removeDecimal(number: answer)
                case .divide:
                    let answer: Double = runningValue / currentValue
                    self.value = self.removeDecimal(number: answer)
                case .none:
                    break
                }
                self.equation.append(" = ")
            }
            
            if button != .equal {
                self.value = "0"
            }
        case .clear:
            self.value = "0"
            self.currentOperation = .none
            self.equation = ""
        case .decimal, .negative, .percent:
            let number = Double(self.value) ?? 0.0
            if button == .decimal {
                if !self.value.contains(".") {
                    self.value.append(".")
                    self.equation.append(".")
                    self.decimalPressed = true
                }
            }
            else if button == .negative && decimalPressed != true {
                if number > 0.0 {
                    self.value = "-\(self.removeDecimal(number: number))"
                    self.equation.insert("-", at: self.equation.index(self.value.startIndex, offsetBy: self.equation.count - self.value.count + 1))
                }
                else if number < 0.0 {
                    self.value = "\(self.removeDecimal(number: fabs(number)))"
                    self.equation.remove(at: self.equation.index(self.value.startIndex, offsetBy: self.equation.count - self.value.count - 1))
                }
            }
            else if button == .percent && decimalPressed != true {
                self.value = "\((number) / 100.0)"
                self.equation.append("%")
            }
        default:
            if self.value.count > 10 {
                break
            }
            if equalPressed == true {
                self.value = "0"
                self.equation = ""
                equalPressed = false
            }
            let number = button.rawValue
            if self.value == "0" {
                self.value = number
            }
            else {
                self.value = "\(self.value)\(number)"
                self.decimalPressed = false
            }
            self.equation.append("\(number)")
        }
    }
    
    func buttonWidth(item: CalcButton) -> CGFloat {
        if item == .zero {
            return ((UIScreen.main.bounds.width - (4 * 12)) / 4) * 2
        }
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func buttonHeight() -> CGFloat {
        return (UIScreen.main.bounds.width - (5 * 12)) / 4
    }
    
    func removeDecimal(number: Double) -> String {
        if number.truncatingRemainder(dividingBy: 1.0) == 0.0 {
            return "\(Int(number))"
        }
        return "\(number)"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
