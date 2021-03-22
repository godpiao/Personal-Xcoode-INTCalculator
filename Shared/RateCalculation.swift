//
//  RateCalculation.swift
//  INTCalculator
//
//  Created by godpeo on 2021/3/21.
//

import Foundation

struct RateCalculation{
    let  periods = 0
    var  fee = 0.0
    var  interest=0.0
    
    var  debt = 1.0
    var  totalfee = 1.0
    
    var  percPi = 0.0       //每期本金利息和
    
    
    //存储 每期还款本金和利息
    var  details = [[String:Double]]()
    
    mutating func cal_int_byfee()
    {
        totalfee = debt * (1 + fee*Double(periods))
        percPi = totalfee / Double(periods)
        
        
    }
    
    mutating func cal_fee_bycal()
    {
        //等额本息计算
        percPi = debt * pow(1+interest, Double(periods)) * interest   /  (pow(1+interest, Double(periods)) - 1)
        totalfee  = percPi * Double(periods)
        
        fee = (totalfee-debt)/Double(periods) * debt
        var restdebt = debt
        for index in 1...periods{
            var detail = [String:Double]()
            
            detail["interest"] = restdebt *  interest
            detail["capit"] = percPi - restdebt *  interest
            
            restdebt -= detail["capit"] ?? 0.0
            
            details.append(detail)
            
        }
        
    }
    
}
