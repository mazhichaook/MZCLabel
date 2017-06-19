//
//  ViewController.swift
//  MZCLabel
//
//  Created by Zhichao Ma on 2017/6/19.
//  Copyright © 2017年 Zhichao Ma. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let label = MZCLabel(frame: CGRect(x: 20, y: 100, width: 300, height: 100))
        
        label.text = "第一个高亮字符串http://www.baidu.com。第二个高亮字符串http://cn.bing.com，试试看吧！"
        label.numberOfLines = 0
        view.addSubview(label)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

