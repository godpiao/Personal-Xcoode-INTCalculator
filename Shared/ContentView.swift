//
//  ContentView.swift
//  Shared
//
//  Created by godpeo on 2021/3/20.
//

import SwiftUI


struct CalinterestView: View {
    var calValue:String
    var intrstValue:String
    var body:some  View{
        HStack{
            Text(calValue)
            Spacer()
            Text(intrstValue)
        }
    }
}




struct SingleView: View {
    @State var txtName = ""
    @Binding var txtValue:String
    var body:some View {
        HStack{
            Text(txtName)
            Spacer()
            TextField("", text: $txtValue)
            {_ in
                
            } onCommit:{
                
            }
            .autocapitalization(.none)
            .disableAutocorrection(false)
            .border(Color(UIColor.separator))
            .frame(width: 180, alignment: .trailing )
            .keyboardType(.asciiCapableNumberPad)
        }.padding()
    }
}

let txtName:[String:[String]] = ["loan":["借款金额","10000"], "period":["分期期数（月）","12"],"fee":["每期费率%","0.5"],"rate":["折算年利率%","10"],]

struct ContentView: View {
    
    //显示接受输入内容
   

    @State private var strItems:[String] = [txtName["loan"]![0],txtName["period"]![0],txtName["fee"]![0], txtName["rate"]![0]]
    
    @State private var strValues:[String] = [txtName["loan"]![1],txtName["period"]![1],txtName["fee"]![1], txtName["rate"]![1]]
    
    
    
    @State private var detaillist = [cal_int_detail]()
    
    
    // 总还款额
    @State private var totalpay = ""
    // 月利率
    @State private var mRate = ""
    
    func changefeeToInterest(debt:String, periods:String, aRate:String) -> String {
        let result = ""
        
        if let debt = Double(debt), let per = Int(periods), let itrst = Double(aRate) {
            //
            var calc = RateCalculation(periods:per,debt:debt, mRate: 0.0)
            calc.aRate = itrst/100
            
            calc.cal_fee_bycal()
            detaillist = calc.details
            totalpay = String(format:"%.2f", calc.totalfee)
            var index = 0
            for item in strItems {
                if item==txtName["fee"]![0] {
                    break
                }
                index += 1
            }
            strValues[index] = String(format:"%.2f", calc.fee*100)// String(calc.fee)
            
            mRate = String(format: "%0.2f", calc.mRate*100)
        }
        else
        {
            print ("not regual input period is \(periods), fee is \(aRate)")
        }
       
        return result
    }
    
    
    var body: some View {
        
        VStack()
        {
           
            ForEach(0..<strItems.count,id:\.self){
                
                SingleView(txtName: strItems[$0], txtValue: $strValues[$0])
            }.onChange(of: strValues, perform: { value in
                _ = changefeeToInterest(debt:value[0], periods:value[1], aRate: value[3])
            })
            HStack{
                // 计算总还款额
                Button(action: {
                    _ = changefeeToInterest(debt:strValues[0], periods:strValues[1], aRate: strValues[3])
                }) {
                    Text("显示结果")
                }
                if mRate != "" {
                    Spacer()
                    Text("月利率 \(mRate)%")
                }
                Spacer()
                if totalpay != "" {
                    Text("总还款额 \(totalpay)")
                }
            }.padding()
            
            if (!detaillist.isEmpty)
            {
                
                List(detaillist, id: \.id) { detail in
                    CalinterestView(calValue: String(format:"%.2f",detail.captl), intrstValue: String(format:"%.2f",detail.intrst))
                    //SingleView(txtName: "111", txtValue: $strValues[1])
                    
                }
                
            }
            Spacer()
        }.navigationTitle("贷款计算")
        
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*  testview
 
 //scrollview
     ScrollView(.horizontal) {
         LazyHStack(alignment: .top, spacing: 10) {
             ForEach(1...100, id: \.self) {
                 Text("Column \($0)")
             }
         }
     }.frame(height: 50)
 
 
 
 
 
 */
