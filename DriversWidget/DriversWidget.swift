//
//  DriversWidget.swift
//  DriversWidget
//
//  Created by Eddie Briscoe on 6/2/22.
//

import WidgetKit
import SwiftUI
import Intents

private struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), p1Name: "Verstappen", p1Points: "3", p2Name: "Sague", p2Points: "2", p3Name: "Diago", p3Points: "1", p4Name: "Max", p4Points: "0", p5Name: "Kimi", p5Points: "0", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), p1Name: "Verstappen", p1Points: "3", p2Name: "Sague", p2Points: "2", p3Name: "Diago", p3Points: "1", p4Name: "Max", p4Points: "0", p5Name: "Kimi", p5Points: "0", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        let userDefaults = UserDefaults(suiteName: "group.formulaOnedget")
        let p1Name = userDefaults!.value(forKey: "p1Name") as? String ?? "Briscoe"
        let p1Points = userDefaults!.value(forKey: "p1Points") as? String ?? "3"
        
        let p2Name = userDefaults!.value(forKey: "p2Name") as? String ?? "Sague"
        let p2Points = userDefaults!.value(forKey: "p2Points") as? String ?? "2"
        
        let p3Name = userDefaults!.value(forKey: "p3Name") as? String ?? "Diago"
        let p3Points = userDefaults!.value(forKey: "p3Points") as? String ?? "1"
        
        let p4Name = userDefaults!.value(forKey: "p4Name") as? String ?? "Max"
        let p4Points = userDefaults!.value(forKey: "p4Points") as? String ?? "0"
        
        let p5Name = userDefaults!.value(forKey: "p5Name") as? String ?? "Kimi"
        let p5Points = userDefaults!.value(forKey: "p5Points") as? String ?? "0"

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, p1Name: p1Name, p1Points: p1Points, p2Name: p2Name, p2Points: p2Points, p3Name: p3Name, p3Points: p3Points, p4Name: p4Name, p4Points: p4Points, p5Name: p5Name, p5Points: p5Points, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    var date: Date
    
    let p1Name: String
    let p1Points: String
    let p2Name: String
    let p2Points: String
    let p3Name: String
    let p3Points: String
    let p4Name: String
    let p4Points: String
    let p5Name: String
    let p5Points: String
    let configuration: ConfigurationIntent
}

private struct DriversWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            Image("Image").resizable()
            
            Rectangle()
                .fill(.white)
                .clipShape(ContainerRelativeShape()
                .inset(by: 5))
            
            VStack {
                Text("Drivers' Championship").foregroundColor(.orange).multilineTextAlignment(.center).font(Font.custom("formula1", size: 16))
                
                Rectangle().fill(Color("darkTeal")).frame(width: 125, height: 2)
                
                HStack {
                    Text("#").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10).padding(.trailing, 0)
                    Text("Name").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text("PTS").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame( alignment: .bottomTrailing).padding(.trailing, 10).padding(.leading, 0)
                }
                
                HStack {
                    Text("1.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10).padding(.trailing, 0)
                    Text(entry.p1Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.p1Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame( alignment: .bottomTrailing).padding(.trailing, 10).padding(.leading, 0)
                }
                
                HStack {
                    Text("2.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10)
                    Text(entry.p2Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.p2Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .bottomTrailing).padding(.trailing, 10)
                }
                
                HStack {
                    Text("3.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10)
                    Text(entry.p3Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.p3Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .bottomTrailing).padding(.trailing, 10)
                }
                
                HStack {
                    Text("4.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10)
                    Text(entry.p4Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.p4Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .bottomTrailing).padding(.trailing, 10)
                }
                
                HStack {
                    Text("5.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10)
                    Text(entry.p5Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.p5Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .bottomTrailing).padding(.trailing, 10)
                }
            }
        }
    }
}
//@main
struct DriversWidget: Widget {
    let kind: String = "DriversWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            DriversWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Drivers' Championship")
        .description("Shows you the current standings of the Drivers' Championship")
        .supportedFamilies([.systemSmall])
    }
}

struct DriversWidget_Previews: PreviewProvider {
    static var previews: some View {
        DriversWidgetEntryView(entry: SimpleEntry(date: Date(), p1Name: "Verstappen", p1Points: "3", p2Name: "Sague", p2Points: "2", p3Name: "Diago", p3Points: "1", p4Name: "Max", p4Points: "0", p5Name: "Kimi", p5Points: "0", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
