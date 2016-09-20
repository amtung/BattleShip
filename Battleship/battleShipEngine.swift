//
//  battleShipEngine.swift
//  Battleship
//
//  Created by Annie Tung on 9/17/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class battleShipEngine {

    let numOfShips: Int
    let typeOfShips = [2,3,3,4,5]

    init(numOfShips:Int){
        self.numOfShips = numOfShips
        setupShips()
    }
    
    enum State{
        case hit
        case miss
    }
    
    var ships = [[State]]()
    
    func setupShips(){
        ships.removeAll()
        for _ in 0...9 {
           ships.append(Array(repeating: .miss, count: 10))
        }
        for size in typeOfShips {
            randomShipPlacement(shipSize: size)
        }
    }
    
    func canPlaceShip(position: (Int, Int)) -> Bool {
        var isEmptySpot = false
        if ships[position.0][position.1] == .miss {
            isEmptySpot = true //if it's an empty spot then place ship
        } else {
            isEmptySpot = false
        }
        return isEmptySpot
    }
    
    func randomShipPlacement(shipSize: Int) {
        if isVerticle() {
            
            // verticle ship
            // we need to know which random col that we need to place the ship in
            let col = Int(arc4random_uniform(9))
            var row = Int(arc4random_uniform(9))
            
            // we have to determine if the ship will fit in the grid
            // we also have to check if the spot is taken
//            var spaceAvailable = 0
//            
//            for i in 0..<shipSize {
//                // check every spot in the shipsize grid
//                let position = (row + i, col)
//                if canPlaceShip(position: position) {
//                    spaceAvailable += 1
//                }
//            }
            
            var canFit = (10 - row) > shipSize
            
            while !canFit {
                // when the ship does not fit in the grid
                // we need to pick a new random row
                row = Int(arc4random_uniform(9))
                canFit = (10 - row) > shipSize
            }
            
            // we have enought space to fit our ship
            for i in 0..<shipSize {
                ships[row + i][col] = .hit
            }
        } else {
            // horizontal ship
            // we need to know which random row that we need to place the ship in
            var col = Int(arc4random_uniform(9))
            let row = Int(arc4random_uniform(9))
            // we have to determine if the ship will fit in the gride
            
            var canFit = (10 - col) > shipSize
            
            while !canFit {
                // when the ship does not fit in the gride
                // we need to pick a new random col
                col = Int(arc4random_uniform(9))
                canFit = (10 - col) > shipSize
            }
            // we have enought space to fit our ship
            for i in 0..<shipSize {
                ships[row][col + i] = .hit
            }
        }
        
    }
    
    func isVerticle() -> Bool {
        return arc4random_uniform(2) == 0 ? true: false
    }

    func checkShip(_ position: (Int, Int)) -> Bool {
        return ships[position.0][position.1] == .hit
    }
}
