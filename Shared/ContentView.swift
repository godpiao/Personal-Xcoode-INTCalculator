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
        .padding()
    }
}




struct SingleView: View {
    @State var txtName = ""
    @Binding var txtValue:String
    var body:some View {
        HStack{
            Text(txtName)
                .padding()
            Spacer()
            TextField("", text: $txtValue)
            {_ in
                
            } onCommit:{
                
            }
            .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
            .disableAutocorrection(/*@START_MENU_TOKEN@*/false/*@END_MENU_TOKEN@*/)
            .border(Color(UIColor.separator))
            .frame(width: 180, alignment: .trailing )
            .keyboardType(.numberPad)
            .padding()
        }.padding()
    }
}




struct ContentView: View {
    
    //显示接受输入内容
    @State private var strItems:[String] = ["借款金额","分期期数","每期手续费率", "每期利率"]
    @State private var strValues:[String] = ["10000","10", "0.005", "0.006"]
    
    
    // 储存输入变量
    @State private var debt:Int = 0
    @State private var interest:Float = 0
    @State private var fee:Float = 0
    
    @State private var detaillist = [cal_int_detail]()
    
    func changefeeToInterest(debt:String, periods:String, interest:String) -> String {
        var result = ""
        
        if let debt = Double(debt), let per = Int(periods), let fee = Double(interest) {
            //
            var calc = RateCalculation(  periods:per, fee: fee, interest: fee , debt:debt )
            
            calc.cal_fee_bycal()
            detaillist = calc.details
            strShow = String(format:"%.2f", calc.totalfee)
            var index = 0
            for item in strItems {
                if item=="每期手续费率" {
                    break
                }
                index += 1
            }
            
            strValues[index] = String(format:"%.4f", calc.fee)// String(calc.fee)
            
            
        }
        else
        {
            print ("not regual input period is \(periods), fee is \(interest)")
        }
       
        return result
    }
    
    // 调试输出值
    @State private var strShow = ""
    
    
    var body: some View {
        VStack()
        {
            ForEach(0..<strItems.count,id:\.self){
                
                SingleView(txtName: strItems[$0], txtValue: $strValues[$0])
            }
        }
        
        // 显示测试结果
        Button(action: {
            _ = changefeeToInterest(debt:strValues[0], periods:strValues[1], interest: strValues[3])
        }) {
            Text("显示结果")
        }
        
        Text(strShow)
        
        if (!detaillist.isEmpty)
        {
          
            List(detaillist, id: \.id) { detail in
                CalinterestView(calValue: String(format:"%.2f",detail.captl), intrstValue: String(format:"%.2f",detail.intrst))
                //SingleView(txtName: "111", txtValue: $strValues[1])
                
            }
 
        }
        
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
