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
    static let minUnit:Double = 0.00001                 //求解的有效数字。
    
    
    static func getverFun(param:Double, fun:(Double)->Double) ->Double
    {
        let min = 0.000000000001
        _ = ( fun(param+min) - fun(param) ) / min
        return 0.00
    }
    //针对 输入0， 返回0， 并且单调递增的函数 求反函数
    static func getInverFun(x:Double, n:UInt, fun:(UInt,Double)->Double) ->Double
    {
        //
        var y  = x
        
        
        var left = 0.0
        var right = y
        while fun(n,y) < x
        {
            left = y
            y = y * 2
            right = y
        }
        
        //二分法 逼近
        
        y = (left + right) / 2
        
        var diff:Double
        repeat {
            
            diff = fun(n,y) - x
            
            if diff > 0 {
                right = y
                y =  (y + left) / 2
            }
            else {
                left = y
                y = (y + right) / 2
            }
            
            
            if (right - left < minUnit && right - left > -minUnit)
            {
                break
            }
        }
        while (diff != 0)
        
        
        return y
    }
}

struct RateCalculation{
    var  periods:UInt = 1
    
    

    
    var  debt = 1.0
    
    
    var  fee = 0.0
    
    var  mRate = 0.0     //月利率
    
    var  totalfee = 1.0
    
    
    //年利率
    var  aRate:Double  {
        get {
            return pow((1+mRate), 12) - 1
        }
        set {
           // aRate = newValue
            mRate = pow((1+newValue), 1/12) - 1
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
    mutating func cal_rate_byfee()
    {
        totalfee = debt * (1 + fee*Double(periods))
        percPi = totalfee / Double(periods)
        
        
        mRate = mathCalulate.getInverFun(x: fee, n:periods, fun: getPerPayByRate)
        
        var restdebt = debt
        for index in 1...periods{
            var detail = cal_int_detail(id:Int(index))
            
            detail.intrst = restdebt *  mRate
            detail.captl = percPi - restdebt *  mRate
            
            restdebt -= detail.captl
            
            details.append(detail)
            
        }
    }
    
    mutating func cal_fee_byrate()
    {
        //等额本息计算
        
        fee = getPerPayByRate(periods: periods, rate: mRate)

        percPi = debt/Double(periods)  + debt*fee
        totalfee  = percPi * Double(periods)
        
        
        
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
