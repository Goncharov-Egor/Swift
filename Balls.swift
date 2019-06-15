import UIKit

public class Balls: UIView {
    private var colors: [UIColor]
    private var balls: [UIView] = []
    private var collisionBehavior: UICollisionBehavior
    public init(colors: [UIColor]) {
        self.colors = colors
        collisionBehavior = UICollisionBehavior(items: [])
        collisionBehavior.setTranslatesReferenceBoundsIntoBoundary( with: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0))
        super.init(frame: CGRect(x: 0, y: 0, width: 300, height: 400))
        backgroundColor = UIColor.gray
        animator = UIDynamicAnimator(referenceView: self)
        animator?.addBehavior(collisionBehavior)
        ballsView()
        //undefineBehavior()
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private var ballSize: CGSize = CGSize(width: 40, height: 40)
    func ballsView() {
        for (index, color) in colors.enumerated() {
            let ball = UIView(frame: CGRect.zero)
            ball.backgroundColor = color
            addSubview(ball)
            balls.append(ball)
            ball.frame = CGRect(x: 70*index + 70, y: 70*index + 70,
            width: Int(ballSize.width), height: Int(ballSize.height))
            ball.layer.cornerRadius = ball.bounds.width / 2.0
            collisionBehavior.addItem(ball)
           // undefineBehavior()
        }
    }
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //undefineBehavior()
        if let touch = touches.first {
            let touchLocation = touch.location( in: self )
            for ball in balls {
                if (ball.frame.contains(touchLocation)) {
                    snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
                    snapBehavior?.damping = 0.5
                    animator?.addBehavior(snapBehavior!)
                }
            }
        }
    }
    /*public func undefineBehavior() {
        for _ in 0...10 {
            for ball in balls {
                let touchLocation = CGPoint(x: 100 + Int(arc4random_uniform(40)), y:        100 + Int(arc4random_uniform(40)))
                snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
                animator?.addBehavior(snapBehavior!)
                snapBehavior?.snapPoint = touchLocation
            }
        }
        //undefineBehavior()
    }*/
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location( in: self )
            if let snapBehavior = snapBehavior {
                snapBehavior.snapPoint = touchLocation
            }
        }
    }
    override public func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let snapBehavior = snapBehavior {
            animator?.removeBehavior(snapBehavior)
        }
        snapBehavior = nil
    }
}
