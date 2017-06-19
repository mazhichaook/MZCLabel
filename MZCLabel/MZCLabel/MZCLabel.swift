//
//  MZCLabel.swift
//  MZCLabel
//
//  Created by Zhichao Ma on 2017/6/19.
//  Copyright © 2017年 Zhichao Ma. All rights reserved.
//

import UIKit

class MZCLabel: UILabel {
    //MARK: - 重写的属性
    override  var text: String? {
        didSet{
            prepareTextContent()
        }
    }
    //MARK: - 构造函数

    override init(frame: CGRect) {
        super.init(frame: frame)
        prepareTestSystem()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        // 获取用户点击的位置
        guard let location = touches.first?.location(in: self) else {
            return
        }
        // 获取当前点中字符的索引
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        
        // 判断index是否在搜索自负盈亏范围内，如果在，就高亮
        for r in urlRanges ?? []{
            if NSLocationInRange(index, r) {
                print("选中了")
                textStorage.addAttributes([NSForegroundColorAttributeName: UIColor.blue], range: r)
                // 如果需要重回，需要调用此方法
                setNeedsLayout()
            }else{
                print("没有点到")
            }
        }
    }
    override func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        
        //绘制背景 在iOS 中绘制巩固走类似油画，后绘制的内容，会把之前绘制的内容覆盖
        layoutManager.drawBackground(forGlyphRange: range, at: CGPoint())
        // Glyphs
        layoutManager.drawGlyphs(forGlyphRange: range, at: CGPoint())
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //只等绘制文本的区域
        textContainer.size = bounds.size
    }
        //MARK:- TextKit 的核心对象
    /// 属性文本存储
    fileprivate lazy var textStorage = NSTextStorage()
    /// 负责文本“字形”布局
    fileprivate lazy var layoutManager = NSLayoutManager()
    /// 设定文本绘制范围
    fileprivate lazy var textContainer = NSTextContainer()
}
// MARK: - 设置 TextKit 核心对象
extension MZCLabel{
    // 准备文本系统
    func prepareTestSystem() {
        //开启用户交互
        isUserInteractionEnabled = true
        // 准备文本内容
        prepareTextContent()
        // 设置对象的关系
        textStorage.addLayoutManager(layoutManager)
        
        layoutManager.addTextContainer(textContainer)
    }
    // 准备文本内容 - 使用TestStorage接管label的内容
    func prepareTextContent() {
        if let attributedText = attributedText {
            textStorage.setAttributedString(attributedText)
        }else if let text = text{
            textStorage.setAttributedString(NSAttributedString(string: text))
        }else{
            textStorage.setAttributedString(NSAttributedString(string: ""))
        }
        
        //遍历范围数组，设置url 文字的属性
        for r in urlRanges ?? [] {
            textStorage.addAttributes([NSForegroundColorAttributeName: UIColor.red,NSBackgroundColorAttributeName: UIColor.groupTableViewBackground], range: r)
        }
    }
}
// MARK: - 使用正则表达式 过滤textStrorage 中的字符串 范围数组
fileprivate extension MZCLabel{
    //返回textStorage中高度URL range数组
    var urlRanges:[NSRange]?{
        // 正则表达式
        let regex = "[a-zA-Z]*://[a-zA-Z0-9/\\.]*"
        
        guard let regx = try? NSRegularExpression(pattern: regex, options: []) else {
            return nil
        }
        
        // 多重匹配
        let matches = regx.matches(in: textStorage.string, options: [], range: NSRange(location: 0, length: textStorage.length))
        // 便利数组，生成Range数组
        var rangeArr = [NSRange]()
        
        for item in matches{
            rangeArr.append(item.rangeAt(0))
        }
        return rangeArr
    }
}
