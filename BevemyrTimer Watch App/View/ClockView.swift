//
//  ClockView.swift
//  BevemyrTimer Watch App
//
//  Created by Katrin Boberg Bevemyr on 2023-12-30.
//

import SwiftUI

struct ClockView: View {
    @State private var isRunning: Bool = false
    @State private var now: Date = Date()
 
    @State private var zero: UInt64 = DispatchTime.now().uptimeNanoseconds
    @State private var currentTime: UInt64 = 0
    let timer = Timer.publish(every: 0.001, on: .main, in: .common).autoconnect()
    
    @Binding var log: [LogItem]
    @State private var logpostcounter:Int = 0
    
    let red = Color(red: 130/255, green: 51/255, blue:46/255) // 82332E 130 51 46
    let green = Color(red: 46/255, green: 139/255, blue: 74/255) // 2E824A 46 139 74


    var body: some View {
        
        VStack {
            if self.isRunning {
                Rectangle()
                .fill(green)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    // Action to perform when the rectangle is tapped
                    let teetime = Double(Int64(bitPattern: currentTime))
                    let bakkanttime = calcBakkantTime(tee: teetime)
                    let newPost = LogItem(id: logpostcounter, when: now, bakkant: bakkanttime, tee: teetime)
                    log.append(newPost)
                    logpostcounter += 1
                    self.isRunning.toggle()
                }
                .overlay(
                    VStack {
                        Text("Stop").font(.largeTitle)
                        //Spacer()
                        Text("\(currentTime)").font(.title)
                            .onReceive(timer) { _ in
                                self.updateTime()
                            }
                    }
                ).foregroundColor(Color.white)
            } else {
                Rectangle()
                    .fill(red)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onTapGesture {
                    // Action to perform when the rectangle is tapped
                    self.isRunning.toggle()
                    initTime()
                }
                .overlay(
                    VStack {
                        Text("Start").font(.largeTitle)
                        //Spacer()
                        if currentTime != 0 {
                            Text("Tee: "+timeString(time: Double(currentTime))).font(.title)
                            Text("Bakkant:"+timeString(time: calcBakkantTime(tee: Double(currentTime))))
                        }
                    }
                ).foregroundColor(Color.white)
            }
        }
        
    }
    
    func timeString(time: Double) -> String {
        let time = String(format: "%.2f", time/1000)
        return time
    }
    
    private func initTime() {
        self.zero = DispatchTime.now().uptimeNanoseconds
        self.currentTime = 0
        self.now = Date.init()
    }
    
    private func updateTime() {
        // You can use your preferred method to get the current time in milliseconds.
        // Here, we are using DispatchTime to calculate the time difference.
        let currentTimeNanos = DispatchTime.now().uptimeNanoseconds - zero
        let currentTimeMillis = currentTimeNanos / 1_000_000
        self.currentTime = currentTimeMillis
    }
    
    /*
     T2 = T1 * 1.256
     T2 = T1 * 0.778
     */
    
    private func calcTeeTime(bakkant: Double) -> Double {
        return bakkant * 0.778
    }
    
    private func calcBakkantTime(tee: Double) -> Double {
        return tee * 1.256
    }
    
    struct ClockView_Previews: PreviewProvider {
        static var previews: some View {
            let samplelog: [LogItem] = [LogItem(id: 1, when: Date.init(), bakkant: 2.34, tee: 3.33),
                                        LogItem(id: 1, when: Date.init(), bakkant: 3.34, tee: 4.33)]
            return ClockView(log: .constant(samplelog))
        }
    }
}
