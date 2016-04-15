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

public class TSTableView: UIScrollView {
    
    var tableViewDelegate: TSTableViewDelegate? {
        didSet {
            updateTableView()
        }
    }
    
    private let defaultTableViewColumnWidth: CGFloat = 200
    
    private let defaultTableViewCellIndention: CGFloat = 8
    
    private let defaultTableViewHeaderHeight: CGFloat = 44
    
    private var tableViewHeaderLabels = [UILabel]()
    
    private let defaultTableViewRowHeight: CGFloat = 44
    
    private lazy var rowWidth: CGFloat = {
        return self.calculatedRowWidth()
    }()
    
    private let defaultTableViewBackgroundColorForEvenRow = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1)
    
    private let defaultTableViewBackgroundColorForUnevenRow = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
    
    private var tableViewRowViews = [UIView]()
    
    private var tableViewCellViews = [UIView]()
    
    public func widthForColumnAtIndex(index: TSTableViewColumnIndex) -> CGFloat {
        if let columnWidth = tableViewDelegate!.tableView?(self, widthForColumnAtIndex: index) {
            return columnWidth
        }
        return defaultTableViewColumnWidth
    }
    
    public func xValueForColumnAtIndex(index: TSTableViewColumnIndex) -> CGFloat {
        var columnXValue: CGFloat = 0
        for previousIndex in 0 ..< index {
            let previousColumnWidth = widthForColumnAtIndex(previousIndex)
            columnXValue += previousColumnWidth
        }
        return columnXValue
    }
    
    private func createHeaderViews() {
        for index in 0 ..< tableViewDelegate!.numberOfColumnsInTableView(self) {
            createHeaderLabelForColumnAtIndex(index)
        }
    }
    
    private func createHeaderLabelForColumnAtIndex(index: TSTableViewColumnIndex) {
        let headerLabel = UILabel(frame: CGRectMake(xValueForColumnAtIndex(index) + defaultTableViewCellIndention, 0, widthForColumnAtIndex(index) - defaultTableViewCellIndention * 2, defaultTableViewHeaderHeight))
        headerLabel.font = UIFont.boldSystemFontOfSize(17)
        headerLabel.text = tableViewDelegate!.tableView(self, titleForColumnHeaderAtIndex: index)
        tableViewHeaderLabels.append(headerLabel)
    }
    
    public func heightForRowAtIndex(index: TSTableViewRowIndex) -> CGFloat {
        if let heightForRowAtIndex = tableViewDelegate!.tableView?(self, heightForRowAtIndex: index) {
            return heightForRowAtIndex
        }
        return defaultTableViewRowHeight
    }
    
    public func yValueForRowAtIndex(index: TSTableViewRowIndex) -> CGFloat {
        var rowYValue = defaultTableViewHeaderHeight
        for previousIndex in 0 ..< index {
            let previousRowHeight = heightForRowAtIndex(previousIndex)
            rowYValue += previousRowHeight
        }
        return rowYValue
    }
    
    private func calculatedRowWidth() -> CGFloat {
        var rowWidth: CGFloat = 0
        for columnIndex in 0 ..< tableViewDelegate!.numberOfColumnsInTableView(self) {
            let columnWidth = widthForColumnAtIndex(columnIndex)
            rowWidth += columnWidth
        }
        return rowWidth
    }
    
    private func createRows() {
        for index in 0 ..< tableViewDelegate!.numberOfRowsInTableView(self) {
            createRowViewAtIndex(index)
        }
    }
    
    private func createRowViewAtIndex(index: TSTableViewRowIndex) {
        let rowView = UIView(frame: CGRectMake(0, yValueForRowAtIndex(index), rowWidth, heightForRowAtIndex(index)))
        rowView.backgroundColor = backgroundColorForRowAtIndex(index)
        tableViewRowViews.append(rowView)
    }
    
    private func backgroundColorForRowAtIndex(index: TSTableViewRowIndex) -> UIColor {
        if index % 2 == 0 {
            return defaultTableViewBackgroundColorForEvenRow
        }
        return defaultTableViewBackgroundColorForUnevenRow
    }
    
    private func createCells() {
        for rowIndex in 0 ..< tableViewDelegate!.numberOfRowsInTableView(self) {
            for columnIndex in 0 ..< tableViewDelegate!.numberOfColumnsInTableView(self) {
                createCellViewForCellWithCoordinates(TSTableViewCellCoordinate(columnIndex: columnIndex, rowIndex: rowIndex))
            }
        }
    }
    
    private func createCellViewForCellWithCoordinates(cellCoordinates: TSTableViewCellCoordinate) {
        if let cellView = tableViewDelegate!.tableView?(self, viewForCellWithCoordinates: cellCoordinates) {
            tableViewCellViews.append(cellView)
            return
        }
        createLabelForCellWithCoordinates(cellCoordinates)
    }
    
    private func createLabelForCellWithCoordinates(cellCoordinates: TSTableViewCellCoordinate) {
        let cellView = UIView(frame: CGRectMake(xValueForColumnAtIndex(cellCoordinates.columnIndex), yValueForRowAtIndex(cellCoordinates.rowIndex), widthForColumnAtIndex(cellCoordinates.columnIndex), heightForRowAtIndex(cellCoordinates.rowIndex)))
        let cellLabel = UILabel(frame: CGRectMake(defaultTableViewCellIndention, 0, widthForColumnAtIndex(cellCoordinates.columnIndex) - defaultTableViewCellIndention * 2, heightForRowAtIndex(cellCoordinates.rowIndex)))
        cellLabel.text = tableViewDelegate!.tableView(self, titleForCellWithCoordinates: cellCoordinates)
        cellView.addSubview(cellLabel)
        tableViewCellViews.append(cellView)
    }
    
    public func updateTableView() {
        for view in subviews {
            view.removeFromSuperview()
        }
        addTableViewHeaderViews()
        addTableViewRowViews()
        addTableViewCellViews()
    }
    
    private func addTableViewHeaderViews() {
        createHeaderViews()
        for headerLabel in tableViewHeaderLabels {
            addSubview(headerLabel)
        }
    }
    
    private func addTableViewRowViews() {
        createRows()
        for rowView in tableViewRowViews {
            addSubview(rowView)
        }
    }
    
    private func addTableViewCellViews() {
        createCells()
        for cellView in tableViewCellViews {
            addSubview(cellView)
        }
    }
    
    public func headerLabelForColumnAtIndex(index: TSTableViewColumnIndex) -> UILabel? {
        if tableViewHeaderLabels.indices.contains(index) {
            return tableViewHeaderLabels[index]
        }
        return nil
    }
    
    public func rowViewAtIndex(index: TSTableViewRowIndex) -> UIView? {
        if tableViewRowViews.indices.contains(index) {
            return tableViewRowViews[index]
        }
        return nil
    }
    
    public func cellViewForCellWithCoordinates(cellCoordinates: TSTableViewCellCoordinate) -> UIView? {
        let tableViewCellViewsIndex = cellCoordinates.rowIndex * tableViewDelegate!.numberOfColumnsInTableView(self) + cellCoordinates.columnIndex
        if tableViewCellViews.indices.contains(tableViewCellViewsIndex) {
            return tableViewCellViews[tableViewCellViewsIndex]
        }
        return nil
    }

}
