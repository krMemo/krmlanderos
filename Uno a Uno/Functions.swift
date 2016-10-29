//
//  Functions.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 02/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

extension String {
    var lang: String {
        return NSLocalizedString(self, comment: "")
    }
}

func mostrarAviso(titulo: String, mensaje: String, viewController: UIViewController) {
    let alertController = UIAlertController(title: titulo, message: mensaje, preferredStyle: UIAlertControllerStyle.alert)
    let action = UIAlertAction(title: "OK", style: UIAlertActionStyle.default)
    alertController.addAction(action)
    viewController.present(alertController, animated: true, completion: nil)
}
