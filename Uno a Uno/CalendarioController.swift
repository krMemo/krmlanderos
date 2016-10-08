//
//  CalendarioController.swift
//  Uno a Uno
//
//  Created by Enrique Landeros Reyes on 05/10/16.
//  Copyright © 2016 Enrique Landeros Reyes. All rights reserved.
//

import UIKit

class CalendarioController: UIViewController, CVCalendarViewDelegate, CVCalendarMenuViewDelegate {
    
    @IBOutlet weak var labelMes: UILabel!
    @IBOutlet weak var calendarmenuView: CVCalendarMenuView!
    @IBOutlet weak var calendarView: CVCalendarView!
    
    var animationFinished = true
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        calendarmenuView.commitMenuViewUpdate()
        calendarView.commitCalendarViewUpdate()
    }
    
    func presentationMode() -> CalendarMode {
        return CalendarMode.monthView
    }
    
    func firstWeekday() -> Weekday {
        return Weekday.sunday
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarmenuView.menuViewDelegate = self
        calendarView.calendarDelegate = self
        labelMes.text = CVDate(date: Date()).globalDescription
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    func presentedDateUpdated(_ date: CVDate) {
        if labelMes.text != date.globalDescription && self.animationFinished {
            let updatedMonthLabel = UILabel()
            updatedMonthLabel.textColor = labelMes.textColor
            updatedMonthLabel.font = labelMes.font
            updatedMonthLabel.textAlignment = .center
            updatedMonthLabel.text = date.globalDescription
            updatedMonthLabel.sizeToFit()
            updatedMonthLabel.alpha = 0
            updatedMonthLabel.center = labelMes.center
            
            let offset = CGFloat(48)
            updatedMonthLabel.transform = CGAffineTransform(translationX: 0, y: offset)
            updatedMonthLabel.transform = CGAffineTransform(scaleX: 1, y: 0.1)
            
            UIView.animate(withDuration: 0.35, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.animationFinished = false
                self.labelMes.transform = CGAffineTransform(translationX: 0, y: -offset)
                self.labelMes.transform = CGAffineTransform(scaleX: 1, y: 0.1)
                self.labelMes.alpha = 0
                
                updatedMonthLabel.alpha = 1
                updatedMonthLabel.transform = CGAffineTransform.identity
                
            }) { _ in
                
                self.animationFinished = true
                self.labelMes.frame = updatedMonthLabel.frame
                self.labelMes.text = updatedMonthLabel.text
                self.labelMes.transform = CGAffineTransform.identity
                self.labelMes.alpha = 1
                updatedMonthLabel.removeFromSuperview()
            }
            
            self.view.insertSubview(updatedMonthLabel, aboveSubview: labelMes)
        }
    }
    
}
