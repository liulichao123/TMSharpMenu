//
//  TMSharpMenu.swift
//  TMSharpMenu
//
//  Created by 天明 on 2017/3/13.
//  Copyright © 2017年 天明. All rights reserved.
//

import UIKit
import SnapKit

typealias TMSharpMenuItem = (img: String?, title: String?, block: (() -> Void))?

enum TMDirection {
    case up
    case down
}

//MARK: 配置
struct TMSharpMenuConfig {
    
    var type = TMDirection.up                //箭头位置，上/下
    var cornerRadius: CGFloat = 5            //corner
    var bgAlpha: CGFloat = 0.8825            //please set alpha，not set alpha
    var color: UIColor = UIColor(red: 56.0/255.0, green:  56.0/255.0, blue:  56.0/255.0, alpha: 1)
    
    var inset: CGFloat = 14.5               //自身的左右距离superview
    var triangleToBottom: CGFloat = 0       //三角下偏移量
    var minToLeftRight: CGFloat = 4         //三角距左右最小偏移
    var triangleWidth: CGFloat = 10         //三角底边宽度
    var triangleHeight: CGFloat = 4         //三角高度（实际看到的高度可能会因为triangleToBottom 值得存在比设置的小，导致上面有一点空白）
    
    var itemH: CGFloat = 44
    var itemW: CGFloat = 125
    var itemTitleFont: UIFont = UIFont.systemFont(ofSize: 14)
    var itemTitleColor = UIColor.white
    var itemTitleColorH = HEXCOLOR(0xFFB544)
    //item图片、分割线调整见底部 item
    
}

//MARK: TMSharpMenu
class TMSharpMenu: UIView {
    
    private var sharp: TMTriangle!
    private var bottomView: UIView!
    private var imageView: UIImageView!
    private var contentView: UIView!
    private var overView: UIView!
    private var orginFrame: CGRect!
    private var itemButtons = [TMSharpMenuItemButton]()
    private var items = [TMSharpMenuItem]()
    
    var config: TMSharpMenuConfig!
    
    init(_ items: [TMSharpMenuItem], _ config: TMSharpMenuConfig = TMSharpMenuConfig()) {
        self.items = items
        self.config = config
        super.init(frame: CGRect(x: 0, y: 0, width: config.itemW, height: config.itemH * CGFloat(items.count) + config.triangleHeight))
    
        orginFrame = frame
        backgroundColor = UIColor.clear
        
        sharp = TMTriangle(frame: CGRect(x: 0, y: config.triangleToBottom, width: config.triangleWidth, height: config.triangleHeight))
        sharp.backgroundColor = UIColor.clear
        sharp.color = config.color
        sharp.type = config.type
        
        bottomView = UIView()
        bottomView.backgroundColor = config.color
        bottomView.layer.cornerRadius = config.cornerRadius
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.backgroundColor = UIColor.clear
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 1, height: 1))
        
        overView = UIView(frame: UIScreen.main.bounds)
        overView.backgroundColor = UIColor.clear
        let tap = UITapGestureRecognizer(target: self, action: #selector(TMSharpMenu.overViewdidTap))
        overView.addGestureRecognizer(tap)
        
        addSubview(sharp)
        addSubview(bottomView)
        
        //add item
        items.forEach { item in
            if let item = item {
                addItem(image: item.img, title: item.title, block: item.block)
            }
        }
    }

    private override init(frame: CGRect) {super.init(frame: frame)}
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addItem(image: String?, title: String?, block: (() -> Void)?)  {
        itemButtons.forEach { (item) in
            item.showLine = true
        }
        let i = itemButtons.count
        let item = TMSharpMenuItemButton(frame: CGRect(x: 0, y: CGFloat(i) * config.itemH, width: config.itemW, height: config.itemH))
        if let image = image {
            item.setImage(UIImage(named: image), for: .normal)
            //高亮图片可以在normal图片添加一个 _h 后缀
            item.setImage(UIImage(named: "\(image)_h"), for: .highlighted)
        }
        if let title = title {
            item.setTitle(title, for: .normal)
            item.titleLabel?.font = config.itemTitleFont
            item.setTitleColor(config.itemTitleColor, for: .normal)
            item.setTitleColor(config.itemTitleColorH, for: .highlighted)
        }
        if title != nil, image != nil {
            item.type = .both
        }else if title == nil, image != nil {
            item.type = .onlyImage
        }else if title != nil, image == nil {
            item.type = .onlyTitle
        }
        item.block = block
        item.tag = i
        item.showLine = false
        item.menu = self
        itemButtons.append(item)
        contentView.addSubview(item)
    }
    
    func showWithView(v: UIView, inView: UIView) {
        let y = config.type == .up ? v.frame.maxY : v.frame.origin.y
        let point = CGPoint(x: v.frame.origin.x + v.frame.width * 0.5, y: y)
        showAtPoint(point: point, inView: inView)
    }
    
    func showAtPoint(point: CGPoint, inView: UIView) {
        //middle
        center.x = point.x
        if config.type == .down {
            center.y = point.y - frame.height * 0.5
        }else {
            center.y = point.y + frame.height * 0.5
        }
        var cha = point.x - center.x
        sharp.frame.origin.x = frame.width * 0.5 + cha - sharp.frame.width * 0.5
        sharp.frame.origin.y = 0
        //left
        if point.x < frame.width * 0.5 {
            frame.origin.x = config.inset
            cha = center.x - point.x
            sharp.frame.origin.x = frame.width * 0.5 - cha - sharp.frame.width * 0.5
        }
        //right
        if (inView.frame.width - point.x) < frame.width * 0.5 {
            frame.origin.x = inView.frame.width - frame.width - config.inset
            cha =  point.x - center.x
            sharp.frame.origin.x = frame.width * 0.5 + cha - sharp.frame.width * 0.5
        }
//        debuge
//        sharp.backgroundColor = UIColor.gray
//        backgroundColor = UIColor.white
        //三角下偏移量 y
        sharp.frame.origin.y = config.triangleToBottom
        //三角左右偏移 x
        if sharp.frame.origin.x < config.minToLeftRight {
            sharp.frame.origin.x = config.minToLeftRight
        }else if sharp.frame.origin.x > frame.width - sharp.frame.width - config.minToLeftRight {
            sharp.frame.origin.x = frame.width - sharp.frame.width - config.minToLeftRight
        }
        
        //type : down
        if config.type == .down {
            bottomView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - sharp.frame.height)
            sharp.frame.origin.y = bottomView.frame.maxY - config.triangleToBottom
        }else if config.type == .up {
            bottomView.frame = CGRect(x: 0, y: sharp.frame.height, width: frame.width, height: frame.height - sharp.frame.height)
        }
        if config.type == .down {
            sharp.frame.origin.y = bottomView.frame.maxY - config.triangleToBottom
        }
        guard let window = UIApplication.shared.keyWindow  else {
            return
        }
        window.addSubview(overView)
        frame.origin = inView.convert(frame.origin, to: window)
        window.addSubview(self)
        
        //imageView替换
        imageView.image = createImage()
        subviews.forEach { (v) in
            v.removeFromSuperview()
        }
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.margins.equalToSuperview()
        }
        contentView.frame = bottomView.frame
        addSubview(contentView)//必须最后添加
        
        alpha = 0
        UIImageView.animate(withDuration: 0.1, animations: {
            self.alpha = self.config.bgAlpha
        })
    }
    
    func dismiss() {
        let sx = sharp.frame.origin.x + sharp.frame.width * 0.5
        let sy = sharp.frame.origin.y
        let toFrame = CGRect(x: sx, y: sy, width: 1, height: 1)
        imageView.image = createImage()
        contentView.isHidden = true
        UIView.animate(withDuration: 0.1, animations: {
            self.imageView.frame = toFrame
        }) { (comp) in
            if comp {
                self.removeFromSuperview()
                self.overView.removeFromSuperview()
            }
        }
    }
    
    @objc private func overViewdidTap() {
        dismiss()
    }
    
    private func createImage() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(frame.size, false, UIScreen.main.scale)
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return nil
        }
        layer.render(in: ctx)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
}
//MARK: TMTriangle 三角尖
fileprivate class TMTriangle: UIView {
    
    var type = TMDirection.up
    var color = UIColor.black
    
    override func draw(_ rect: CGRect) {
        guard let ctx = UIGraphicsGetCurrentContext() else {
            return
        }
        ctx.setFillColor(color.cgColor)
        if type == .up {
            ctx.move(to: CGPoint(x: 0, y: rect.height))
            ctx.addLine(to: CGPoint(x: rect.width, y: rect.height))
            ctx.addLine(to: CGPoint(x: rect.width * 0.5, y: 0))
        }else {
            ctx.move(to: CGPoint(x: 0, y: 0))
            ctx.addLine(to: CGPoint(x: rect.width, y: 0))
            ctx.addLine(to: CGPoint(x: rect.width * 0.5, y: rect.height))
        }
        ctx.fillPath()
    }
}

enum TMSharpMenuItemButtonType {
    case onlyTitle
    case onlyImage
    case both
}

//MARK: item 按钮
fileprivate class TMSharpMenuItemButton: UIButton {
    weak var menu: TMSharpMenu? = nil
    let line: UIView
    let imageHW: CGFloat = 25           //image宽高
    let leftInset: CGFloat = 15         //image距左
    let imageToTitle: CGFloat = 14      //title距image间距
    var lineLeftMargin: CGFloat = 10     //分割线调整
    var lineRightMargin: CGFloat = 10
    var type = TMSharpMenuItemButtonType.both
    
    var showLine = true {
        didSet{
            line.isHidden = !showLine
        }
    }
    var block: (() -> Void)? {
        didSet {
            addTarget(self, action: #selector(TMSharpMenuItemButton.didClick(item:)), for: .touchUpInside)
        }
    }
    
    override init(frame: CGRect) {
        line = UIView(frame: CGRect(x: lineLeftMargin, y: frame.size.height - 0.5, width: frame.width - lineLeftMargin - lineRightMargin, height: 1))
        super.init(frame: frame)
        let rgb: CGFloat = 48
        line.backgroundColor = UIColor(red: rgb/255.0, green: rgb/255.0, blue: rgb/255.0, alpha: 1)
        addSubview(line)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func didClick(item: TMSharpMenuItemButton) {
        menu?.dismiss()
        block?()
    }
    
    // stp1
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        switch type {
        case .onlyTitle:
            return CGRect()
        case .onlyImage:
            return super.imageRect(forContentRect: contentRect)
        default:
            return CGRect(x: leftInset, y: (frame.height - imageHW) * 0.5, width: imageHW, height: imageHW)
        }
    }
    
    // stp2
    override func titleRect(forContentRect contentRect: CGRect) -> CGRect {
        switch type {
        case .onlyTitle:
            return super.titleRect(forContentRect: contentRect)
        case .onlyImage:
            return CGRect()
        default:
            return CGRect(x: leftInset + imageHW + imageToTitle, y: (frame.height - imageHW) * 0.5, width: frame.width - leftInset - imageHW - imageToTitle, height: imageHW)
        }
    }
}
/**
 实现思路：
    1、背景是由两个View组成，上面三角和下面的矩形View
    2、其中，三角view内部实现是绘图，
    3、根据传入point，计算self应该所处的位置，在计算三角应该所处的位置
    4、根据当前context 绘图image
    5、self中添加imageView，并移除其他子view，
    6、添加contentView(里面包含了按钮)
    7、动画：
        改变imageView的大小，动画完成时，再将contentView显示出来
        消失时，获取当前context绘图image，隐藏contentView，改变imageView大小，动画完成移除self
    
    遇到问题：
    1、本来想直接控制self大小实现动画，但是由于里面是由多个子View组成，动画不统一，所以改用imageView实现
    2、直接Graphics绘制整体的背景时，填充圆角不好控制，所以改用两个view组合
    3、缩放动画，通过将imageView移动到箭头顶点的位置，同时设置大小为1X1像素，逐渐回归原位

 **/

