//
//  DevoteWidget.swift
//  DevoteWidget
//
//  Created by Zeyad Badawy on 12/05/2022.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date())
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate)
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
}

struct DevoteWidgetEntryView : View {
    
    //MARK: PROPERTIES
    @Environment(\.widgetFamily) var widgetFamily
    
    var fontStyle : Font {
        if widgetFamily == .systemSmall {
            return .system(.footnote  , design: .rounded)
        }else {
            return .system(.headline  , design: .rounded)
        }
    }
    var entry: Provider.Entry

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                backgroundGradient
                Image("rocket-small")
                    .resizable()
                    .scaledToFit()
                    
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: widgetFamily != .systemSmall ? 56 : 36 ,
                           height: widgetFamily != .systemSmall ? 56 : 36
                    )
                    .offset(x: (geometry.size.width/2) - 20 ,
                            y: (geometry.size.height / -2) + 20)
                    .padding(.top , widgetFamily != .systemSmall ? 32 : 16)
                    .padding(.trailing , widgetFamily != .systemSmall ? 32 : 16)
                
                HStack {
                    Text("Just Do It")
                        .font(fontStyle.weight(.bold))
                        .padding(.horizontal , 16)
                        .padding(.vertical , 4 )
                        .background(with: .black.opacity(0.5))
                        .blendMode(.overlay)
                        .foregroundColor(.white)
                    .clipShape(Capsule())
                    
                    if widgetFamily != .systemSmall {
                        Spacer()
                    }
                    
                }//: HStack
                .padding()
                .offset(y: (geometry.size.width / 2 ) - 16)
            }//: Zstack
        }//: GeometryReader
    }
}

@main
struct DevoteWidget: Widget {
    let kind: String = "DevoteWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            DevoteWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Devote Widget")
        .description("This is an example widget.")
    }
}

struct DevoteWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            DevoteWidgetEntryView(entry: SimpleEntry(date: Date()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}

extension View {
    func background(with color: Color) -> some View {
        background(GeometryReader { geometry in
            Rectangle().path(in: geometry.frame(in: .local)).foregroundColor(color)
        })
    }
}
