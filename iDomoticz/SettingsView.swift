//
//  SettingsView.swift
//  iDomoticz
//
//  Created by Morten Waldvogel-Rønning on 10/05/2022.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var domoticzData: DomoticzData
    
    var body: some View {
        Button(action: {
            domoticzData.loadDataFromUrl()
        }) {
            Text("Update")
        }
        
    }
}

/*
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
*/
