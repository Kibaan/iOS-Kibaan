//  Created by Akira Nakajima on 2018/08/06.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import XCTest
@testable import Kibaan

class DateUtilsTests: XCTestCase {
    
    // MARK: - Variables
    
    private let calendar = Calendar.current
    private let dayMinute = 60 * 60 * 24
    
    // MARK: - Create
    
    func testCreateAndString_yyyy() {
        let testData = "2018"
        let testFormat = "yyyy"
        guard let date = Date.create(string: testData, format: testFormat) else { return }
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(date.string(format: testFormat), testData)
    }
    func testCreateAndString_yyyyMM() {
        let testData = "201809"
        let testFormat = "yyyyMM"
        guard let date = Date.create(string: testData, format: testFormat) else { return }
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 9)
        XCTAssertEqual(date.string(format: testFormat), testData)
    }
    
    func testCreateAndString_yyyyMMdd() {
        let testData = "20180912"
        let testFormat = "yyyyMM"
        guard let date = Date.create(string: testData, format: testFormat) else { return }
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 9)
        XCTAssertEqual(calendar.component(.day, from: date), 12)
        XCTAssertEqual(date.string(format: testFormat), testData)
    }
    
    func testCreateAndString_yyyyMMddHH() {
        let testData = "2018091214"
        let testFormat = "yyyyMMHH"
        guard let date = Date.create(string: testData, format: testFormat) else { return }
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 9)
        XCTAssertEqual(calendar.component(.day, from: date), 12)
        XCTAssertEqual(calendar.component(.hour, from: date), 14)
        XCTAssertEqual(calendar.component(.minute, from: date), 0)
        XCTAssertEqual(date.string(format: testFormat), testData)
    }
    
    func testCreateAndString_yyyyMMddHHmm() {
        let testData = "201808061200"
        let testFormat = "yyyyMMddHHmm"
        guard let date = Date.create(string: testData, format: testFormat) else { return }
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 8)
        XCTAssertEqual(calendar.component(.day, from: date), 6)
        XCTAssertEqual(calendar.component(.hour, from: date), 12)
        XCTAssertEqual(calendar.component(.minute, from: date), 0)
        XCTAssertEqual(date.string(format: testFormat), testData)
    }
    
    func testCreateAndString_yyyy_MM_ddHH_mm_セパレータあり() {
        let testData = "2018/09/12 14:00"
        let testFormat = "yyyy/MM/dd HH:mm"
        guard let date = Date.create(string: testData, format: testFormat) else { return }
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 9)
        XCTAssertEqual(calendar.component(.day, from: date), 12)
        XCTAssertEqual(calendar.component(.hour, from: date), 14)
        XCTAssertEqual(calendar.component(.minute, from: date), 0)
        XCTAssertEqual(date.string(format: testFormat), testData)
    }
    
    func testCreateAndString_yyyy_MM_ddHH_mm_日本語含む() {
        let testData = "2018年09月12日 14時00分"
        let testFormat = "yyyy年MM月dd日 HH時mm分"
        guard let date = Date.create(string: testData, format: testFormat) else { return }
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 9)
        XCTAssertEqual(calendar.component(.day, from: date), 12)
        XCTAssertEqual(calendar.component(.hour, from: date), 14)
        XCTAssertEqual(calendar.component(.minute, from: date), 0)
        XCTAssertEqual(date.string(format: testFormat), testData)
    }
    
    // MARK: - Year Added
    
    func testYearAdded_プラス１() {
        guard let date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        XCTAssertEqual(calendar.component(.year, from: date.yearAdded(1)), 2019)
    }
    
    func testYearAdded_プラス１００() {
        guard let date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        XCTAssertEqual(calendar.component(.year, from: date.yearAdded(100)), 2118)
    }
    
    func testYearAdded_マイナス１() {
        guard let date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        XCTAssertEqual(calendar.component(.year, from: date.yearAdded(-1)), 2017)
    }
    
    func testYearAdded_マイナス１００() {
        guard let date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        XCTAssertEqual(calendar.component(.year, from: date.yearAdded(-100)), 1918)
    }
    
    func testYearAdded_プラス０() {
        guard let date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        XCTAssertEqual(calendar.component(.year, from: date.yearAdded(0)), 2018)
    }
    
    // MARK: - Month Added
    
    func testMonthAdded_プラス１() {
        guard var date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        date = date.monthAdded(1)
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 9)
        XCTAssertEqual(calendar.component(.day, from: date), 6)
    }
    
    func testMonthAdded_プラス１２() {
        guard var date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        date = date.monthAdded(12)
        XCTAssertEqual(calendar.component(.year, from: date), 2019)
        XCTAssertEqual(calendar.component(.month, from: date), 8)
        XCTAssertEqual(calendar.component(.day, from: date), 6)
    }
    
    func testMonthAdded_マイナス１() {
        guard var date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        date = date.monthAdded(-1)
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 7)
        XCTAssertEqual(calendar.component(.day, from: date), 6)
    }
    
    func testMonthAdded_マイナス１２() {
        guard var date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        date = date.monthAdded(-12)
        XCTAssertEqual(calendar.component(.year, from: date), 2017)
        XCTAssertEqual(calendar.component(.month, from: date), 8)
        XCTAssertEqual(calendar.component(.day, from: date), 6)
    }
    
    // MARK: - Day Added
    
    func testDayAdded_プラス１() {
        guard var date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        date = date.dayAdded(1)
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 8)
        XCTAssertEqual(calendar.component(.day, from: date), 7)
    }
    
    func testDayAdded_プラス月加算() {
        guard var date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        date = date.dayAdded(26)
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 9)
        XCTAssertEqual(calendar.component(.day, from: date), 1)
    }
    
    func testDayAdded_マイナス１() {
        guard var date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        date = date.dayAdded(-1)
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 8)
        XCTAssertEqual(calendar.component(.day, from: date), 5)
    }
    
    func testDayAdded_マイナス月減算() {
        guard var date = Date.create(string: "201808061200", format: "yyyyMMddHHmm") else { return }
        date = date.dayAdded(-6)
        XCTAssertEqual(calendar.component(.year, from: date), 2018)
        XCTAssertEqual(calendar.component(.month, from: date), 7)
        XCTAssertEqual(calendar.component(.day, from: date), 31)
    }
    
    func testCountMilliSeconds_normal() {
        guard let fromDate = Date.create(string: "201810101200", format: "yyyyMMddHHmm") else { return }
        let toDate = fromDate.secondAdded(value: 1)
        let second = toDate.countMilliSeconds(from: fromDate)
        XCTAssertEqual(second, 1000)
    }
    
    func testCountMilliSeconds_nextDay() {
        guard let fromDate = Date.create(string: "201810101200", format: "yyyyMMddHHmm") else { return }
        let toDate = fromDate.dayAdded(1)
        let second = toDate.countMilliSeconds(from: fromDate)
        XCTAssertEqual(second, dayMinute * 1000)
    }
    
    func testCountSeconds_normal() {
        guard let fromDate = Date.create(string: "201810101200", format: "yyyyMMddHHmm") else { return }
        let toDate = fromDate.secondAdded(value: 10)
        let second = toDate.countSeconds(from: fromDate)
        XCTAssertEqual(second, 10)
    }
    
    func testCountSeconds_nextDay() {
        guard let fromDate = Date.create(string: "201810101200", format: "yyyyMMddHHmm") else { return }
        let toDate = fromDate.dayAdded(1)
        let second = toDate.countSeconds(from: fromDate)
        XCTAssertEqual(second, dayMinute)
    }
}
