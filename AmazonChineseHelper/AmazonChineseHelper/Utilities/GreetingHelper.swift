import Foundation

enum GreetingHelper {
    static func currentGreeting() -> String {
        let hour = Calendar.current.component(.hour, from: Date())
        switch hour {
        case 5..<12:  return "早上好"
        case 12..<14: return "中午好"
        case 14..<18: return "下午好"
        default:      return "晚上好"
        }
    }
}
