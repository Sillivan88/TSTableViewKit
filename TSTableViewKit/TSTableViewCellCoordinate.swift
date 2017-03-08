//
//  TSTableViewCellCoordinate.swift
//  TSTableView
//
//  Created by Thomas Sillmann on 15.04.16.
//  Copyright © 2016 Thomas Sillmann. All rights reserved.
//

import UIKit

@objc open class TSTableViewCellCoordinate: NSObject {
    
    open var columnIndex: TSTableViewColumnIndex
    
    open var rowIndex: TSTableViewRowIndex
    
    public init(columnIndex: TSTableViewColumnIndex, rowIndex: TSTableViewRowIndex) {
        self.columnIndex = columnIndex
        self.rowIndex = rowIndex
    }

}
