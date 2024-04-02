//
//  Color+.swift
//  AdminApp
//
//  Created by 승재 on 4/3/24.
//
import UIKit
 
extension UIColor {
    convenience init(hexCode: String, alpha: CGFloat = 1.0){
        var hexFormatted: String = hexCode.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).uppercased()
        
        if hexFormatted.hasPrefix("#"){
            hexFormatted = String(hexFormatted.dropFirst())
        }
        
        assert(hexFormatted.count == 6, "Invalid hex code used.")
        
        var rgbValue: UInt64 = 0
        Scanner(string: hexFormatted).scanHexInt64(&rgbValue)
        
        self.init(red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                  green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                  blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                  alpha: alpha)
    }
    
    static let Grey50 = UIColor(named: "Grey50")!
    static let Grey100 = UIColor(named: "Grey100")!
    static let Grey200 = UIColor(named: "Grey200")!
    static let Grey300 = UIColor(named: "Grey300")!
    static let Grey400 = UIColor(named: "Grey400")!
    static let Grey500 = UIColor(named: "Grey500")!
    static let Grey600 = UIColor(named: "Grey600")!
    static let Grey700 = UIColor(named: "Grey700")!
    static let Grey800 = UIColor(named: "Grey800")!
    static let Grey900 = UIColor(named: "Grey900")!
    
    static let LightBlue50 = UIColor(named: "LightBlue50")!
    static let LightBlue100 = UIColor(named: "LightBlue100")!
    static let LightBlue200 = UIColor(named: "LightBlue200")!
    static let LightBlue300 = UIColor(named: "LightBlue300")!
    static let LightBlue400 = UIColor(named: "LightBlue400")!
    static let LightBlue500 = UIColor(named: "LightBlue500")!
    static let LightBlue600 = UIColor(named: "LightBlue600")!
    static let LightBlue700 = UIColor(named: "LightBlue700")!
    static let LightBlue800 = UIColor(named: "LightBlue800")!
    static let LightBlue900 = UIColor(named: "LightBlue900")!
    
    static let Yellow50 = UIColor(named: "Yellow50")!
    static let Yellow100 = UIColor(named: "Yellow100")!
    static let Yellow200 = UIColor(named: "Yellow200")!
    static let Yellow300 = UIColor(named: "Yellow300")!
    static let Yellow400 = UIColor(named: "Yellow400")!
    static let Yellow500 = UIColor(named: "Yellow500")!
    static let Yellow600 = UIColor(named: "Yellow600")!
    static let Yellow700 = UIColor(named: "Yellow700")!
    static let Yellow800 = UIColor(named: "Yellow800")!
    static let Yellow900 = UIColor(named: "Yellow900")!
    
    static let LightGreen50 = UIColor(named: "LightGreen50")!
    static let LightGreen100 = UIColor(named: "LightGreen100")!
    static let LightGreen200 = UIColor(named: "LightGreen200")!
    static let LightGreen300 = UIColor(named: "LightGreen300")!
    static let LightGreen400 = UIColor(named: "LightGreen400")!
    static let Main = UIColor(named: "LightGreen500")!
    static let LightGreen500 = UIColor(named: "LightGreen500")!
    static let LightGreen600 = UIColor(named: "LightGreen600")!
    static let LightGreen700 = UIColor(named: "LightGreen700")!
    static let LightGreen800 = UIColor(named: "LightGreen800")!
    static let LightGreen900 = UIColor(named: "LightGreen900")!
}
