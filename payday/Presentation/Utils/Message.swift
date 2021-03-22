//
//  Message.swift
//  payday
//
//  Created by Ali Almasli on 22.03.21.
//

import UIKit

final class Message {
    static func error(title: String = "Error", message: String) {
        DispatchQueue.main.async {
            if let window = UIApplication.shared.windows.first?.rootViewController {
                let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                let action = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(action)
                window.present(alert, animated: true, completion: nil)
            }
        }
    }
}
