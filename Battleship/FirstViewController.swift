//
//  FirstViewController.swift
//  Battleship
//
//  Created by Jason Gresh on 9/16/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class FirstViewController: UIViewController {
    
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var shipContainer: UIView!
    
    let numOfShips: Int
    
    let resetTitle = "Reset"
    let engine: battleShipEngine
    var loaded = false
    
    required init?(coder aDecoder: NSCoder) {    //override the initializer
        self.numOfShips = 100
        self.loaded = false
        self.engine = battleShipEngine(numOfShips: self.numOfShips)
        super.init(coder: aDecoder)
    }
        override func viewDidLoad() {
            super.viewDidLoad()
            engine.setupShips()
            setUpLabel()
        }

    override func viewDidLayoutSubviews() {
        if !loaded { //if loaded is false then run
             //setUpShips(v: shipContainer, totalShips: self.numOfShips, shipsPerRow: 10)
            setupBattleFieldGrid(x: 10, by: 10)
            self.view.setNeedsDisplay()
        }
        loaded = true //don't run anything
    }
    
    func setUpLabel() {
        label.text = "Let's play Battleship!"
    }
    
    func handleReset() {
        resetShipColors()
        engine.setupShips()
    }
    
    func disableShips() {
        for v in shipContainer.subviews {
            if let ship = v as? UIButton {
                if ship.currentTitle != resetTitle {
                    ship.isEnabled = false
                }
            }
        }
    }
    
    func resetShipColors() {
        for v in shipContainer.subviews { //grab the view only if it's a button
            if let ship = v as? UIButton {
                if ship.currentTitle != resetTitle {
                    ship.backgroundColor = UIColor.blue
                    ship.isEnabled = true
                }
            }
        }
    }
    
    func setUpResetButton() {
//        let resetRect = CGRect(x: 10, y: 500, width: 60, height: 40)
//        let resetButton = UIButton(frame: resetRect)
        let resetButton = UIButton(type: .system)
        resetButton.translatesAutoresizingMaskIntoConstraints = false
        resetButton.setTitle(resetTitle, for: .normal)
        resetButton.setTitleColor(.white, for: .normal)
        resetButton.backgroundColor = UIColor.blue
        resetButton.addTarget(self, action: #selector(handleReset), for: .touchUpInside)
        view.addSubview(resetButton)
        
        // set the constrain
        resetButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -60).isActive = true
        resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }

    func setupBattleFieldGrid(x: Int, by y: Int) {
        for rowItem  in 0..<x {
            for columnItem in 0..<y {
                addButtonOn(rowItem, column: columnItem)
            }
        }
        setUpLabel()
        setUpResetButton()
    }
    func addButtonOn(_ row: Int, column: Int) {
        let xValue = (column * 35) + 10
        let yValue = (row * 35) + 80
        let frame = CGRect(x: xValue, y: yValue, width: 33, height: 33)
        let gridButton = UIButton(frame: frame)
        let position = "\(row),\(column)"
        gridButton.setTitle(position, for: .normal)
        gridButton.backgroundColor = .blue
        gridButton.addTarget(self, action: #selector(handleGridButton), for: .touchUpInside)
        shipContainer.addSubview(gridButton)
    }
    
    func handleGridButton(_ button: UIButton) {
        selectAllButtons()
        // this is where we check if it's a hit or a miss
        
        // we want to get the title because it contains the position of the gride
        guard let title = button.currentTitle else { return }
        
        let position = convertTitleToTuple(title: title)
        
        // now we have the tuple position... we want to check ur engine class to see if it's a hit or a miss
        if engine.checkShip(position) {
            // it's a HIT
            button.backgroundColor = .green
        } else {
            // it's a miss
            button.backgroundColor = .red
        }
        
    }
    
    func convertTitleToTuple(title: String) -> (Int, Int) {
        // title is a string... we need to convert that into a tuple
        let numbers = title.components(separatedBy: ",")
        let firstNum: Int = Int(numbers[0])!
        let secNum: Int = Int(numbers[1])!
        let position = (firstNum, secNum)
        return position
    }

    func selectAllButtons() {
        let views = shipContainer.subviews
        for view in views {
            if let button = view as? UIButton {
                if button.currentTitle != resetTitle {
                    if let title = button.currentTitle {
                        let position = convertTitleToTuple(title: title)
                        if engine.checkShip(position) {
                            label.text = "GOOD JOB"
                            button.backgroundColor = .green
                            //                        engine.setupShips()
                        }
                        else {
                            label.text = "TRY AGAIN"
                            button.backgroundColor = .red
                        }
                    }
                    
                }
            }
        }
    }
}

