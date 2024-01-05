//
//  ContentView.swift
//  BevemyrTimer Watch App
//
//  Created by Katrin Boberg Bevemyr on 2023-12-26.
//

import SwiftUI

struct ContentView: View {
    @State var log:[LogItem] = []
    
    var body: some View {
        TabView {
            NavigationStack {
                ClockView(log: $log)
                /*
                 NavigationLink(destination: LogView(log: $log)) {
                 Text("Show Log")
                 }
                 */
            }
            //.statusBar(hidden: true)
            NavigationStack {
                LogView(log: $log)
            }
        }
        .tabViewStyle(.page)
    }
}
    
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
