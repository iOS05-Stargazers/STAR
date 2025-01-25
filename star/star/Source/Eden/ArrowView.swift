//
//  ArrowView.swift
//  star
//
//  Created by Eden on 1/25/25.
//

import UIKit

class ArrowView: UIView {
    var arrowColor: UIColor = .systemBlue
    
    override func draw(_ rect: CGRect) {
        let path = UIBezierPath()
        
        // 화살표 머리, 꼬리의 비율 설정
        let arrowWidth = rect.width * 0.4
        let arrowHeight = rect.height * 0.6
        
        // 화살표 꼬리
        path.move(to: CGPoint(x: rect.midX - arrowWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + arrowWidth / 2, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + arrowWidth / 2, y: rect.maxY - arrowHeight))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - arrowHeight))
        
        // 화살표 머리
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - arrowHeight))
        path.addLine(to: CGPoint(x: rect.midX - arrowWidth / 2, y: rect.maxY - arrowHeight))
        
        path.close()
        
        arrowColor.setFill()
        path.fill()
    }
}
