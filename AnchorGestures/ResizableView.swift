//
//  ResizableView.swift
//  AnchorGestures
//
//  Created by Alessandro Toschi on 09/11/21.
//

import UIKit

enum AnchorPoint {
    
    case topLeft
    case topRight
    case bottomLeft
    case bottomRight
    
}

class ResizableView: UIView {
    
    private var anchorPoint: AnchorPoint?
    private var initialSize: CGSize?
    private var initialPosition: CGPoint?
    private var lastPoint: CGPoint?

    private let angle: CGFloat = .pi / 6.0
    
    override init(frame: CGRect) {
        
        self.anchorPoint = nil
        self.initialSize = nil
        self.initialPosition = nil
        self.lastPoint = nil
        
        
        super.init(frame: frame)
                
        //self.transform = CGAffineTransform(rotationAngle: .pi / 6.0)
        
        //let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(panGesture(sender:)))
        //panGestureRecognizer.maximumNumberOfTouches = 1
        //panGestureRecognizer.minimumNumberOfTouches = 1
        //
        //self.addGestureRecognizer(panGestureRecognizer)
                
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panGesture(sender: UIPanGestureRecognizer) {
        
        switch sender.state {
                
            case .began:
                let initialPoint = sender.location(in: self)
                self.anchorPoint = self.anchor(for: initialPoint)
                self.initialSize = self.bounds.size
                self.initialPosition = initialPoint
                self.lastPoint = initialPoint
                
            case .changed:
                let currentPoint = sender.location(in: self)
                let delta: CGPoint
                
                switch(self.anchorPoint!){
                        
                    case .topLeft:
                        delta = CGPoint(
                            x: self.initialPosition!.x - currentPoint.x,
                            y: self.initialPosition!.y - currentPoint.y
                        )
                        
                    case .topRight:
                        delta = CGPoint(
                            x: currentPoint.x - self.initialPosition!.x,
                            y: self.initialPosition!.y - currentPoint.y
                        )
                        
                    case .bottomLeft:
                        delta = CGPoint(
                            x: self.initialPosition!.x - currentPoint.x,
                            y: currentPoint.y - self.initialPosition!.y
                        )
                        
                    case .bottomRight:
                        delta = CGPoint(
                            x: currentPoint.x - self.initialPosition!.x,
                            y: currentPoint.y - self.initialPosition!.y
                        )
                        
                }
                
                let directionalScale = CGPoint(
                    x: (delta.x / self.initialSize!.width) + 1.0,
                    y: (delta.y / self.initialSize!.height) + 1.0
                )
                let scale = max(0.1, (directionalScale.x + directionalScale.y) / 2.0)
                let offset: CGPoint
                switch self.anchorPoint! {
                
                    case .topLeft:
                        offset = CGPoint(x: self.bounds.width, y: self.bounds.height)
                    case .topRight:
                        offset = CGPoint(x: 0.0, y: self.bounds.height)
                    case .bottomLeft:
                        offset = CGPoint(x: self.bounds.width, y: 0.0)
                    case .bottomRight:
                        offset = .zero
                        
                }
                self.transform = CGAffineTransform(translationX: offset.x, y: offset.y)
                    .scaledBy(x: scale, y: scale)
                    .translatedBy(x: -offset.x, y: -offset.y)
                    .rotated(by: .pi / 6.0)
                //let lastSize = self.frame.size
                //self.frame.size = self.initialSize!.applying(CGAffineTransform(scaleX: scale, y: scale))
                //let d2 = self.bounds.size.width / lastSize.width
                //let offset: CGPoint
                //switch self.anchorPoint! {
                //
                //    case .topLeft:
                //        offset = CGPoint(x: lastSize.width, y: lastSize.height)
                //    case .topRight:
                //        offset = CGPoint(x: 0.0, y: lastSize.height)
                //    case .bottomLeft:
                //        offset = CGPoint(x: lastSize.width, y: 0.0)
                //    case .bottomRight:
                //        offset = .zero
                //}
                //self.frame.origin = CGPoint(
                //    x: self.frame.origin.x + offset.x * (1.0 - d2),
                //    y: self.frame.origin.y + offset.y * (1.0 - d2)
                //)
                self.lastPoint = currentPoint
                
            case .ended:
                self.anchorPoint = nil
                self.initialSize = nil
                self.initialPosition = nil
                self.lastPoint = nil
                
            @unknown default:
                return
                
        }
        
    }
    
    func anchor(for point: CGPoint) -> AnchorPoint {
        
        let halfSize = self.bounds.size.applying(CGAffineTransform(scaleX: 0.5, y: 0.5))
        
        if point.x >= halfSize.width && point.y >= halfSize.height {
            return .bottomRight
        } else if point.x >= halfSize.width && point.y <= halfSize.height {
            return .topRight
        } else if point.x <= halfSize.width && point.y <= halfSize.height {
            return .topLeft
        } else { return .bottomLeft }
        
    }
    
}
