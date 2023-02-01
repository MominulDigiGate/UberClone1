//
//  LocationSearchView.swift
//  UberClone
//
//  Created by Mac Mini 5 on 1/2/23.
//

import SwiftUI

struct LocationSearchView: View {
    
    @State private var originText = ""
    @Binding  var mapState : MapViewState
    @EnvironmentObject var vmLocationSearch : VmLocationSearch
    
    var body: some View {
        VStack{
            
            //header view
            HStack{
                ItemLocationStartEnd()
                
                VStack{
                    TextField("Current location", text: $originText)
                        .frame(height: 32)
                        .padding(.horizontal, 10)
                        .background(Color(.systemGroupedBackground))
                        .cornerRadius(5)
                        .padding(.trailing)
                    
                    TextField("Where to?", text: $vmLocationSearch.queryFragment)
                        .frame(height: 32)
                        .padding(.horizontal, 10)
                        .background(Color(.systemGray4))
                        .cornerRadius(5)
                        .padding(.trailing)
                }
            }
            .padding(.top,70)
            .padding(.horizontal)
            
            Divider()
                .padding(.top)
            
            
            //list view
            ScrollView()
            {
                VStack(alignment: .leading){
                    ForEach(vmLocationSearch.results, id: \.self){
                        result in
                        ItemLocationSearch(title: result.title, subTitle: result.subtitle)
                            .onTapGesture {
                                withAnimation(.spring()){
                                    vmLocationSearch.selectLocation(result)
                                    mapState = .locationSelected
                                }
                            }
                    }
                }
            }
            
            
        }
        .background(.white)
    }
}

struct LocationSearchView_Previews: PreviewProvider {
    static var previews: some View {
        LocationSearchView(mapState: .constant(.searchingForLocation))
    }
}
