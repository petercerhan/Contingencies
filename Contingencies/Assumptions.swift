//
//  File.swift
//  Contingencies
//
//  Created by Peter Cerhan on 6/25/16.
//  Copyright © 2016 Peter Cerhan. All rights reserved.
//

import Foundation

class Assumptions {
    //MARK: Properties
    
    var type: Contingency
    var mortalityTable = MortalityTableReference().ppa_2016_blended
    var interest: Double
    var term: Int?
    var deferralPeriod: Int?
    
    // MARK: Initialization
    
    init(type: Contingency, interest: Double, term: Int?, deferralPeriod: Int?) {
        
        self.type = type
        self.interest = interest
        self.term = term
        self.deferralPeriod = deferralPeriod
    }
    
    init() {
        self.type = .LifeAnnuityImmediate
        self.interest = 4.0
        self.mortalityTable = MortalityTableReference().ppa_2016_blended
    }
}