//
//  ViewController.swift
//  AnchorGestures
//
//  Created by Alessandro Toschi on 09/11/21.
//

import UIKit

class ViewController: UIViewController {
    
    var originalView: UIView!
    var rotatedView: UIView!
    var resizableView: ResizableView!
    
    func adjust(point: CGPoint, to angle: CGFloat) -> CGPoint {
        return CGPoint(
            x: point.x * cos(angle) - point.y * sin(angle),
            y: point.x * sin(angle) + point.y * cos(angle)
        )
    }
    
    enum AnchorPoint {
        
        case topLeft
        case topRight
        case bottomRight
        case bottomLeft
        
        func offset(oldSize: CGSize, newSize: CGSize) -> CGPoint {
            
            switch self {
                    
                case .topLeft:
                    return .zero
                    
                case .topRight:
                    return CGPoint(
                        x: -(newSize.width - oldSize.width),
                        y: 0.0
                    )
                    
                case .bottomRight:
                    return CGPoint(
                        x: -(newSize.width - oldSize.width),
                        y: -(newSize.height - oldSize.height)
                    )
                    
                case .bottomLeft:
                    return CGPoint(
                        x: 0.0,
                        y: -(newSize.height - oldSize.height)
                    )
                    
            }
            
        }
        
        func vertex(of rect: CGRect, for angle: CGFloat) -> CGPoint {
            
            let transform = CGAffineTransform.identity.translatedBy(x: rect.midX, y: rect.midY).rotated(by: angle).translatedBy(x: -rect.midX, y: -rect.midY)
            let rotatedRect = rect.applying(transform)
            let cosAngle = cos(angle)
            let sinAngle = sin(angle)
            let halfWidth = rect.width / 2.0
            let halfHeight = rect.height / 2.0

            switch self {
                    
                case .topLeft:
                    return CGPoint(
                        x: rotatedRect.midX - (halfWidth * cosAngle - halfHeight * sinAngle),
                        y: rotatedRect.midY - (halfWidth * sinAngle + halfHeight * cosAngle)
                    )
                    
                case .topRight:
                    return CGPoint(
                        x: rotatedRect.midX + (halfWidth * cosAngle + halfHeight * sinAngle),
                        y: rotatedRect.midY + (halfWidth * sinAngle - halfHeight * cosAngle)
                    )
                    
                case .bottomRight:
                    return CGPoint(
                        x: rotatedRect.midX + (halfWidth * cosAngle - halfHeight * sinAngle),
                        y: rotatedRect.midY + (halfWidth * sinAngle + halfHeight * cosAngle)
                    )
                    
                case .bottomLeft:
                    return CGPoint(
                        x: rotatedRect.midX - (halfWidth * cosAngle + halfHeight * sinAngle),
                        y: rotatedRect.midY - (halfWidth * sinAngle - halfHeight * cosAngle)
                    )
                    
            }
            
        }
        
    }

    override func viewDidLoad() {
        
        super.viewDidLoad()

        let angle: CGFloat = .pi / 6.0
        let anchorPoint = AnchorPoint.topRight
        
        let transform = CGAffineTransform.identity
        
        let origin = CGPoint(x: 150.0, y: 150.0)
        let size = CGSize(width: 120.0, height: 170.0)
        let newSize = CGSize(width: size.width * 1.2, height: size.height * 1.2)
        
        let offset = anchorPoint.offset(oldSize: size, newSize: newSize)
        
        let originalRect = CGRect(origin: origin, size: size)
        let scaledRect = CGRect(origin: CGPoint(x: origin.x + offset.x, y: origin.y + offset.y), size: newSize)
        
        
                
        //let r1 = CGRect(origin: origin, size: size).applying(transform.translatedBy(x: originalRect.midX, y: originalRect.midY).rotated(by: angle).translatedBy(x: -originalRect.midX, y: -originalRect.midY))
        
        //let adjustedMidpoint1 = adjust(point: CGPoint(x: size.width / 2.0, y: size.height / 2.0), to: angle)
        //let tl1 = CGPoint(x: r1.midX - adjustedMidpoint1.x, y: r1.midY - adjustedMidpoint1.y)
        let v1 = anchorPoint.vertex(of: originalRect, for: angle)
        
        //let r2 = CGRect(origin: origin, size: newSize).applying(transform.translatedBy(x: scaledRect.midX, y: scaledRect.midY).rotated(by: angle).translatedBy(x: -scaledRect.midX, y: -scaledRect.midY))
        
        //let adjustedMidpoint2 = adjust(point: CGPoint(x: newSize.width / 2.0, y: newSize.height / 2.0), to: angle)
        //let tl2 = CGPoint(x: r2.midX - adjustedMidpoint2.x, y: r2.midY - adjustedMidpoint2.y)
        let v2 = anchorPoint.vertex(of: scaledRect, for: angle)
        
        let dx = v2.x - v1.x
        let dy = v2.y - v1.y
        
        self.resizableView = ResizableView(frame: CGRect(origin: CGPoint(x: 150, y: 150), size: newSize))
        self.resizableView.backgroundColor = .cyan
        self.resizableView.frame.origin = CGPoint(x: self.resizableView.frame.origin.x - dx + offset.x, y: self.resizableView.frame.origin.y - dy + offset.y)
        self.resizableView.transform = transform.rotated(by: angle)
        self.view.addSubview(self.resizableView)
        
        self.rotatedView = UIView(frame: CGRect(origin: CGPoint(x: 150.0, y: 150.0), size: size))
        self.rotatedView.backgroundColor = .green
        self.rotatedView.transform = .identity.rotated(by: angle)
        
        self.view.addSubview(self.rotatedView)
        
        //self.originalView = UIView(frame: r1)
        //self.originalView.translatesAutoresizingMaskIntoConstraints = false
        //self.originalView.layer.borderWidth = 1
        //self.originalView.layer.borderColor = UIColor.red.cgColor

        //self.view.addSubview(self.originalView)
        //
        //let b2 = UIView(frame: r2)
        //b2.translatesAutoresizingMaskIntoConstraints = false
        //b2.layer.borderWidth = 1
        //b2.layer.borderColor = UIColor.red.cgColor

        //self.view.addSubview(b2)
        
    }


}

