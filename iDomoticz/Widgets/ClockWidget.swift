//
//  Clock.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 21/06/2022.
//

import SwiftUI

struct ClockWidget: View {
    @State var aTime = getTime()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    
    var body: some View {
        Text(aTime).onReceive(timer, perform: {_ in
            aTime=getTime()
        })
    }
}


func getTime() -> String {
    let formatter = DateFormatter()
    formatter.dateFormat="HH:mm:ss"
    return formatter.string(from: Date())
}
