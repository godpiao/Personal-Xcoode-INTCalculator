//
//  ContentView.swift
//  Shared
//
//  Created by godpeo on 2021/3/20.
//

import SwiftUI

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
    @State private var strItems:[String] = ["贷款金额","利率", "分期手续费"]
    @State private var strValues:[String] = ["","", ""]
    
    
    // 储存输入变量
    @State private var debt:Int = 0
    @State private var interest:Float = 0
    @State private var fee:Float = 0
    
    
    // 调试输出值
    @State private var strShow = ""
    
    
    var body: some View {
        VStack()
        {
            ForEach(0...2,id:\.self){
                
                SingleView(txtName: strItems[$0], txtValue: $strValues[$0])
            }
        }
        
        // 显示测试结果
        Button(action: {
            strShow.removeAll()
            for str in strValues{
                strShow += str
            }
        }) {
                Text("显示结果")
            }
        Text(strShow)
        
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
