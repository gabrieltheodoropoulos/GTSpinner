//
//  ViewController.swift
//  GTSpinner
//
//  Created by Gabriel Theodoropoulos
//  Copyright © 2018 Gabriel Theodoropoulos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spinnerSample1()
        spinnerSample2()
        spinnerSample3()
        spinnerSample4()
        spinnerSample5()
        spinnerSample6()
        spinnerSample7()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    func spinnerSample1() {
        let spinner = GTSpinner()
        spinner.frame = CGRect(x: view.bounds.midX - spinner.dimension/2, y: 40.0, width: spinner.dimension, height: spinner.dimension)
        spinner.circleColor = UIColor.lightGray
        spinner.spinnerColor = UIColor.darkGray
        spinner.shouldShowTrailColors = false
        spinner.setup()
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    
    func spinnerSample2() {
        let spinner = GTSpinner(withDimension: 120.0)
        spinner.frame = CGRect(x: view.bounds.midX - view.bounds.midX/2 - spinner.dimension/2, y: view.bounds.midY - 230.0, width: spinner.dimension, height: spinner.dimension)
        spinner.trailColors = [UIColor(red: 1.0, green: 0.729, blue: 0.259, alpha: 1.0),
                               UIColor(red: 1.0, green: 0.219, blue: 0.518, alpha: 1.0),
                               UIColor(red: 0.153, green: 0.721, blue: 0.608, alpha: 1.0)]
        spinner.thickness = 14.0
        spinner.shouldAnimateColorChange = false
        spinner.duration = 2.5
        spinner.setup()
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    
    func spinnerSample3() {
        let spinner = GTSpinner(withDimension: 120.0)
        spinner.frame = CGRect(x: view.bounds.midX + view.bounds.midX/2 - spinner.dimension/2, y: view.bounds.midY - 230.0, width: spinner.dimension, height: spinner.dimension)
        spinner.trailColors = [UIColor(red: 1.0, green: 0.729, blue: 0.259, alpha: 1.0),
                               UIColor(red: 1.0, green: 0.219, blue: 0.518, alpha: 1.0),
                               UIColor(red: 0.153, green: 0.721, blue: 0.608, alpha: 1.0)]
        spinner.thickness = 14.0
        spinner.duration = 2.5
        spinner.setup()
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    
    func spinnerSample4() {
        let spinner = GTSpinner(withDimension: 200.0)
        spinner.frame = CGRect(x: view.bounds.midX - spinner.dimension/2, y: view.bounds.midY - spinner.dimension/2, width: spinner.dimension, height: spinner.dimension)
        spinner.trailColors = [UIColor(red: 1.0, green: 0.886, blue: 0.737, alpha: 1.0),
                               UIColor(red: 0.717, green: 0.815, blue: 1.0, alpha: 1.0),
                               UIColor(red: 0.878, green: 0.658, blue: 1.0, alpha: 1.0),
                               UIColor(red: 1.0, green: 0.627, blue: 0.854, alpha: 1.0),
                               UIColor(red: 1.0, green: 0.647, blue: 0.647, alpha: 1.0)]
        spinner.shouldShowSpinner = false
        spinner.thickness = 20.0
        spinner.duration = 4.0
        spinner.setup()
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    
    func spinnerSample5() {
        let spinner = GTSpinner(withDimension: 60.0)
        spinner.frame = CGRect(x: view.bounds.midX - view.bounds.midX/2 - spinner.dimension/2, y: view.bounds.midY + view.bounds.midY/3, width: spinner.dimension, height: spinner.dimension)
        spinner.circleColor = UIColor.clear
        spinner.spinnerColor = UIColor.red
        spinner.shouldShowTrailColors = false
        spinner.setup()
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    
    func spinnerSample6() {
        let spinner = GTSpinner(withDimension: 120.0)
        spinner.frame = CGRect(x: view.bounds.midX + view.bounds.midX/2 - spinner.dimension/2, y: view.bounds.midY + view.bounds.midY/3, width: spinner.dimension, height: spinner.dimension)
        spinner.clockwiseDirection = false
        spinner.shouldUpdateSpinnerColor = false
        spinner.thickness = 1.0
        spinner.setup()
        spinner.startAnimating()
        view.addSubview(spinner)
    }
    
    
    
    func spinnerSample7() {
        let spinner = GTSpinner(withDimension: 64.0)
        spinner.frame = CGRect(x: view.bounds.midX - spinner.dimension/2, y: view.bounds.size.height - 100.0, width: spinner.dimension, height: spinner.dimension)
        spinner.trailColors = [UIColor(red: 0.859, green: 0.741, blue: 0.36, alpha: 1.0),
                               UIColor(red: 0.71, green: 0.76, blue: 0.549, alpha: 1.0)]
        spinner.thickness = 5.0
        spinner.duration = 0.5
        spinner.spinnerColor = UIColor.black
        spinner.clockwiseDirection = false
        spinner.shouldAnimateColorChange = false
        spinner.shouldUpdateSpinnerColor = false
        spinner.setup()
        spinner.startAnimating()
        view.addSubview(spinner)
    }
}

