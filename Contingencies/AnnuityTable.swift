//
//  AnnuityCalculator.swift
//  Contingencies
//
//  Created by Peter Cerhan on 6/11/16.
//  Copyright © 2016 Peter Cerhan. All rights reserved.
//

import Foundation

class AnnuityTable {
    //MARK: Properties
    
    var mortalityTable = MortalityTableReference().ppa_2016_blended {
        didSet {
            recalculate()
        }
    }
    var i: Double = 0.04 {
        didSet {
            recalculate()
        }
    }
    var n: Int = 20 {
        didSet {
            recalculate()
        }
    }

    var l_x: [Double] = []
    var d_x: [Double] = []
    var v_x: [Double] = []
    var commutation_D_x: [Double] = []
    var commutation_N_x: [Double] = []
    var commutation_C_x: [Double] = []
    var commutation_M_x: [Double] = []
    
    var max_Age = 0

    //MARK: Initialization
    
    init() {
        recalculate()
    }
    
    init(interest: Double, mortalityTable: [Double], termOrDeferral: Int?) {
        self.i = interest
        self.mortalityTable = mortalityTable
        if let termOrDeferral = termOrDeferral {
            self.n = termOrDeferral
        }
        
        recalculate()
    }
    
    //MARK: Recalculate Table
    
    private func recalculate() {
        //order of recalculation important as each array builds on the previous arrays
        l_x = recalculate_l_x()
        d_x = recalculate_d_x()
        v_x = recalculate_v_x()
        commutation_D_x = recalculate_commutation_D_x()
        commutation_N_x = recalculate_commutation_N_x()
        commutation_C_x = recalculate_commutation_C_x()
        commutation_M_x = recalculate_commutation_M_x()
        
        max_Age = l_x.count - 1
    }
    
    private func recalculate_l_x() -> [Double] {
        var output = [Double]()
        for (index, q_x) in mortalityTable.enumerate() {
            if index == 0 {
                output.append(10000000)
                continue
            }
            output.append((1 - q_x) * output[index - 1])
        }
        return output
    }
    
    private func recalculate_d_x() -> [Double] {
        return l_x.enumerate().map {
            (index, l_x_value) in
            if index == l_x.count - 1 {
                return 0
            }
            return l_x_value - l_x[index + 1]
        }
    }
    
    private func recalculate_v_x() -> [Double] {
        return mortalityTable.enumerate().map { (index, value) in return pow((1 + i), Double(-index)) }
    }
    
    private func recalculate_commutation_D_x() -> [Double] {
        return l_x.enumerate().map { (index, l_x_value) in return l_x_value * v_x[index] }
    }
    
    private func recalculate_commutation_N_x() -> [Double] {
        var output = [Double]()
        for (index, _) in commutation_D_x.enumerate() {
            if index == 0 {
                output.append(commutation_D_x.reduce(0, combine: +))
                continue
            }
            output.append(output[index - 1] - commutation_D_x[index - 1])
        }
        return output
    }
    private func recalculate_commutation_C_x() -> [Double] {
        return d_x.enumerate().map {
            (index, d_x_value) in
            if index == d_x.count - 1 {
                return 0
            }
            return d_x_value * v_x[index + 1]
        }
    }
    
    private func recalculate_commutation_M_x() -> [Double] {
        var output = [Double]()
        for (index, _) in commutation_C_x.enumerate() {
            if index == 0 {
                output.append(commutation_C_x.reduce(0, combine: +))
                continue
            }
            output.append(output[index - 1] - commutation_C_x[index - 1])
        }
        return output
    }
}

//MARK: Annuities

extension AnnuityTable {
    var annuity_life_immediate: [Double] {
        return commutation_D_x.enumerate().map() {
            (index, value_D_x) in
            if index == commutation_D_x.count - 1 {
                return 0
            }
            return commutation_N_x[index + 1] / value_D_x
        }
    }
    
    var annuity_life_due: [Double] {
        return commutation_D_x.enumerate().map() {
            (index, value_D_x) in
            if index == commutation_D_x.count - 1 {
                return 0
            }
            return commutation_N_x[index + 1] / value_D_x + 1
        }
    }
    
    var annuity_temporary_immediate: [Double] {
        return commutation_D_x.enumerate().map() {
            (index, value_D_x) in
            if index == commutation_D_x.count - 1 {
                return 0
            }
            return (commutation_N_x[index + 1] - commutation_N_x[min(commutation_N_x.count - 1, index + n + 1)]) / value_D_x
        }
    }
    
    var annuity_temporary_due: [Double] {
        return commutation_D_x.enumerate().map() {
            (index, value_D_x) in
            if index == commutation_D_x.count - 1 {
                return 0
            }
            return (commutation_N_x[index] - commutation_N_x[min(commutation_N_x.count - 1, index + n)]) / value_D_x
        }
    }
    
    var annuity_deferred_immediate: [Double] {
        return commutation_D_x.enumerate().map() {
            (index, value_D_x) in
            if index >= commutation_D_x.count - 1 - n {
                return 0
            }
            return commutation_N_x[index + n + 1] / value_D_x
        }
    }
    
    var annuity_deferred_due: [Double] {
        return commutation_D_x.enumerate().map() {
            (index, value_D_x) in
            if index >= commutation_D_x.count - 1 - n {
                return 0
            }
            return commutation_N_x[index + n] / value_D_x
        }
    }
    
    var annuity_life_termCertain_immediate: [Double] {
        let immediate_nYear_certain = (1 - pow(1 + i, Double(-n))) / i
        
        return commutation_D_x.enumerate().map() {
            (index, value_D_x) in
            if index >= commutation_D_x.count - 1 - n {
                return immediate_nYear_certain
            }
            return immediate_nYear_certain + commutation_N_x[index + n + 1] / value_D_x
        }
    }
    
    var annuity_life_termCertain_due: [Double] {
        let due_nYear_certain = (1 - pow(1 + i, Double(-n))) / (i / (1 + i))
        
        return commutation_D_x.enumerate().map() {
            (index, value_D_x) in
            if index >= commutation_D_x.count - 1 - n {
                return due_nYear_certain
            }
            return due_nYear_certain + commutation_N_x[index + n] / value_D_x
        }
    }
}

//MARK: Life Insurances

extension AnnuityTable {
    var insurance_life: [Double] {
        return commutation_M_x.enumerate().map {
            (index, value_M_x) in
            if index == commutation_M_x.count - 1 {
                return 0
            }
            return value_M_x / commutation_D_x[index]
        }
    }
    
    var insurance_term: [Double] {
        return commutation_M_x.enumerate().map {
            (index, value_M_x) in
            if index == commutation_M_x.count - 1 {
                return 0
            }
            return (value_M_x - commutation_M_x[min(commutation_M_x.count - 1, index + n)]) / commutation_D_x[index]
        }
    }
    
    var insurance_pure_endowment: [Double] {
        return commutation_D_x.enumerate().map{
            (index, value_D_x) in
            if index >= commutation_D_x.count - 1 - n {
                return 0
            }
            return commutation_D_x[index + n] / value_D_x
        }
    }
    
    var insurance_endowment: [Double] {
        return commutation_M_x.enumerate().map {
            (index, value_M_x) in
            if index == max_Age {
                return 0
            }
            return (value_M_x - commutation_M_x[min(max_Age, index + n)] + commutation_D_x[min(max_Age, index + n)]) / commutation_D_x[index]
        }
    }
    
    var insurance_life_deferred: [Double] {
        return commutation_D_x.enumerate().map {
            (index, value_D_x) in
            if index >= max_Age - n {
                return 0
            }
            return commutation_M_x[index + n] / value_D_x
        }
    }
}

//MARK: Premiums

extension AnnuityTable {
    var premium_whole_life: [Double] {
        return commutation_M_x.enumerate().map {
            (index, value_M_x) in
            if index == max_Age {
                return 0
            }
            return value_M_x / commutation_N_x[index]
        }
    }
    
    var premium_term: [Double] {
        return commutation_M_x.enumerate().map {
            (index, value_M_x) in
            if index == max_Age {
                return 0
            }
            return (value_M_x - commutation_M_x[min(max_Age, index + n)]) / (commutation_N_x[index] - commutation_N_x[min(max_Age, index + n)])
        }
    }
    
    var premium_pure_endowment: [Double] {
        return commutation_N_x.enumerate().map {
            (index, value_N_x) in
            if index >= max_Age - n {
                return 0
            }
            return commutation_D_x[index + n] / (commutation_N_x[index] - commutation_N_x[index + n])
        }
    }
    
    var premium_endowment_insurance: [Double] {
        return commutation_M_x.enumerate().map {
            (index, value_M_x) in
            if index == max_Age {
                return 0
            }
            return (value_M_x - commutation_M_x[min(max_Age, index + n)] + commutation_D_x[min(max_Age, index + n)]) / (commutation_N_x[index] - commutation_N_x[min(max_Age, index + n)])
        }
    }
}





