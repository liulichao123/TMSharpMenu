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
        // Do any additional setup after loading the view, typically from a nib.
    }

    @IBAction func didClick(_ sender: UIButton) {
        let menu = createMenu(type: .up)
        menu.showWithView(v: sender, inView: view)

    }
   
    @IBAction func didClick2(_ sender: UIButton) {
        let menu = createMenu(type: .down)
        menu.showWithView(v: sender, inView: view)
    }

    @IBAction func rightClick(_ sender: UIBarButtonItem) {
        let menu = createMenu(type: .up)
        menu.showAtPoint(point: CGPoint(x: view.frame.width - 40, y: 54), inView: view)
    }
    @IBAction func leftClick(_ sender: UIBarButtonItem) {
        let menu = createMenu(type: .up)
        menu.showAtPoint(point: CGPoint(x: 40, y: 54), inView: view)
    }
    
    func createMenu(type: TMDirection) -> TMSharpMenu {
        var config = TMSharpMenuConfig()
        config.type = type
        
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
        let menu = TMSharpMenu([addItem1, addItem2, addItem3, addItem4], config)
        return menu
    }

}

