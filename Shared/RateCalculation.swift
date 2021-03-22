//
//  RateCalculation.swift
//  INTCalculator
//
//  Created by godpeo on 2021/3/21.
//

import Foundation

struct cal_int_detail : Hashable{
    var id:Int
    var intrst = 0.0
    var captl = 0.0
}


struct RateCalculation{
    var  periods = 0
    
    

    
    var  debt = 1.0
    
    
    var  fee = 0.0
    
    var  mRate = 0.0     //月利率
    
    var  totalfee = 1.0
    
    
    //年利率
    var  aRate:Double = 0.0 {
        didSet {
            mRate = pow((1+aRate), 1/12) - 1
        }
    }
    
    
    
    var  percPi = 0.0       //每期本金利息和
    
    
    //存储 每期还款本金和利息
    var  details = [cal_int_detail]()
    mutating func cal_int_byfee()
    {
        totalfee = debt * (1 + fee*Double(periods))
        percPi = totalfee / Double(periods)
        
        
    }
    
    mutating func cal_fee_bycal()
    {
        //等额本息计算
        percPi = debt * pow(1+mRate, Double(periods)) * mRate   /  (pow(1+mRate, Double(periods)) - 1)
        totalfee  = percPi * Double(periods)
        
        fee = (totalfee-debt)/(Double(periods) * debt)
        var restdebt = debt
        for index in 1...periods{
            var detail = cal_int_detail(id:index)
            
            detail.intrst = restdebt *  mRate
            detail.captl = percPi - restdebt *  mRate
            
            restdebt -= detail.captl
            
            details.append(detail)
            
        }
        
    }
    
}
