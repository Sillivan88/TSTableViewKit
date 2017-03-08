//
//  TSTableViewDelegate.swift
//  TSTableView
//
//  Created by Thomas Sillmann on 15.04.16.
//  Copyright © 2016 Thomas Sillmann. All rights reserved.
//

import Foundation

@objc public protocol TSTableViewDelegate {
    
    func numberOfRowsInTableView(_ tableView: TSTableView) -> Int
    
    func numberOfColumnsInTableView(_ tableView: TSTableView) -> Int
    
    func tableView(_ tableView: TSTableView, titleForColumnHeaderAtIndex index: TSTableViewColumnIndex) -> String
    
    func tableView(_ tableView: TSTableView, titleForCellWithCoordinates cellCoordinates: TSTableViewCellCoordinate) -> String
    
    @objc optional func tableView(_ tableView: TSTableView, heightForRowAtIndex index: TSTableViewRowIndex) -> CGFloat
    
    @objc optional func tableView(_ tableView: TSTableView, widthForColumnAtIndex index: TSTableViewColumnIndex) -> CGFloat
    
    @objc optional func tableView(_ tableView: TSTableView, viewForCellWithCoordinates cellCoordinates: TSTableViewCellCoordinate) -> UIView?
    
}
