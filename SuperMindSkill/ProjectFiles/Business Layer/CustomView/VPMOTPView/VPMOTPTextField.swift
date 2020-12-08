//
//  LoginVC.swift
//  EquineOrganiser
//
//  Created by Rupbani on 09/07/19.
//  Copyright © 2018 Rupbani. All rights reserved.
//

import UIKit

class VPMOTPTextField: UITextField {
    /// Border color info for field
    var borderColor: UIColor = UIColor.white
    
    /// Border width info for field
    var borderWidth: CGFloat = 2
    
    var shapeLayer: CAShapeLayer!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initalizeUI(forFieldType type: VPMOTPView.DisplayType) {
        switch type {
        case .circular:
            layer.cornerRadius = bounds.size.width / 2
        case .square:
            layer.cornerRadius = 0
        case .diamond:
            addDiamondMask()
        case .underlinedBottom:
            addBottomView()
        }
        
        // Basic UI setup
        if type != .diamond && type != .underlinedBottom {
            layer.borderColor = borderColor.cgColor
            layer.borderWidth = borderWidth
        }
        autocorrectionType = .no
        textAlignment = .center
        
        self.inputAccessoryView = accessoryView(index: 0)
        self.inputAccessoryView?.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: 44)
    }
    
    override func deleteBackward() {
        super.deleteBackward()
        
        _ = delegate?.textField?(self, shouldChangeCharactersIn: NSMakeRange(0, 0), replacementString: "")
    }
    
    // Helper function to create diamond view
    fileprivate func addDiamondMask() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: bounds.size.width / 2.0, y: 0))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height / 2.0))
        path.addLine(to: CGPoint(x: bounds.size.width / 2.0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: 0, y: bounds.size.height / 2.0))
        path.close()
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        layer.mask = maskLayer
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = backgroundColor?.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        
        layer.addSublayer(shapeLayer)
    }
    
    // Helper function to create a underlined bottom view
    fileprivate func addBottomView() {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 0, y: bounds.size.height))
        path.addLine(to: CGPoint(x: bounds.size.width, y: bounds.size.height))
        path.close()
        
        shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.lineWidth = borderWidth
        shapeLayer.fillColor = backgroundColor?.cgColor
        shapeLayer.strokeColor = borderColor.cgColor
        
        layer.addSublayer(shapeLayer)
    }
}
extension VPMOTPTextField
{
    func accessoryView(index:Int) -> UIView {
        
        let view = UIView()
        view.backgroundColor = appBlueColor
        
        let doneButton = UIButton()
        doneButton.frame = CGRect(x: self.frame.size.width, y: 7, width: 60, height: 30)
        doneButton.setTitle("done" , for: .normal)
        doneButton.tag = index
        doneButton.addTarget(self, action: #selector(doneAction), for: .touchUpInside)
        view.addSubview(doneButton)
        
        return view
        
    }
    @objc func doneAction(_ sender: UIButton)
    {
        self.resignFirstResponder()
    }
}
