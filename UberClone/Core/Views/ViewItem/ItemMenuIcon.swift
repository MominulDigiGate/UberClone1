//
//  ItemMenuIcon.swift
//  UberClone
//
//  Created by Mac Mini 5 on 1/2/23.
//

import SwiftUI

struct ItemMenuIcon: View {
    @Binding var mapState : MapViewState
    @EnvironmentObject var vmLocationSearch : VmLocationSearch
    
    var body: some View {
        Button{
            withAnimation(.spring()){
                actionForState(mapState)
            }
        } label: {
            Image(systemName: imageNameForState(mapState))
                .font(.title2)
                .foregroundColor(.black)
                .padding()
                .background(.white)
                .clipShape(Circle())
                .shadow(color: Color.red.opacity(0.3), radius: 10, x: 2, y: 2 )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    func actionForState(_ state : MapViewState){
        switch state {
        case .noInput:
            print("DEBUG: No input.")
            
        case .searchingForLocation:
            mapState = .noInput
            
        case .locationSelected:
            mapState = .noInput
            vmLocationSearch.selectedLocationCoordinate = nil
        }
    }
    
    func imageNameForState(_ state : MapViewState) -> String{
        switch state{
        case .noInput:
            return "line.3.horizontal"
            
        case .searchingForLocation, .locationSelected:
            return "arrow.left"
        }
    }
    
}

struct ItemMenuIcon_Previews: PreviewProvider {
    static var previews: some View {
        ItemMenuIcon(mapState: .constant(.noInput))
    }
}
