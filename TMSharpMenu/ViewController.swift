//
//  ViewController.swift
//  TMSharpMenu
//
//  Created by 天明 on 2017/3/14.
//  Copyright © 2017年 天明. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //根据某点按钮显示
    @IBAction func leftClick(_ sender: UIBarButtonItem) {
        let menu = createMenu(type: .up)
        menu.showAtPoint(point: CGPoint(x: 40, y: 54), inView: view)
    }
    
    //根据某点按钮显示
    @IBAction func rightClick(_ sender: UIBarButtonItem) {
        let menu = createMenu(type: .up)
        menu.showAtPoint(point: CGPoint(x: view.frame.width - 40, y: 54), inView: view)
    }
    
    //显示title类型
    @IBAction func showTitleMenu(_ sender: UIButton) {
        var config = TMSharpMenuConfig()
        var items: [TMSharpMenuItem] = []
        (0...3).forEach { (i) in
            let item: TMSharpMenuItem = (nil, "新建账户\(i)", {
                print("\(i) didClick")
            })
            items.append(item)
        }
        config.itemW = 90
        let menu = TMSharpMenu(items, config)
        menu.showWithView(v: sender, inView: view)
    }
    
    //显示图片类型(高亮图片：内部自动在普通图片名后追加 “_h”, 如“icon_account_popup_add_h”)
    @IBAction func showImageMenu(_ sender: UIButton) {
        var config = TMSharpMenuConfig()
        var items: [TMSharpMenuItem] = []
        (0...3).forEach { (i) in
            let item: TMSharpMenuItem = ("icon_account_popup_add", nil, {
                print("\(i) didClick")
            })
            items.append(item)
        }
        config.itemW = 50
        let menu = TMSharpMenu(items, config)
        menu.showWithView(v: sender, inView: view)
    }
    
    //显示title和图片
    @IBAction func showImageAndTitleMenu(_ sender: UIButton) {
        var config = TMSharpMenuConfig()
        var items: [TMSharpMenuItem] = []
        (0...3).forEach { (i) in
            let item: TMSharpMenuItem = ("icon_account_popup_add", "新建账户\(i)", {
                print("\(i) didClick")
            })
        items.append(item)
        }
        config.itemW = 130
        let menu = TMSharpMenu(items, config)
        menu.showWithView(v: sender, inView: view)
    }
    
    //箭头在下面
    @IBAction func didClick(_ sender: UIButton) {
        let menu = createMenu(type: .down)
        //根据点击按钮显示
        menu.showWithView(v: sender, inView: view)
    }
    
    //根据type创建菜单
    func createMenu(type: TMDirection) -> TMSharpMenu {
        //创建配置（可选）
        var config = TMSharpMenuConfig()
        config.type = type
        var items: [TMSharpMenuItem] = []
        //创建item
        //高亮图片：内部自动在普通图片名后追加 “_h”, 如“icon_account_popup_add_h”
        (0...3).forEach { (i) in
            let item: TMSharpMenuItem = ("icon_account_popup_add", "新建账户\(i)", {
                print("\(i) didClick")
            })
        items.append(item)
        }
        config.itemW = 130
        //创建menu (config 可选)
        let menu = TMSharpMenu(items, config)
        return menu
    }

}

