//
//  InfoCellView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 14/07/2023.
//

import SwiftUI

struct InfoCellView: View {
    
    /// ViewModel
    @ObservedObject var vm: TextInputView.ViewModel
    
    init(vm: TextInputView.ViewModel) {
        self.vm = vm
    }
    
    
    
    var body: some View {
        ZStack{
            
            // Corner info text
            VStack{
                HStack(alignment:.top){
                    Text(vm.info)
                        .font(.caption)
                        .foregroundColor(.gray)
                        .offset(CGSize(width: -10, height: 6))
                    Spacer()
                }
                Spacer()
            }
            
            // main text
            HStack{
                Text(vm.text)
                    .foregroundColor(.gray)
                    .padding(.vertical)
                    
                Spacer()
            }
        } // ZStack
    }
}

struct InfoCellView_Previews: PreviewProvider {
    static var previews: some View {
        List{
            InfoCellView(vm: TextInputView.ViewModel(text: "Cell Title", info: "Corner Info"))
        }
    }
}
