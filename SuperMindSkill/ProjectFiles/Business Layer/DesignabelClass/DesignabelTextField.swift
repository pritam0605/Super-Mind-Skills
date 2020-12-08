//
//  LoginVC.swift
//  SuperMindSkill
//
//  Created by Abhik on 27/01/20.
//  Copyright © 2020 Abhik. All rights reserved.
//

import UIKit



@IBDesignable
class DesignabelTextField: UITextField {

    // Provides left padding for images
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += leftPadding
        return textRect
    }
    
    override func rightViewRect(forBounds bounds: CGRect) -> CGRect {
        var textRect = super.leftViewRect(forBounds: bounds)
        textRect.origin.x += rightPadding
        return textRect
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
         var textRect = super.textRect(forBounds: bounds)
         textRect.origin.x += imageTextGap
         return textRect
    }
    
//    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
//        var placeholder = super.placeholderRect(forBounds: bounds)
//        placeholder.origin.x += imageTextGap
//        return placeholder
//
//    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        var area = super.editingRect(forBounds: bounds)
               area.origin.x += imageTextGap
               return area
    }
    
 

    @IBInspectable var leftImage: UIImage? {
        didSet {
            updateView()
        }
    }

    @IBInspectable var leftPadding: CGFloat = 0.0
    @IBInspectable var rightPadding:CGFloat = 0.0
    @IBInspectable var imageTextGap:CGFloat = 0.0

    @IBInspectable var color: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    @IBInspectable var customPlaceHolderColor: UIColor = UIColor.lightGray {
        didSet {
            updateView()
        }
    }
    func updateView() {
        if let image = leftImage {
            leftViewMode = UITextField.ViewMode.always
            let imageView = UIImageView(image: image)
            imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
            imageView.contentMode = .left
            //imageView.image = image
            imageView.tintColor = color
            leftView = imageView
            
            /////set text field place holder color
            var placeHolder = NSMutableAttributedString()
            //let Name  = "Placeholder Text"
            // Set the Font
            placeHolder = NSMutableAttributedString(string:self.placeholder ?? "bb", attributes: [NSAttributedString.Key.font:self.font!])

            // Set the color
            placeHolder.addAttribute(NSAttributedString.Key.foregroundColor, value: customPlaceHolderColor, range:NSRange(location:0,length:self.placeholder?.count ?? 0))

            // Add attribute
            self.attributedPlaceholder = placeHolder
            
            
        } else {
            leftViewMode = UITextField.ViewMode.never
            leftView = nil
        }

      
    }
}




@IBDesignable
class ButtionX: UIButton {
    @IBInspectable var cornerRadious:CGFloat = 0{
        didSet {
            self.layer.cornerRadius = cornerRadious
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
 
}



@IBDesignable
class ImageViewX: UIImageView {
    @IBInspectable var cornerRadious:CGFloat = 0{
        didSet {
            //self.layer.cornerRadius = cornerRadious
            self.layer.cornerRadius = UIDevice.current.userInterfaceIdiom == .pad ? 55 : 48
         
            
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
}


@IBDesignable
class ViewX: UIView {
    
    @IBInspectable var cornerRadious:CGFloat = 0{
        didSet {
            self.layer.cornerRadius = cornerRadious
        }
    }
    @IBInspectable var borderWidth:CGFloat = 0{
        didSet {
            self.layer.borderWidth = borderWidth
        }
    }
    @IBInspectable var borderColor:UIColor = UIColor.clear{
        didSet {
            self.layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}

