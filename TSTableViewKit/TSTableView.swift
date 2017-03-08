//
//  TSTableView.swift
//  TSTableView
//
//  Created by Thomas Sillmann on 15.04.16.
//  Copyright © 2016 Thomas Sillmann. All rights reserved.
//

public typealias TSTableViewColumnIndex = Int

public typealias TSTableViewRowIndex = Int

import UIKit

open class TSTableView: UIScrollView {
    
    var tableViewDelegate: TSTableViewDelegate? {
        didSet {
            updateTableView()
        }
    }
    
    fileprivate let defaultTableViewColumnWidth: CGFloat = 200
    
    fileprivate let defaultTableViewCellIndention: CGFloat = 8
    
    fileprivate let defaultTableViewHeaderHeight: CGFloat = 44
    
    fileprivate var tableViewHeaderLabels = [UILabel]()
    
    fileprivate let defaultTableViewRowHeight: CGFloat = 44
    
    fileprivate lazy var rowWidth: CGFloat = {
        return self.calculatedRowWidth()
    }()
    
    fileprivate let defaultTableViewBackgroundColorForEvenRow = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    fileprivate let defaultTableViewBackgroundColorForUnevenRow = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    fileprivate var tableViewRowViews = [UIView]()
    
    fileprivate var tableViewCellViews = [UIView]()
    
    open func widthForColumnAtIndex(_ index: TSTableViewColumnIndex) -> CGFloat {
        if let columnWidth = tableViewDelegate!.tableView?(self, widthForColumnAtIndex: index) {
            return columnWidth
        }
        return defaultTableViewColumnWidth
    }
    
    open func xValueForColumnAtIndex(_ index: TSTableViewColumnIndex) -> CGFloat {
        var columnXValue: CGFloat = 0
        for previousIndex in 0 ..< index {
            let previousColumnWidth = widthForColumnAtIndex(previousIndex)
            columnXValue += previousColumnWidth
        }
        return columnXValue
    }
    
    fileprivate func createHeaderViews() {
        for index in 0 ..< tableViewDelegate!.numberOfColumnsInTableView(self) {
            createHeaderLabelForColumnAtIndex(index)
        }
    }
    
    fileprivate func createHeaderLabelForColumnAtIndex(_ index: TSTableViewColumnIndex) {
        let headerLabel = UILabel(frame: CGRect(x: xValueForColumnAtIndex(index) + defaultTableViewCellIndention, y: 0, width: widthForColumnAtIndex(index) - defaultTableViewCellIndention * 2, height: defaultTableViewHeaderHeight))
        headerLabel.font = UIFont.boldSystemFont(ofSize: 17)
        headerLabel.text = tableViewDelegate!.tableView(self, titleForColumnHeaderAtIndex: index)
        tableViewHeaderLabels.append(headerLabel)
    }
    
    open func heightForRowAtIndex(_ index: TSTableViewRowIndex) -> CGFloat {
        if let heightForRowAtIndex = tableViewDelegate!.tableView?(self, heightForRowAtIndex: index) {
            return heightForRowAtIndex
        }
        return defaultTableViewRowHeight
    }
    
    open func yValueForRowAtIndex(_ index: TSTableViewRowIndex) -> CGFloat {
        var rowYValue = defaultTableViewHeaderHeight
        for previousIndex in 0 ..< index {
            let previousRowHeight = heightForRowAtIndex(previousIndex)
            rowYValue += previousRowHeight
        }
        return rowYValue
    }
    
    fileprivate func calculatedRowWidth() -> CGFloat {
        var rowWidth: CGFloat = 0
        for columnIndex in 0 ..< tableViewDelegate!.numberOfColumnsInTableView(self) {
            let columnWidth = widthForColumnAtIndex(columnIndex)
            rowWidth += columnWidth
        }
        return rowWidth
    }
    
    fileprivate func createRows() {
        for index in 0 ..< tableViewDelegate!.numberOfRowsInTableView(self) {
            createRowViewAtIndex(index)
        }
    }
    
    fileprivate func createRowViewAtIndex(_ index: TSTableViewRowIndex) {
        let rowView = UIView(frame: CGRect(x: 0, y: yValueForRowAtIndex(index), width: rowWidth, height: heightForRowAtIndex(index)))
        rowView.backgroundColor = backgroundColorForRowAtIndex(index)
        tableViewRowViews.append(rowView)
    }
    
    fileprivate func backgroundColorForRowAtIndex(_ index: TSTableViewRowIndex) -> UIColor {
        if index % 2 == 0 {
            return defaultTableViewBackgroundColorForEvenRow
        }
        return defaultTableViewBackgroundColorForUnevenRow
    }
    
    fileprivate func createCells() {
        for rowIndex in 0 ..< tableViewDelegate!.numberOfRowsInTableView(self) {
            for columnIndex in 0 ..< tableViewDelegate!.numberOfColumnsInTableView(self) {
                createCellViewForCellWithCoordinates(TSTableViewCellCoordinate(columnIndex: columnIndex, rowIndex: rowIndex))
            }
        }
    }
    
    fileprivate func createCellViewForCellWithCoordinates(_ cellCoordinates: TSTableViewCellCoordinate) {
        if let cellView = tableViewDelegate!.tableView?(self, viewForCellWithCoordinates: cellCoordinates) {
            tableViewCellViews.append(cellView)
            return
        }
        createLabelForCellWithCoordinates(cellCoordinates)
    }
    
    fileprivate func createLabelForCellWithCoordinates(_ cellCoordinates: TSTableViewCellCoordinate) {
        let cellView = UIView(frame: CGRect(x: xValueForColumnAtIndex(cellCoordinates.columnIndex), y: yValueForRowAtIndex(cellCoordinates.rowIndex), width: widthForColumnAtIndex(cellCoordinates.columnIndex), height: heightForRowAtIndex(cellCoordinates.rowIndex)))
        let cellLabel = UILabel(frame: CGRect(x: defaultTableViewCellIndention, y: 0, width: widthForColumnAtIndex(cellCoordinates.columnIndex) - defaultTableViewCellIndention * 2, height: heightForRowAtIndex(cellCoordinates.rowIndex)))
        cellLabel.text = tableViewDelegate!.tableView(self, titleForCellWithCoordinates: cellCoordinates)
        cellView.addSubview(cellLabel)
        tableViewCellViews.append(cellView)
    }
    
    open func updateTableView() {
        for view in subviews {
            view.removeFromSuperview()
        }
        addTableViewHeaderViews()
        addTableViewRowViews()
        addTableViewCellViews()
    }
    
    fileprivate func addTableViewHeaderViews() {
        createHeaderViews()
        for headerLabel in tableViewHeaderLabels {
            addSubview(headerLabel)
        }
    }
    
    fileprivate func addTableViewRowViews() {
        createRows()
        for rowView in tableViewRowViews {
            addSubview(rowView)
        }
    }
    
    fileprivate func addTableViewCellViews() {
        createCells()
        for cellView in tableViewCellViews {
            addSubview(cellView)
        }
    }
    
    open func headerLabelForColumnAtIndex(_ index: TSTableViewColumnIndex) -> UILabel? {
        if tableViewHeaderLabels.indices.contains(index) {
            return tableViewHeaderLabels[index]
        }
        return nil
    }
    
    open func rowViewAtIndex(_ index: TSTableViewRowIndex) -> UIView? {
        if tableViewRowViews.indices.contains(index) {
            return tableViewRowViews[index]
        }
        return nil
    }
    
    open func cellViewForCellWithCoordinates(_ cellCoordinates: TSTableViewCellCoordinate) -> UIView? {
        let tableViewCellViewsIndex = cellCoordinates.rowIndex * tableViewDelegate!.numberOfColumnsInTableView(self) + cellCoordinates.columnIndex
        if tableViewCellViews.indices.contains(tableViewCellViewsIndex) {
            return tableViewCellViews[tableViewCellViewsIndex]
        }
        return nil
    }

}
