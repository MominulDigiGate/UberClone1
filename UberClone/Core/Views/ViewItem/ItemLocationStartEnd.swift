//
//  ItemLocationStartEnd.swift
//  UberClone
//
//  Created by Mac Mini 5 on 1/2/23.
//

import SwiftUI

struct ItemLocationStartEnd: View {
    var body: some View {
        VStack{
            Circle()
                .frame(width: 8, height: 8)
                .foregroundColor(Color(.systemGray2))
            
            Rectangle()
                .frame(width: 1, height: 32)
                .foregroundColor(Color(.systemGray2))
            
            Rectangle()
                .frame(width: 8, height: 8)
                .foregroundColor(Color(.black))
        }
    }
}

struct ItemLocationStartEnd_Previews: PreviewProvider {
    static var previews: some View {
        ItemLocationStartEnd()
    }
}
