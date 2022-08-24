//
//  ScheduleWidget.swift
//  Formula Onedget
//
//  Created by Eddie Briscoe on 8/23/22.
//

import WidgetKit
import SwiftUI
import Intents

private struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), round: "1", weekend: "Mar 18 - Mar 20", raceName: "Bahrain Grand Prix", sess1: "FP1", sess1Time: "Fri 8:00 AM EDT", sess2: "FP2", sess2Time: "Fri 11:00 AM EDT", sess3: "FP3", sess3Time: "Sat 8:00 AM EDT", sess4: "Q1", sess4Time: "Sat 11:00 AM EDT", sess5: "Race", sess5Time: "Sun 11:00 AM EDT", track: "bahraingp", flag: "bahrain", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), round: "1", weekend: "Mar 18 - Mar 20", raceName: "Bahrain Grand Prix", sess1: "FP1", sess1Time: "Fri 8:00 AM EDT", sess2: "FP2", sess2Time: "Fri 11:00 AM EDT", sess3: "FP3", sess3Time: "Sat 8:00 AM EDT", sess4: "Q1", sess4Time: "Sat 11:00 AM EDT", sess5: "Race", sess5Time: "Sun 11:00 AM EDT", track: "bahraingp", flag: "bahrain",  configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        guard let race = UserDefaults(suiteName: "group.formulaOnedget")?.value(forKey: "schedule") as? [[String]] else { return }
        
        let round = race[0][0]
        let weekend = race[1][0]
        let raceName = race[2][0]
        let sess1 = race[3][0]
        let sess1Time = race[3][1]
        let sess2 = race[4][0]
        let sess2Time = race[4][1]
        let sess3 = race[5][0]
        let sess3Time = race[5][1]
        let sess4 = race[6][0]
        let sess4Time = race[6][1]
        let sess5 = race[7][0]
        let sess5Time = race[7][1]
        let track = race[8][0]
        let flag = race[8][1]

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, round: round, weekend: weekend, raceName: raceName, sess1: sess1, sess1Time: sess1Time, sess2: sess2, sess2Time: sess2Time, sess3: sess3, sess3Time: sess3Time, sess4: sess4, sess4Time: sess4Time, sess5: sess5, sess5Time: sess5Time, track: track, flag: flag, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    var date: Date
    
    let round: String
    let weekend: String
    let raceName: String
    let sess1: String
    let sess1Time: String
    let sess2: String
    let sess2Time: String
    let sess3: String
    let sess3Time: String
    let sess4: String
    let sess4Time: String
    let sess5: String
    let sess5Time: String
    let track: String
    let flag: String
    
    let configuration: ConfigurationIntent
}

private struct ScheduleWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("mediumImage").resizable()
            
            Rectangle()
                .fill(.white)
                .clipShape(ContainerRelativeShape()
                .inset(by: 5))
            
            VStack(spacing: 0) {
                HStack(spacing: 15) {
                    // left title
                    Text("Round \(entry.round)").foregroundColor(.orange).multilineTextAlignment(.center).font(Font.custom("formula1", size: 16))
                    
                    Image(entry.flag).resizable()
                        .frame(width: 30.0, height: 30).shadow(color: .gray, radius: 5, x: 0, y: 5)
                
                    // right title
                    Text(entry.weekend).foregroundColor(.orange).multilineTextAlignment(.center).font(Font.custom("formula1", size: 16))
                }
                
                Rectangle().fill(Color("darkTeal")).frame(width: 300, height: 2).padding(.bottom, 5)
                
                HStack { // left and right
                    VStack(spacing: 0) { // left side
                        
                        Text(entry.raceName).foregroundColor(Color("darkTeal")).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                        
                        Image(entry.track).resizable()
                            .frame(width: 75.0, height: 75.0).shadow(color: .gray, radius: 5, x: 0, y: 5)
                    }
                    
                    VStack(alignment: .trailing, spacing: 7) { // right side
                        HStack(spacing: 15) {
                            Text("\(entry.sess1): ").foregroundColor(Color("darkTeal")).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12)).frame(alignment: .leading)
                            
                            Text(entry.sess1Time).foregroundColor(.orange).font(Font.custom("formula1", size: 12))
                        }
                        
                        HStack(spacing: 15) {
                            Text("\(entry.sess2): ").foregroundColor(Color("darkTeal")).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                            Text(entry.sess2Time).foregroundColor(.orange).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                        }
                        
                        HStack(spacing: 15) {
                            Text("\(entry.sess3): ").foregroundColor(Color("darkTeal")).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                            Text(entry.sess3Time).foregroundColor(.orange).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                        }
                        
                        HStack(spacing: 15) {
                            Text("\(entry.sess4): ").foregroundColor(Color("darkTeal")).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                            Text(entry.sess4Time).foregroundColor(.orange).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                        }
                        
                        HStack(spacing: 15) {
                            Text("\(entry.sess5): ").foregroundColor(Color("darkTeal")).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                            Text(entry.sess5Time).foregroundColor(.orange).multilineTextAlignment(.center).font(Font.custom("formula1", size: 12))
                        }
                    }
                }
            }
        }
    }
}
//@main
struct ScheduleWidget: Widget {
    let kind: String = "ScheduleWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ScheduleWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Schedule")
        .description("Shows you the next race in the F1 schedule")
        .supportedFamilies([.systemMedium])
    }
}

struct ScheduleWidget_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleWidgetEntryView(entry: SimpleEntry(date: Date(), round: "1", weekend: "Mar 18 - Mar 20", raceName: "Bahrain Grand Prix", sess1: "FP1", sess1Time: "Fri 8:00 AM EDT", sess2: "FP2", sess2Time: "Fri 11:00 AM EDT", sess3: "FP3", sess3Time: "Sat 8:00 AM EDT", sess4: "Q1", sess4Time: "Sat 11:00 AM EDT", sess5: "Race", sess5Time: "Sun 11:00 AM EDT", track: "bahraingp", flag: "bahrain",  configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
