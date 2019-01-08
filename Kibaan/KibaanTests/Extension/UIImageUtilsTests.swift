//
//  UIImageUtilsTests.swift
//  KibaanTests
//
//  Created by 佐藤 雅輝 on 2018/12/26.
//  Copyright © 2018年 altonotes Inc. All rights reserved.
//

import XCTest
@testable import Kibaan

class UIImageUtilsTests: XCTestCase {
    // 保留
    func testMakeColorImageサイズ指定あり() {
        UIGraphicsBeginImageContext(CGSize(width: 20, height: 30))
        let image = UIImage.makeColorImage(color: .red, size: CGSize(width: 20, height: 30))
        if let image = image {
            XCTAssertEqual(image.size.width, 20)
            XCTAssertEqual(image.size.height, 30)
        } else {
            XCTFail()
        }
        UIGraphicsEndImageContext()
    }
    func testMakeColorImageサイズ指定なし() {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let image = UIImage.makeColorImage(color: .red)
        if let image = image {
            XCTAssertEqual(image.size.width, 1)
            XCTAssertEqual(image.size.height, 1)
        } else {
            XCTFail()
        }
        UIGraphicsEndImageContext()
    }
    
    func testMakeColorImage色取得できる() {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let image = UIImage.makeColorImage(color: .red)
        if let image = image {
            let color: UIColor = getPixelColor(image, CGPoint(x: 1, y: 1))
            XCTAssertEqual(color, .blue)
        } else {
            XCTFail()
        }
        UIGraphicsEndImageContext()
    }
    
    func testMakeColorImage色取得できない() {
        let image: UIImage = UIImage()
        let color: UIColor = getPixelColor(image, CGPoint(x: 1, y: 1))
        XCTAssertEqual(color, .clear)
    }
    
    // UIImageの色を取得する
    func getPixelColor(_ image: UIImage, _ point: CGPoint) -> UIColor {
        print(image)
        // 実態がない場合はクリアを返す
        if image.size == CGSize(width: 0, height: 0) {
            return UIColor.clear
        }
        let cgImage: CGImage = image.cgImage!
        guard let pixelData = CGDataProvider(data: (cgImage.dataProvider?.data)!)?.data else {
            return UIColor.clear
        }
        let data = CFDataGetBytePtr(pixelData)!
        let x = Int(point.x)
        let y = Int(point.y)
        let index = Int(image.size.width) * y + x
        let expectedLengthA = Int(image.size.width * image.size.height)
        let expectedLengthRGB = 3 * expectedLengthA
        let expectedLengthRGBA = 4 * expectedLengthA
        let numBytes = CFDataGetLength(pixelData)
        switch numBytes {
        case expectedLengthA:
            return UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(data[index])/255.0)
        case expectedLengthRGB:
            return UIColor(red: CGFloat(data[3*index])/255.0, green: CGFloat(data[3*index+1])/255.0, blue: CGFloat(data[3*index+2])/255.0, alpha: 1.0)
        case expectedLengthRGBA:
            return UIColor(red: CGFloat(data[4*index])/255.0, green: CGFloat(data[4*index+1])/255.0, blue: CGFloat(data[4*index+2])/255.0, alpha: CGFloat(data[4*index+3])/255.0)
        default:
            // unsupported format
            return UIColor.clear
        }
    }
}
