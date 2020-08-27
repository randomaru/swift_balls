import UIKit

public class Balls: UIView {
        // список цветов для шариков
    private var colors: [UIColor]
        // шарики
    private var balls: [UIView] = []
    private var ballSize: CGSize = CGSize(width: 50, height: 50)
    private var animator: UIDynamicAnimator?
    private var snapBehavior: UISnapBehavior?
    private var collisionBehavior: UICollisionBehavior
    
    public init(colors: [UIColor]) {
          self.colors = colors
          collisionBehavior = UICollisionBehavior(items: [])
              /* указание на то, что границы отображения
              также являются объектами взаимодействия */
          collisionBehavior.setTranslatesReferenceBoundsIntoBoundary(with: UIEdgeInsets(top: 1, left: 1, bottom: 1, right: 1))
          super.init(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
          backgroundColor = UIColor.lightGray
          animator = UIDynamicAnimator(referenceView: self)
          animator?.addBehavior(collisionBehavior)
          ballsView()
      }
      
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location(in: self)
            for ball in balls {
                if (ball.frame.contains(touchLocation)) {
                    snapBehavior = UISnapBehavior(item: ball, snapTo: touchLocation)
                    snapBehavior?.damping = 0.5
                    animator?.addBehavior(snapBehavior!)
                }
            }
        }
    }
    
    override public func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let touchLocation = touch.location( in: self )
            if let snapBehavior = snapBehavior {
                snapBehavior.snapPoint = touchLocation
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let snapBehavior = snapBehavior {
            animator?.removeBehavior(snapBehavior)
            }
        snapBehavior = nil
    }
    
    func ballsView() {
                /* производим перебор переданных цветов
               именно они определяют количество шариков */
           for (index, color) in colors.enumerated() {
                   /* шарик представляет собой
                   экземпляр класса UIView */
               let ball = UIView(frame: CGRect.zero)
                   /* указываем цвет шарика
                   он соответствует переданному цвету */
               ball.backgroundColor = color
                   // накладываем отображение шарика на отображение подложки
               addSubview(ball)
                   // добавляем экземпляр шарика в массив шариков
               balls.append(ball)
                   /* вычисляем отступ шарика по осям X и Y, каждый
                     последующий шарик должен быть правее и ниже
                   предыдущего */
               let origin = 40*index + 100
               // отображение шарика в виде прямоугольника
               ball.frame = CGRect(x: origin, y: origin, width: Int(ballSize.width), height: Int(ballSize.height))
               // с закругленными углами
               ball.layer.cornerRadius = ball.bounds.width / 2.0
               collisionBehavior.addItem(ball)
           }
       }
}
