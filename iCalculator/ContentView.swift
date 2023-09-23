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
            return Color(UIColor(red: 230/255.0, green: 126/255.0, blue: 34/255.0, alpha: 1))
        case .clear, .negative, .percent:
            return Color(.darkGray)
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
            if button == .decimal {
                
            }
            else if button == .negative {
                
            }
            else if button == .percent {
                self.value = "\((Double(self.value) ?? 0) / 100.0)"
                self.equation.append("%")
            }
        default:
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
