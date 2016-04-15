//: Playground - noun: a place where people can play

import UIKit

class MyTableViewDelegate: NSObject, TSTableViewDelegate {
    
    func numberOfColumnsInTableView(tableView: TSTableView) -> Int {
        return 3
    }
    
    func numberOfRowsInTableView(tableView: TSTableView) -> Int {
        return 3
    }
    
    func tableView(tableView: TSTableView, titleForColumnHeaderAtIndex index: TSTableViewColumnIndex) -> String {
        return "Header \(index)"
    }
    
    func tableView(tableView: TSTableView, titleForCellWithCoordinates cellCoordinates: TSTableViewCellCoordinate) -> String {
        return "Reihe \(cellCoordinates.rowIndex) | Spalte \(cellCoordinates.columnIndex)"
    }
    
    func tableView(tableView: TSTableView, widthForColumnAtIndex index: TSTableViewColumnIndex) -> CGFloat {
        if index == 0 {
            return 200
        }
        return 300
    }
    
    func tableView(tableView: TSTableView, heightForRowAtIndex index: TSTableViewRowIndex) -> CGFloat {
        if index == 1 {
            return 88
        }
        return 44
    }
    
    func tableView(tableView: TSTableView, viewForCellWithCoordinates cellCoordinates: TSTableViewCellCoordinate) -> UIView? {
        if cellCoordinates.columnIndex == 1 && cellCoordinates.rowIndex == 1 {
            let myViewFrame = CGRectMake(tableView.xValueForColumnAtIndex(cellCoordinates.columnIndex), tableView.yValueForRowAtIndex(cellCoordinates.rowIndex), tableView.widthForColumnAtIndex(cellCoordinates.columnIndex), tableView.heightForRowAtIndex(cellCoordinates.rowIndex))
            let myView = UIView(frame: myViewFrame)
            myView.backgroundColor = UIColor.blueColor()
            return myView
        }
        return nil
    }
    
}

let myTableViewDelegate = MyTableViewDelegate()
let tableView = TSTableView(frame: CGRectMake(0, 0, 800, 220))
tableView.tableViewDelegate = myTableViewDelegate
