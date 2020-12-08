//
//  MyWebServiceOperation.swift
//  CCUViewer
//
//  Created by Ayush Kumar Sethi on 8/14/18.
//  Copyright © 2018 Rupbani. All rights reserved.
//

import UIKit
/**
  This class is used for initialization to call api in all pattern
 */
class MyWebServiceOperation: Operation {
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
}







