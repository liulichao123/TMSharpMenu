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

    @IBAction func didClick(_ sender: UIButton) {
        let menu = createMenu(type: .up)
        //根据点击按钮显示
        menu.showWithView(v: sender, inView: view)
    }
   
    @IBAction func didClick2(_ sender: UIButton) {
        let menu = createMenu(type: .down)
        menu.showWithView(v: sender, inView: view)
    }

    @IBAction func rightClick(_ sender: UIBarButtonItem) {
        let menu = createMenu(type: .up)
        //根据某点按钮显示
        menu.showAtPoint(point: CGPoint(x: view.frame.width - 40, y: 54), inView: view)
    }
    @IBAction func leftClick(_ sender: UIBarButtonItem) {
        let menu = createMenu(type: .up)
        menu.showAtPoint(point: CGPoint(x: 40, y: 54), inView: view)
    }
    
    //根据type创建菜单
    func createMenu(type: TMDirection) -> TMSharpMenu {
        //创建配置（可选）
        var config = TMSharpMenuConfig()
        config.type = type
        //创建item
        //高亮图片：内部自动在普通图片名后追加 “_h”, 如“icon_account_popup_add_h”
        let addItem1: TMSharpMenuItem = ("icon_account_popup_add", "新建账户", {
            print("1 didClick")
        })
        let addItem2: TMSharpMenuItem = ("icon_account_popup_add", "新建账户", {
            print("2 didClick")
        })
        let addItem3: TMSharpMenuItem = ("icon_account_popup_add", "新建账户", {
            print("3 didClick")
        })
        let addItem4: TMSharpMenuItem = ("icon_account_popup_add", "新建账户", {
            print("4 didClick")
        })
        //创建menu (config 可选)
        let menu = TMSharpMenu([addItem1, addItem2, addItem3, addItem4], config)
        return menu
    }

}

