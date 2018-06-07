//
//  Double + Helper.swift
//
//  Created by Holger Hinzberg on 21.03.15.
//  Copyright (c) 2015 Holger Hinzberg. All rights reserved.
//

import Foundation

public extension Int
{
    public static func random(lower:Int, upper:Int) -> Int
    {
        let max = UInt32(upper - lower + 1)
        let res = arc4random_uniform(max)
        return Int(res) + lower
    }
}
