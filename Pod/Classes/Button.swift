import UIKit

public protocol ButtonDelegate {
    func hamburgerButtonPressed(button: Button)
}

@IBDesignable
public class Button: UIButton {
    
    //MARK: Defaults
    ///Default line thickness of bars
    static var lineWidth: CGFloat = 2
    ///Default width of bars
    static var size: CGFloat = 15
    ///Default animation spring damping
    static var springDamping: CGFloat = 0.8
    ///Default animation initial spring velocity
    static var springVelocity: CGFloat = 1.0
    ///Default animation duration
    static var duration: TimeInterval = 0.5
    ///Default bar color
    static var color: UIColor = UIColor.black
    
    //MARK: Settings
    ///Line thickness of bars. Cannot be changed once initialized
    public private(set) var lineWidth: CGFloat
    ///Width of bars. Cannot be changed once initialized
    public private(set) var size: CGFloat
    
    ///Animation pring damping.
    public var springDamping: CGFloat = Button.springDamping
    ///Animation initial spring velocity.
    public var springVelocity: CGFloat = Button.springVelocity
    ///Animation duration.
    public var duration: TimeInterval = Button.duration
    ///Bar color.
    public var color: UIColor = Button.color {
        didSet {
            self.barTop.backgroundColor = self.color
            self.barBottom.backgroundColor = self.color
        }
    }
    
    ///Will be notified when the Button is pressed
    public var delegate: ButtonDelegate?
    
    //MARK: Internal
    var isX = false
    var stage: UIView!
    var barTop: UIView!
    var barBottom: UIView!
    
    //MARK: Public
    
    /**
    Toggles the HamburgerButton between Hamburger and X state. Animation is optional.
    
    Configure `springDamping`, `springVelocity`, and `duration` to customize animation.
    */
    public func toggle(animated: Bool) {
        self.isX = !self.isX
        
        if self.isX {
            self.transitionToX(animated: animated)
        } else {
            self.transitionToHamburger(animated: animated)
        }
    }
    
    ///Turns the HamburgerButton to the 'X' state. Animation is optional.
    public func transitionToX(animated: Bool) {
        if animated {
            UIView.animate(withDuration: self.duration, delay: 0, usingSpringWithDamping: self.springDamping, initialSpringVelocity: self.springVelocity, options: [], animations: {
                self.transformToX()
                }, completion: nil)
        } else {
            self.transformToX()
        }
    }
    
    ///Turns the HamburgerButton to the 'Hamburger' state. Animation is optional.
    public func transitionToHamburger(animated: Bool) {
        if animated {
            UIView.animate(withDuration: self.duration, delay: 0, usingSpringWithDamping: self.springDamping, initialSpringVelocity: self.springVelocity, options: [], animations: {
                self.transformToHamburger()
                }, completion: nil)
        } else {
            self.transformToHamburger()
        }
    }
    
    //MARK: Transforms
    func transformToX() {
        self.barTop.transform = CGAffineTransform(rotationAngle: CGFloat(Double.pi / 4)).concatenating(
            CGAffineTransform(translationX: 0, y: self.size / 2 - self.lineWidth / 2)
        )
        
        self.barBottom.transform = CGAffineTransform(rotationAngle: -1.0 * CGFloat(Double.pi / 4)).concatenating(
            CGAffineTransform(translationX: 0, y: -1.0 * (self.size / 2 - self.lineWidth / 2))
        )
    }
    
    func transformToHamburger() {
        self.barTop.transform = CGAffineTransform(translationX: 0, y: 2)
        self.barBottom.transform = CGAffineTransform(translationX: 0, y: -2)
    }
    
    //MARK: Setup
    func initialize() {
        self.stage = UIView()
        
        //prevent from blocking touches
        self.stage.isUserInteractionEnabled = false
        
        //attach to button
        self.stage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(self.stage)
        
        self.stage.addConstraint(
            NSLayoutConstraint(item: self.stage, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.size)
        )
        self.stage.addConstraint(
            NSLayoutConstraint(item: self.stage, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: self.size)
        )
        self.addConstraint(
            NSLayoutConstraint(item: self.stage, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0)
        )
        self.addConstraint(
            NSLayoutConstraint(item: self.stage, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0)
        )
        
        //DEBUG
        //self.stage.layer.borderWidth = 1
        //self.stage.layer.borderColor = UIColor.redColor().CGColor
        
        self.addTarget(self, action: #selector(Button.touchUpInside), for: .touchUpInside)
        
        
        self.barTop = UIView()
        self.barTop.backgroundColor = UIColor.black
        self.attachBar(bar: self.barTop, side: .top)
        
        self.barBottom = UIView()
        self.barBottom.backgroundColor = UIColor.black
        self.attachBar(bar: self.barBottom, side: .bottom)
        
        self.transformToHamburger()
    }
    
    func attachBar(bar: UIView, side: NSLayoutAttribute) {
        self.stage.addSubview(bar)
        bar.translatesAutoresizingMaskIntoConstraints = false
        
        self.stage.addConstraint(
            NSLayoutConstraint(item: self.stage, attribute: side, relatedBy: .equal, toItem: bar, attribute: side, multiplier: 1, constant: 0)
        )
        self.stage.addConstraint(
            NSLayoutConstraint(item: self.stage, attribute: .left, relatedBy: .equal, toItem: bar, attribute: .left, multiplier: 1, constant: 0)
        )
        self.stage.addConstraint(
            NSLayoutConstraint(item: self.stage, attribute: .right, relatedBy: .equal, toItem: bar, attribute: .right, multiplier: 1, constant: 0)
        )
        
        
        bar.addConstraint(
            NSLayoutConstraint(item: bar, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: self.lineWidth)
        )
    }
    
    //MARK: Touch
    @objc func touchUpInside(sender: Button) {
        self.delegate?.hamburgerButtonPressed(button: self)
    }
    
    //MARK: Init
    public convenience init(frame: CGRect, size: CGFloat, lineWidth: CGFloat) {
        self.init(frame: frame)
        
        self.size = size
        self.lineWidth = lineWidth
    }
    
    public override init(frame: CGRect) {
        self.size = Button.size
        self.lineWidth = Button.lineWidth
        
        super.init(frame: frame)
        self.initialize()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.size = Button.size
        self.lineWidth = Button.lineWidth
        
        super.init(coder: aDecoder)
        self.initialize()
    }
    
}
