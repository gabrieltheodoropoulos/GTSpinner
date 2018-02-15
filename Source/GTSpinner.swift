//
//  GTSpinner.swift
//  GTSpinner
//
//  Created by Gabriel Theodoropoulos
//  Copyright © 2018 Gabriel Theodoropoulos. All rights reserved.
//

import UIKit

class GTSpinner: UIView {

    // MARK: Properties
    
    /// It specifies the shape of the circular layer and the path of the animation.
    private var path: UIBezierPath!
    
    /// The circular base layer.
    private var circleLayer: CAShapeLayer!
    
    /// A layer that shows and animates a trail color.
    ///
    /// It's used in conjuction to the trailLayer2, so when one trail color has finished animating, the other layer starts animating the next color.
    private var trailLayer1: CAShapeLayer!
    
    /// A layer that shows and animates a trail color.
    ///
    /// It's used in conjuction to the trailLayer1, so when one trail color has finished animating, the other layer starts animating the next color appearance.
    private var trailLayer2: CAShapeLayer!
    
    /// The layer that draws the spinner.
    private var spinnerLayer: CAShapeLayer!
    
    /// A flag that controls which layer should show the next trail color animated. When `true` the `trailLayer1` layer is the one animating, otherwise it's the `trailLayer2`.
    private var isAnimatingFirstTrailLayer = true
    
    /// The animation object matching to the trail color animation in `trailLayer1`.
    private var trail1Animation: CABasicAnimation!
    
    /// The animation object matching to the trail color animation in `trailLayer2`.
    private var trail2Animation: CABasicAnimation!
    
    /// The animation object matching to the spinning animation of the `spinnerLayer`.
    private var spinnerAnimation: CAKeyframeAnimation!
    
    /// The index of the current trail color in the `trailColors` array.
    private var currentColorIndex: Int = 0
    
    
    
    /// The dimension of the spinner. This value will apply to both width and height. Default value is 40px.
    var dimension: CGFloat!
    
    /// When `true` the animation has a clockwise direction. Default value is `true`.
    var clockwiseDirection = true
    
    /// An array of `UIColor` objects that represent the trail colors that appear in the spinning animation.
    ///
    /// Each color is shown for the entire duration of the animation cycle before the next one gets into the play.
    /// When there are no more avaialble colors and the last color of the array has been reached, the order starts again from the first color specified in the array.
    var trailColors = [UIColor.darkGray, UIColor.lightGray] //[UIColor.red, UIColor.green, UIColor.blue, UIColor.magenta, UIColor.cyan, UIColor.brown, UIColor.orange]
    
    /// The width of the circle's line. Default value is 3.0.
    var thickness: CGFloat = 3.0
    
    /// The duration of the animation until a full rotation of the spinner or the trail colors is completed. Default value is 1.0 second.
    var duration: Double = 1.0
    
    /// The default color of the circular base of the spinner. Useful when no trail colors are used.
    var circleColor = UIColor.clear
    
    /// The default color of the spinner that is moving on the circle.
    var spinnerColor = UIColor.darkGray
    
    /// When `true`, the trail colors specified in the `trailColors` array are visible in the spinning animation and appear right after the spinner, otherwise there's just the spinner moving on the circle's path (if enabled).
    var shouldShowTrailColors = true
    
    /// When `true`, there's interpolation when one color succeeds another. Default value is `true`.
    var shouldAnimateColorChange = true
    
    /// When `true` the spinner is visible. Default value is `true`.
    ///
    /// **Note**: In case the `thickness` property is greater than the 1/5 of the `dimension`, the spinner is not appearing at all. Default value is `true`.
    var shouldShowSpinner = true
    
    /// When `true`, the spinner's color is updated according to the currently visible trail color. Default value is `true`.
    var shouldUpdateSpinnerColor = true
    
    
    
    // MARK: Initialization
    
    /// It initializes the spinner view.
    ///
    /// - Parameter dimension: The dimension of the spinner view. If not provided, the default value that is used is 40px.
    init(withDimension dimension: CGFloat = 40.0) {
        super.init(frame: CGRect.zero)
        
        self.dimension = dimension
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    
    // MARK: Custom Methods
    
    /// It performs all the necessary configuration to the view and the layers that will be used in the animation.
    ///
    /// It should be called after all properties have been set with custom values, but before calling the `startAnimating()` method.
    func setup() {
        // Make the current view transparent.
        self.backgroundColor = UIColor.clear
        
        // If both the shouldUpdateSpinnerColor and shouldShowTrailColors properties are true, then set the first trail color as the spinner's color as well.
        if shouldUpdateSpinnerColor && shouldShowTrailColors && trailColors.count > 0 {
            spinnerColor = trailColors[0]
        }
        
        // Specify the padding of the circle layer from the edges of the view.
        // This padding is necessary so there's room for the spinner layer that will move around the circle layer.
        // This is set to the 1/10 of the dimension property. So, if the dimension is 40px, the padding is 4px.
        let padding: CGFloat = dimension/10
        
        // Create a UIEdgeInsets object applying the padding to all sides.
        let insets = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
        
        // Create a new frame by applying the insets to the bounds of the view.
        let frameWithPadding = UIEdgeInsetsInsetRect(bounds, insets)
        
        // Create the bezier path of the circular layer.
        // Specify the start and end angle of the path, depending on whether the animation direction should be clockwise counter-clockwise.
        let startAngle: CGFloat = CGFloat(-90).toRadians()
        let endAngle: CGFloat = (clockwiseDirection) ? CGFloat(270).toRadians() : CGFloat(-450).toRadians()
        path = UIBezierPath(arcCenter: CGPoint(x: frameWithPadding.midX, y: frameWithPadding.midY),
                            radius: (frameWithPadding.size.width)/2,
                            startAngle: startAngle,
                            endAngle: endAngle,
                            clockwise: clockwiseDirection)
        
        // Create the circular layer.
        circleLayer = CAShapeLayer()
        // Set the path that was created just right above.
        circleLayer.path = self.path.cgPath
        // No fill color.
        circleLayer.fillColor = UIColor.clear.cgColor
        // Set the circleColor property as the stroke color of the layer.
        circleLayer.strokeColor = circleColor.cgColor
        // Set the thickness property's value as the line width of the layer.
        circleLayer.lineWidth = thickness
        
        // Add it as a sublayer to the default layer of the view.
        self.layer.addSublayer(circleLayer)
        
        
        // Check if trail colors should be shown in the animation.
        // In that case initialize and configure the trail layers.
        if shouldShowTrailColors {
            // Initialize the first trail layer (trailLayer1 property).
            trailLayer1 = CAShapeLayer()
            // No fill color.
            trailLayer1.fillColor = UIColor.clear.cgColor
            // Set the first color of the trailColors array as the stroke color.
            trailLayer1.strokeColor = self.trailColors[self.currentColorIndex].cgColor
            // Set the strokeEnd value to 0. That means that by default the layer won't be visible (this value will change later).
            trailLayer1.strokeEnd = 0.0
            // Set the circular path as the path of the layer.
            trailLayer1.path = path.cgPath
            // Set the thickness property's value as the line width.
            trailLayer1.lineWidth = thickness
            // Add it to the main layer of the view.
            self.layer.addSublayer(trailLayer1)
            
            // Configure the trailLayer2 layer exactly as the previous one.
            trailLayer2 = CAShapeLayer()
            trailLayer2.fillColor = UIColor.clear.cgColor
            trailLayer2.strokeColor = self.trailColors[self.currentColorIndex].cgColor
            trailLayer2.strokeEnd = 0.0
            trailLayer2.path = path.cgPath
            trailLayer2.lineWidth = thickness
            self.layer.addSublayer(trailLayer2)
        }
        
        
        // Check if the spinner should be shown or not.
        if shouldShowSpinner {
            // Make sure that the thickness is not greater than the 1/5 of the dimension (padding = dimension/10).
            if thickness < 2.0 * padding {
                // Specify the shape of the spinner by creating a new bezier path.
                let spinnerShape = UIBezierPath(ovalIn: CGRect(x: -padding, y: -padding, width: 2.0 * padding, height: 2.0 * padding))
                
                // Initialize the spinnerLayer property.
                spinnerLayer = CAShapeLayer()
                // Set its path.
                spinnerLayer.path = spinnerShape.cgPath
                // Set the spinnerColor property's value as the fill color.
                spinnerLayer.fillColor = spinnerColor.cgColor
                // No stroke color.
                spinnerLayer.strokeColor = UIColor.clear.cgColor
                // Set a higher value comparing to the other layers for the layer's position to the z-axis.
                // This way, the spinner will always be in front of any other layer.
                spinnerLayer.zPosition = 2.0
                // Add it to the view's layer.
                self.layer.addSublayer(spinnerLayer)
            }
            else {
                // If the thickness is not less than the 1/5 of the dimension property, then set the shouldShowSpinner property to false and prevent the spinner layer from showing up.
                shouldShowSpinner = false
            }
        }
        
        
        // Call the following method to initialize the spinner and trail colors animations.
        self.setupAnimations()
    }
    
    
    /// It initializes and configures all the animation objects required for the final result, depending always on the given preferences.
    ///
    /// If the `shouldShowSpinner` flag is true, then the `spinnerAnimation` object is initialized and configured to animate the spinner movement around the circle.
    ///
    /// Respectively, if the `shouldShowTrailColors` is true, then the `trail1Animation` and `trail2Animation` objects are initialized and configured to animate the trail colors.
    ///
    /// This method is called by the `setup()` method, after the initial configuration has taken place.
    private func setupAnimations() {
        // Configure the spinnerAnimation property if only the spinner should be visible.
        if shouldShowSpinner {
            // Initialize a CAKeyframeAnimation animation and pass the "position" as the keypath value.
            spinnerAnimation = CAKeyframeAnimation(keyPath: "position")
            
            // The path of the animation is the path of the circleLayer.
            spinnerAnimation.path = path.cgPath
            
            // Use the kCAAnimationPaced as the calculation mode value.
            spinnerAnimation.calculationMode = kCAAnimationPaced
            
            // Repeat forever.
            spinnerAnimation.repeatCount = .infinity
            
            // Set the duration property's value as the basic duration of the animation.
            spinnerAnimation.duration = duration
        }
        
        
        // Configure the trail1Animation and trail2Animation properties if only the trail colors should be shown.
        if shouldShowTrailColors {
            // Create a new CABasicAnimation for the "strokeEnd" property of the trailLayer1 layer.
            trail1Animation = CABasicAnimation(keyPath: "strokeEnd")
            
            // Animate the layer by changing the strokeEnd property from 0 to 1.
            trail1Animation.fromValue = 0.0
            trail1Animation.toValue = 1.0
            
            // Don't repeat the animation automatically, it'll be fired again and again once it stops.
            // That's important because certain actions should be taken when the animation stops.
            // See the animationDidStop(_: CAAnimation, finished: Bool) for more details.
            trail1Animation.repeatCount = 1
            
            // Set the basic duration of the animation.
            trail1Animation.duration = duration
            
            // Let the animation stay visible once it's finished and until further actions are taken.
            trail1Animation.fillMode = kCAFillModeForwards
            trail1Animation.isRemovedOnCompletion = false
            
            // Set self as the delegate of the animation.
            // Important for knowing when the animation stops.
            trail1Animation.delegate = self
            
            
            // Configure the trail2Animation exactly as the previous one.
            trail2Animation = CABasicAnimation(keyPath: "strokeEnd")
            trail2Animation.fromValue = 0.0
            trail2Animation.toValue = 1.0
            trail2Animation.repeatCount = 1
            trail2Animation.duration = self.duration
            trail2Animation.fillMode = kCAFillModeForwards
            trail2Animation.isRemovedOnCompletion = false
            trail2Animation.delegate = self
        }
    }
    
    
    
    /// It starts animating the spinner and the trail colors, depending always on the user's preferences.
    func startAnimating() {
        // If the spinner should be visible, then add the spinnerAnimation to the spinnerLayer and let the spinner animate around the circle layer.
        if shouldShowSpinner {
            spinnerLayer.add(spinnerAnimation, forKey: "spinnerAnimation")
        }
        
        // Animate the trail colors if only the shouldShowTrailColors is true.
        if self.shouldShowTrailColors {
            // If the isAnimatingFirstTrailLayer is true, then add the trail1Animation to the trailLayer1 (animate the trailLayer1 layer).
            // Otherwise, animate the trailLayer2.
            if self.isAnimatingFirstTrailLayer {
                self.trailLayer1.add(self.trail1Animation, forKey: "trail1Animation")
            }
            else {
                self.trailLayer2.add(self.trail2Animation, forKey: "trail2Animation")
            }
        }
    }
    
    
    
    
    /// It animates the change to the stroke color of the layer that is animating the current trail color (if visible), and the fill color of the spinner layer (if visible).
    private func animateColorChange() {
        // Check if the trail colors should be shown or not.
        if self.shouldShowTrailColors {
            // Specify the color transition duration.
            // By default, the 1/4 of the spinning animation duration is set as the color change animation duration.
            let animDuration = duration/4
            
            // Creating a new CABasicAnimation object passing the "strokeColor" as the layer's property that should be animated.
            let colorChangeAnimation = CABasicAnimation(keyPath: "strokeColor")
            // Set the "toValue" to the final color, which is the current trail color.
            colorChangeAnimation.toValue = self.trailColors[self.currentColorIndex].cgColor
            // Set the animation duration.
            colorChangeAnimation.duration = animDuration
            // Make sure that the animation won't be removed immediately after the animation is finished.
            colorChangeAnimation.isRemovedOnCompletion = false
            colorChangeAnimation.fillMode = kCAFillModeForwards
            
            // Check which layer should be used to animate the current trail color and:
            // - Add the animation object to the respective layer (trailLayer1 or trailLayer2).
            // - Perform the following after some delay that equals to the animation duration:
            //      * Remove the animation from the respective layer.
            //      * Set the current trail color as the stroke color of the respective layer.
            if self.isAnimatingFirstTrailLayer {
                self.trailLayer1.add(colorChangeAnimation, forKey: "colorChangeAnimation")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + animDuration, execute: {
                    self.trailLayer1.removeAnimation(forKey: "colorChangeAnimation")
                    self.trailLayer1.strokeColor = self.trailColors[self.currentColorIndex].cgColor
                })
            }
            else {
                self.trailLayer2.add(colorChangeAnimation, forKey: "colorChangeAnimation")
                
                DispatchQueue.main.asyncAfter(deadline: .now() + animDuration, execute: {
                    self.trailLayer2.removeAnimation(forKey: "colorChangeAnimation")
                    self.trailLayer2.strokeColor = self.trailColors[self.currentColorIndex].cgColor
                })
            }
            
            
            // Check if the spinner layer is visible or not, and if its color should be updated according to the trail color.
            if shouldShowSpinner && shouldUpdateSpinnerColor {
                // If so, create a new CABasicAnimation object and pass the "fillColor" as the property that should be animated.
                let spinnerColorChangeAnimation = CABasicAnimation(keyPath: "fillColor")
                // Set the current trail color as the final color.
                spinnerColorChangeAnimation.toValue = self.trailColors[self.currentColorIndex].cgColor
                // Set the animation duration.
                spinnerColorChangeAnimation.duration = animDuration
                // Make sure that the animation won't be removed once its finished.
                spinnerColorChangeAnimation.isRemovedOnCompletion = false
                spinnerColorChangeAnimation.fillMode = kCAFillModeForwards
                
                // Add the animation to the spinnerLayer layer.
                spinnerLayer.add(spinnerColorChangeAnimation, forKey: "spinnerColorChangeAnimation")
                
                // After some delay that equals to the animation duration:
                // - Remove the animation from the spinnerLayer layer.
                // - Set the current trail color as the fill color to the spinnerLayer layer.
                DispatchQueue.main.asyncAfter(deadline: .now() + animDuration, execute: {
                    self.spinnerLayer.removeAnimation(forKey: "spinnerColorChangeAnimation")
                    self.spinnerLayer.fillColor = self.trailColors[self.currentColorIndex].cgColor
                })
            }
        }
    }
    
}



extension GTSpinner: CAAnimationDelegate {
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        // Perform all the required actions when any of the trail color animations is finished.
        
        // Check if the animation that was just finished regards the trail1Animation or the trail2Animation object and:
        // - Apply the current trail color as the stroke color to the respective layer (trailLayer1 or trailLayer2).
        // - Remove all animations from the respective layer.
        // - Set value 1 to the strokeEnd property of the respective trailer.
        //
        // By doing the above the animated color will remain visible after the animation is finished and removed from its layer.
        if self.isAnimatingFirstTrailLayer {
            trailLayer2.strokeColor = trailColors[currentColorIndex].cgColor
            trailLayer1.removeAllAnimations()
            trailLayer1.strokeEnd = 1.0
        }
        else {
            trailLayer1.strokeColor = trailColors[currentColorIndex].cgColor
            trailLayer2.removeAllAnimations()
            trailLayer2.strokeEnd = 1.0
        }
        
        // If the spinner layer is visible, then remove its animation too.
        if shouldShowSpinner {
            spinnerLayer.removeAnimation(forKey: "spinnerAnimation")
        }
        
        
        // Update the index of the current color and point to the next one in the trailColors array.
        // If there isn't next color, point to the first color of the array.
        currentColorIndex = (currentColorIndex < trailColors.count - 1) ? currentColorIndex + 1 : 0
        
        // Invert the value of the isAnimatingFirstTrailLayer flag to show which layer should be animated next.
        isAnimatingFirstTrailLayer = !isAnimatingFirstTrailLayer
        
        // Depending on the layer that should be animated, update the position in the z-axis and bring it to front, so it can overlap the layer that was just finished animating.
        // The top-most layer gets the value 1 (zPosition property), the other that should stay in the back gets the value 0.
        // Note: Remember that the spinner layer has a zPosition value of 2.0, meaning that it's on top of any other layer.
        if isAnimatingFirstTrailLayer {
            trailLayer1.zPosition = 1.0
            trailLayer2.zPosition = 0.0
        }
        else {
            trailLayer1.zPosition = 0.0
            trailLayer2.zPosition = 1.0
        }
        
        
        // Check if the trail colors should be changed in an animated way or not.
        if self.shouldAnimateColorChange {
            // If so, call the animateColorChange() method to perform the color change animation.
            animateColorChange()
        }
        else {
            // If not, check which layer is going to be animated and set the current trail color as its stroke color directly.
            if isAnimatingFirstTrailLayer {
                trailLayer1.strokeColor = trailColors[currentColorIndex].cgColor
            }   else {
                trailLayer2.strokeColor = trailColors[currentColorIndex].cgColor
            }
            
            
            // If the spinner color should be updated according to the current trail color, then set its fill color.
            if shouldUpdateSpinnerColor {
                spinnerLayer.fillColor = trailColors[currentColorIndex].cgColor
            }
            
        }
        
        // Call the startAnimating() method to fire the animations of the spinner and the trail color again.
        self.startAnimating()
    }
}



extension CGFloat {
    func toRadians() -> CGFloat {
        return self * CGFloat(Double.pi) / 180.0
    }
}
