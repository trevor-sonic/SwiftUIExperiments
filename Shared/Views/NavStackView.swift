//
//  NavStackView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 29/06/2023.
//

import SwiftUI



// MARK: - View
struct ColorListView: View {
    
    var vm: NavStackView.ViewModel
    
    
    init(vm: NavStackView.ViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack {
            Text("\(vm.path.count), \(vm.path.description)")
                .font(.headline)
            
            HStack {
                ForEach(vm.path, id: \.self) { color in
                    color
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                
            }
            
            List(vm.bgColors, id: \.self) { bgColor in
                
                NavigationLink(value: bgColor) {
                    Text(bgColor.description)
                }
                .listRowBackground(bgColor.description == vm.path.last?.description ?? "black" ? Color(.systemFill) : Color(.secondarySystemGroupedBackground))
                
            }
            
            
            .listStyle(.insetGrouped)
            Button {
                vm.path = .init()
            } label: {
                Text("Back to Main")
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
    }
    
    
}

// MARK: - ViewModel
extension NavStackView {
    @MainActor
    class ViewModel: ObservableObject {
        @Published var bgColors: [Color] = [ .indigo, .yellow, .green, .orange, .brown ]
        
        @Published var path: [Color] = []
        
        init() {
            path.append(.indigo)
            
        }
    }
}

// MARK: - View
struct NavStackView: View {
    
    @ObservedObject var vm: ViewModel
    
    init(vm: ViewModel) {
        self.vm = vm
    }
    
    
    
    
    
    var body: some View {
        
        
        NavigationStack (path: $vm.path) {
            
            ColorListView(vm: vm)

            .listStyle(.insetGrouped)
            
            
            .navigationDestination(for: Color.self) { color in
                
                ColorListView(vm: vm)
                
                
            }
            
            .navigationTitle("Color")
            
            
        }
        
    }
}

struct NavStackView_Previews: PreviewProvider {
    static var previews: some View {
        NavStackView(vm: NavStackView.ViewModel())
    }
}
