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


struct mathCalulate {
    
    //针对 输入0， 返回0， 并且单调递增或递减的函数 求反函数
    static func getInverFun(param:Double, fun:(Double)->Double) ->Double
    {
        return 0.00
    }
}

struct RateCalculation{
    var  periods:UInt = 1
    
    

    
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
    
    

    
    // y =  [(1+x)^n *x  /(1+x)^n - 1 ] - 1/n , x=0 时为0
    func  getPerPayByRate(periods n:UInt, rate x:Double) -> Double {
        if x <= 0.00000 {
            return 0.00000
        }
        else
        {
            let en = pow((1+x), Double(n))
            return en * x / (en-1)  - 1/Double(n)
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
     

        percPi = debt/Double(periods)  + getPerPayByRate(periods: periods, rate: mRate)
        totalfee  = percPi * Double(periods)
        
        fee = (totalfee-debt)/(Double(periods) * debt)
        var restdebt = debt
        for index in 1...periods{
            var detail = cal_int_detail(id:Int(index))
            
            detail.intrst = restdebt *  mRate
            detail.captl = percPi - restdebt *  mRate
            
            restdebt -= detail.captl
            
            details.append(detail)
            
        }
        
    }
    
}
