//
//  TSTableViewDelegate.swift
//  TSTableView
//
//  Created by Thomas Sillmann on 15.04.16.
//  Copyright © 2016 Thomas Sillmann. All rights reserved.
//

import Foundation

@objc public protocol TSTableViewDelegate {
    
    func numberOfRowsInTableView(tableView: TSTableView) -> Int
    
    func numberOfColumnsInTableView(tableView: TSTableView) -> Int
    
    func tableView(tableView: TSTableView, titleForColumnHeaderAtIndex index: TSTableViewColumnIndex) -> String
    
    func tableView(tableView: TSTableView, titleForCellWithCoordinates cellCoordinates: TSTableViewCellCoordinate) -> String
    
    optional func tableView(tableView: TSTableView, heightForRowAtIndex index: TSTableViewRowIndex) -> CGFloat
    
    optional func tableView(tableView: TSTableView, widthForColumnAtIndex index: TSTableViewColumnIndex) -> CGFloat
    
    optional func tableView(tableView: TSTableView, viewForCellWithCoordinates cellCoordinates: TSTableViewCellCoordinate) -> UIView?
    
}
