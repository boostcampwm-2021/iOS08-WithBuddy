//
//  WithBuddyWidget.swift
//  WithBuddyWidget
//
//  Created by 박정아 on 2021/11/24.
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

struct WithBuddyWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family

    var body: some View {
        switch family {
        case .systemSmall: SmallWidget(entry: entry)
        case .systemMedium: MediumWidget(entry: entry)
        case .systemLarge: LargeWidget(entry: entry)
        default: LargeWidget(entry: entry)
        }
    }
}

struct SmallWidget: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color("BackgroundPurple")
            Image("WidgetPurple")
                .resizable()
                .frame(width: .widgetBigBuddySize, height: .widgetBigBuddySize, alignment: .center)
        }
    }
}

struct MediumWidget: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color("BackgroundPurple")
            HStack {
                Image("WidgetPurple")
                    .resizable()
                    .frame(width: .widgetSmallBuddySize, height: .widgetSmallBuddySize, alignment: .center)
                Image("WidgetRed")
                    .resizable()
                    .frame(width: .widgetSmallBuddySize, height: .widgetSmallBuddySize, alignment: .center)
                Image("WidgetYellow")
                    .resizable()
                    .frame(width: .widgetSmallBuddySize, height: .widgetSmallBuddySize, alignment: .center)
            }
        }
    }
}

struct LargeWidget: View {
    var entry: Provider.Entry
    
    var body: some View {
        ZStack {
            Color("BackgroundPurple")
            VStack {
                HStack {
                    Image("WidgetPurple")
                        .resizable()
                        .frame(width: .widgetBigBuddySize, height: .widgetBigBuddySize, alignment: .center)
                    Image("WidgetRed")
                        .resizable()
                        .frame(width: .widgetBigBuddySize, height: .widgetBigBuddySize, alignment: .center)
                }
                HStack {
                    Image("WidgetYellow")
                        .resizable()
                        .frame(width: .widgetBigBuddySize, height: .widgetBigBuddySize, alignment: .center)
                    Image("WidgetPink")
                        .resizable()
                        .frame(width: .widgetBigBuddySize, height: .widgetBigBuddySize, alignment: .center)
                }
            }
        }
    }
}

@main
struct WithBuddyWidget: Widget {
    let kind: String = "WithBuddyWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            WithBuddyWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
    }
}

struct WithBuddyWidget_Previews: PreviewProvider {
    static var previews: some View {
        WithBuddyWidgetEntryView(entry: SimpleEntry(date: Date()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
