//
//  ConstructorsWidget.swift
//  driversWidgetExtension
//
//  Created by Eddie Briscoe on 6/2/22.
//

import WidgetKit
import SwiftUI
import Intents

private struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), c1Name: "BriscoeCars", c1Points: "3", c2Name: "SagueCars", c2Points: "2", c3Name: "DiagoCars", c3Points: "1", c4Name: "Volvo", c4Points: "1", c5Name: "Lotus", c5Points: "1", configuration: ConfigurationIntent())
    }

    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), c1Name: "BriscoeCars", c1Points: "3", c2Name: "SagueCars", c2Points: "2", c3Name: "DiagoCars", c3Points: "1", c4Name: "Volvo", c4Points: "1", c5Name: "Lotus", c5Points: "1", configuration: configuration)
        completion(entry)
    }

    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []
        
        struct ConstructorInfo {
            let data: [String]
            
            var name: String {
                return data[1]
            }
            
            var points: String {
                return data[2]
            }
        }
        
        guard let defaults = UserDefaults(suiteName: "group.formulaOnedget")?.value(forKey: "constructorStandings") as? [[String]] else { return }
        
        var constStandings: [ConstructorInfo] = []
        
        for const in defaults[0...5] {
            constStandings.append(ConstructorInfo(data: const))
        }
        
        let c1Name = constStandings[0].name
        let c1Points = constStandings[0].points
        
        let c2Name = constStandings[1].name
        let c2Points = constStandings[1].points
        
        let c3Name = constStandings[2].name
        let c3Points = constStandings[2].points
        
        let c4Name = constStandings[3].name
        let c4Points = constStandings[3].points
        
        let c5Name = constStandings[4].name
        let c5Points = constStandings[4].points

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, c1Name: c1Name, c1Points: c1Points, c2Name: c2Name, c2Points: c2Points, c3Name: c3Name, c3Points: c3Points, c4Name: c4Name, c4Points: c4Points, c5Name: c5Name, c5Points: c5Points, configuration: configuration)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

private struct SimpleEntry: TimelineEntry {
    var date: Date
    
    let c1Name: String
    let c1Points: String
    let c2Name: String
    let c2Points: String
    let c3Name: String
    let c3Points: String
    let c4Name: String
    let c4Points: String
    let c5Name: String
    let c5Points: String
    let configuration: ConfigurationIntent
}

private struct ConstructorsWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            
            Image("Image").resizable()
            
            Rectangle()
                .fill(.white)
                .clipShape(ContainerRelativeShape()
                .inset(by: 5))
            
            VStack {
                Text("Constructors' Championship").foregroundColor(.orange).multilineTextAlignment(.center).font(Font.custom("formula1", size: 16))
                
                Rectangle().fill(Color("darkTeal")).frame(width: 125, height: 2)
                
                HStack {
                    Text("#").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10).padding(.trailing, 0)
                    Text("Team").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text("PTS").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame( alignment: .bottomTrailing).padding(.trailing, 10).padding(.leading, 0)
                }
                
                HStack {
                    Text("1.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10).padding(.trailing, 0)
                    Text(entry.c1Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.c1Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame( alignment: .bottomTrailing).padding(.trailing, 10).padding(.leading, 0)
                }
                
                HStack {
                    Text("2.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10).padding(.trailing, 0)
                    Text(entry.c2Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.c2Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame( alignment: .bottomTrailing).padding(.trailing, 10).padding(.leading, 0)
                }
                
                HStack {
                    Text("3.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10).padding(.trailing, 0)
                    Text(entry.c3Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.c3Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame( alignment: .bottomTrailing).padding(.trailing, 10).padding(.leading, 0)
                }
                
                HStack {
                    Text("4.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10).padding(.trailing, 0)
                    Text(entry.c4Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.c4Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame( alignment: .bottomTrailing).padding(.trailing, 10).padding(.leading, 0)
                }
                
                HStack {
                    Text("5.").foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(alignment: .topLeading).padding(.leading, 10).padding(.trailing, 0)
                    Text(entry.c5Name).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame(maxWidth: .infinity, alignment: .center)
                    Text(entry.c5Points).foregroundColor(.black).font(Font.custom("formula1", size: 10)).frame( alignment: .bottomTrailing).padding(.trailing, 10).padding(.leading, 0)
                }
            }
        }
    }
}
//@main
struct ConstructorsWidget: Widget {
    let kind: String = "ConstructorsWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            ConstructorsWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Constructors' Championship")
        .description("Shows you the current standings of the Constructors' Championship")
        .supportedFamilies([.systemSmall])
    }
}

struct ConstructorsWidget_Previews: PreviewProvider {
    static var previews: some View {
        ConstructorsWidgetEntryView(entry: SimpleEntry(date: Date(), c1Name: "BriscoeCars", c1Points: "3", c2Name: "SagueCars", c2Points: "2", c3Name: "DiagoCars", c3Points: "1", c4Name: "Volvo", c4Points: "1", c5Name: "Lotus", c5Points: "1", configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
