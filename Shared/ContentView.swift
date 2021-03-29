//
//  ContentView.swift
//  Shared
//
//  Created by godpeo on 2021/3/20.
//

import SwiftUI


let txtName:[String:[String]] = ["loan":["借款金额","10000"], "period":["分期期数（月）","12"],"fee":["每期费率%","0.44"],"rate":["折算年利率%","10"],]

final class ModelData: ObservableObject {
    
    let names:[String] = [txtName["loan"]![0],txtName["period"]![0],txtName["fee"]![0], txtName["rate"]![0]]
    
    @Published var values:[String] = [txtName["loan"]![1],txtName["period"]![1],txtName["fee"]![1], txtName["rate"]![1]]
    
    var myn:String = ""
    
   // var ss = [&myn, &myn]
}


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


var list = Array([1])



struct SingleView: View {
    var name:String
    @Binding  var value:String
    var body:some View {
            HStack{
                Text(name)
                Spacer()
                TextField("", text: $value)
                {_ in
                    
                } onCommit:{
                    
                }
                .disableAutocorrection(false)
                .autocapitalization(.none)
                .border(Color(UIColor.separator))
                .frame(width: 180, alignment: .trailing )
                .keyboardType(.decimalPad)
                .textContentType(.oneTimeCode)
                
            }.padding()
        
    }
}


struct MainContentView: View {
    
    //显示接受输入内容
   

    @StateObject private var modelData = ModelData()
    
    
    @State private var detaillist = [cal_int_detail]()
    
    // 总还款额
    @State private var totalpay = ""
    // 月利率
    @State private var mRate = ""
    
    func getValueIndex(_ names:[String],name:String) -> Int{
        var index = 0
        for item in  names {
            if item==txtName[name]?[0] {
                break
            }
            index += 1
        }
        
        return index
    }
    
    // 总还款额
    @State private var debt = txtName["loan"]![1]
    @State private var debt2 = txtName["loan"]![1]
    // 总还款额
    @State private var periods = txtName["period"]![1]
    // 总还款额
    @State private var feevalue = txtName["fee"]![1]
    // 总还款额
    @State private var aRate = txtName["rate"]![1]
    
    @State var justcall:Bool = false         //是否刚计算完
    
    func changefeeToInterest(calfee:Bool = false, perchange:Bool = false)  {
        
        if let debt = Double(debt), let per = UInt(periods), let fee = Double(feevalue), let itrst = Double(aRate) {
            //
            var calc = RateCalculation(periods:per,debt:debt,fee:fee, mRate: 0.0)
            calc.aRate = itrst/100
            calc.fee  = fee/100
            _ = calfee ? calc.cal_rate_byfee() : calc.cal_fee_byrate()
            print("ct justcall is \(justcall)")
            justcall = perchange ? true : false
            print("ct justcall is \(justcall)")
            detaillist = calc.details
            totalpay = String(format:"%.2f", calc.totalfee)
            if calfee {
                aRate = String(format:"%.2f", calc.aRate*100)
            } else {
                feevalue = String(format:"%.2f", calc.fee*100)
            }
            
           // justcall = perchange ? false : justcall
           // print("ct justcall is \(justcall)")
            mRate = String(format: "%0.2f", calc.mRate*100)
        }
        else
        {
            print ("not regual input period is \(periods), fee is \(aRate)")
        }
       
    }

    
    
    
    
    
    
    var body: some View {
        NavigationView{
            VStack()
            {
//                SingleView().environmentObject(modelData)
//                    .onChange(of: modelData.values, perform: { [modelData] newValues in
//
//                    refreshView(newValues)
//            })
                
                
//                HStack{
//                    Text(modelData.names[0])
//                    Spacer()
//                    TextField("", text: $debt)
//                    {_ in
//
//                    } onCommit:{
//
//                    }
//                    .disableAutocorrection(false)
//                        .autocapitalization(.none)
//                        .border(Color(UIColor.separator))
//                        .frame(width: 180, alignment: .trailing )
//                        .keyboardType(.decimalPad)
//                        .textContentType(.oneTimeCode)
//
//                }.padding()
//                .onChange(of: /*@START_MENU_TOKEN@*/"Value"/*@END_MENU_TOKEN@*/, perform: { [newvalue] value in
//                    print("old value is \(debt), new is \(value)")
//                })
    
                
                SingleView(name:modelData.names[0],value:$debt)
                    .onChange(of: debt, perform: { [debt] value in
                    print("old debt value is \(debt), new is \(value)")
                    changefeeToInterest()
                })
                SingleView(name:modelData.names[1],value:$periods)
                .onChange(of: periods, perform: { [periods] value in
                    print("old period value is \(periods), new is \(value)")
                    changefeeToInterest(perchange:true)
                })
                SingleView(name:modelData.names[2],value:$feevalue)
                .onChange(of: feevalue, perform: { [feevalue] value in
                    print("justcall is \(justcall), old fee value is \(feevalue), new is \(value)")
                    justcall ? () : changefeeToInterest(calfee: true)
                    justcall = !justcall
                    print("now justall is \(justcall)")
                })
                SingleView(name:modelData.names[3],value:$aRate)
                .onChange(of: aRate, perform: { [aRate] value in
                    print("justcall is \(justcall), old rate value is \(aRate), new is \(value)")
                    justcall ? () : changefeeToInterest()
                    justcall = !justcall
                    print("now justall is \(justcall)")
                    
                })
                
                
                HStack{
                    // 计算总还款额
                    Button(action: {
                        
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
                        
                    }.listStyle(PlainListStyle())
                }
                Spacer()
            }.navigationTitle("贷款计算")
        }
        
    }
}
struct MainContentViewContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainContentView()
        
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
