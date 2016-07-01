//
//  Enumerations.swift
//  Contingencies
//
//  Created by Peter Cerhan on 6/25/16.
//  Copyright © 2016 Peter Cerhan. All rights reserved.
//

import Foundation

enum MortalityTable: String, CustomStringConvertible {
    case PPA_2016_blended
    
    var description: String {
        switch self {
        case PPA_2016_blended:
            return "2016 PPA"
        }
    }
}

enum Contingency: String, CustomStringConvertible {
    case LifeAnnuityImmediate
    case LifeAnnuityDue
    case TermAnnuityImmediate
    case TermAnnuityDue
    case DeferredAnnuityImmediate
    case DeferredAnnuityDue
    
    var description: String {
        switch self {
        case LifeAnnuityImmediate:
            return "Life Annuity Immediate"
        case LifeAnnuityDue:
            return "Life Annuity Due"
        case TermAnnuityImmediate:
            return "Term Annuity Immediate"
        case TermAnnuityDue:
            return "Term Annuity Due"
        case DeferredAnnuityImmediate:
            return "Deferred Annuity Immediate"
        case DeferredAnnuityDue:
            return "Deferred Annuity Due"
        }
    }
    
    var termType: String {
        switch self {
        case TermAnnuityDue, TermAnnuityImmediate:
            return "Term"
        case DeferredAnnuityDue, DeferredAnnuityImmediate:
            return "Deferral"
        default:
            return "None"
        }
    }
    
    func valueFromTable(table: AnnuityTable) -> [Double] {
        switch self {
        case LifeAnnuityImmediate:
            return table.annuity_life_immediate
        case LifeAnnuityDue:
            return table.annuity_life_due
        case TermAnnuityImmediate:
            return table.annuity_temporary_immediate
        case TermAnnuityDue:
            return table.annuity_temporary_due
        case DeferredAnnuityImmediate:
            return table.annuity_deferred_immediate
        case DeferredAnnuityDue:
            return table.annuity_deferred_due
        }
    }
}