//
//  PickerViewController.swift
//  iOSTemplate
//
//  Created by Yamamoto Keita on 2018/07/20.
//  Copyright © 2018年 altonotes. All rights reserved.
//

import UIKit

open class PickerViewController: SmartViewController {
    
    @IBOutlet weak open var pickerView: UIPickerView!
    
    open var records: [Item] = [] {
        didSet {
            pickerView.reloadAllComponents()
        }
    }
    
    open var onSelected: ((String, Int) -> Void)?
    
    override open func viewDidLoad() {
        super.viewDidLoad()

        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    open func setup(records: [Item], selectedIndex: Int?, onSelected: ((String, Int) -> Void)? = nil) {
        self.records = records
        self.onSelected = onSelected
        if let index = selectedIndex {
            pickerView.selectRow(index, inComponent: 0, animated: false)
        }
    }
    
    open func setup(records: [Item], selectedItem: String?, onSelected: ((String, Int) -> Void)? = nil) {
        let selectedIndex = records.firstIndex { $0.title == selectedItem }
        setup(records: records, selectedIndex: selectedIndex, onSelected: onSelected)
    }
    
    open func setup(records: [String], selectedIndex: Int?, onSelected: ((String, Int) -> Void)? = nil) {
        let items = records.map { Item(title: $0) }
        setup(records: items, selectedIndex: selectedIndex, onSelected: onSelected)
    }
    
    open func setup(records: [String], selectedItem: String?, onSelected: ((String, Int) -> Void)? = nil) {
        let items = records.map { Item(title: $0) }
        setup(records: items, selectedItem: selectedItem, onSelected: onSelected)
    }

    @IBAction open func actionCompleteButton(_ sender: Any) {
        let row = pickerView.selectedRow(inComponent: 0)
        let item = records[row].title
        
        onSelected?(item, row)
        owner?.removeOverlay()
    }
    
    @IBAction open func actionCancelButton(_ sender: Any) {
        owner?.removeOverlay()
    }
    
    public class Item {
        public var title: String
        public var isEnabled: Bool
        public init(title: String, isEnabled: Bool = true) {
            self.title = title
            self.isEnabled = isEnabled
        }
    }
}

extension PickerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    // UIPickerViewの列の数
    open func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数
    open func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return records.count
    }
    
    open func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label: SmartLabel? = view as? SmartLabel
        if label == nil {
            let rowSize = pickerView.rowSize(forComponent: component)
            let margin: CGFloat = 10
            label = SmartLabel(frame: CGRect(x: margin, y: 0, width: rowSize.width - (margin * 2), height: rowSize.height))
            label?.adjustsFontSizeToFitWidth = true
            label?.minimumScaleFactor = 0.5
            label?.textAlignment = .center
        }
        let item = records[row]
        let color = item.isEnabled ? UIColor.black : UIColor.gray
        let attrTitle = NSAttributedString(string: item.title, attributes: [.foregroundColor: color])
        label?.attributedText = attrTitle
        return label ?? UIView()
    }
    
    // UIPickerViewのRowが選択された時の挙動
    open func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if records[row].isEnabled { return }
        
        var target = row
        
        while !records[target].isEnabled {
            target += 1
            if records.count <= target {
                target = 0
            } else if target == row {
                return
            }
        }
        
        pickerView.selectRow(target, inComponent: component, animated: true)
    }
}
