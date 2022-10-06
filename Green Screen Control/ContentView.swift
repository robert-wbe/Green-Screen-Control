//
//  ContentView.swift
//  Green Screen Control
//
//  Created by Robert Wiebe on 21.08.21.
//

import SwiftUI
import MapKit

let parisDesc: String = "Paris, city and capital of France, situated in the north-central part of the country. People were living on the site of the present-day city, located along the Seine River some 233 miles (375 km) upstream from the river’s mouth on the English Channel (La Manche), by about 7600 BCE. The modern city has spread from the island (the Île de la Cité) and far beyond both banks of the Seine."
let romeDesc: String = "Rome (Italian: Roma), the Eternal City, is the capital and largest city of Italy and of the Lazio region. It is famous for being the home of the ancient Roman Empire, the Seven Hills, La Dolce Vita (the sweet life), the Vatican City and Three Coins in the Fountain. Rome, as a millennia-long center of power, culture (having been the cradle of one of the globe's greatest civilisations ever) and religion, has exerted a huge influence over the world in its roughly 2800 years of existence."
let berlinDesc: String = "Berlin, the capital city of Germany, is renowned for its exceptional range of landmarks, vibrant cultural scene and way of life that's somehow all go yet relaxed. In fact, the city is best known for its striking contrasts. Historical buildings stand alongside modern architecture as the past and present intermingle. The sights Berlin has to offer, from the Brandenburg Gate to the Chancellor's Office, bear witness to the history of an entire nation."
let bpestDesc: String = "Budapest, city, capital of Hungary, and seat of Pest megye (county). The city is the political, administrative, industrial, and commercial centre of Hungary. The city straddles the Danube River in the magnificent natural setting where the hills of western Hungary meet the plains stretching to the east and south. It consists of two parts, Buda and Pest, which are situated on opposite sides of the river and connected by a series of bridges."

class destination {
    var title: String
    var title2: String
    var description: String
    
    init(title: String, secondary: String, desc: String) {
        self.title = title
        self.title2 = secondary
        self.description = desc
    }
}
let destinations: [destination] = [.init(title: "Paris", secondary: "France", desc: parisDesc), .init(title: "Rome", secondary: "Italy", desc: romeDesc), .init(title: "Berlin", secondary: "Germany", desc: berlinDesc), .init(title: "Budapest", secondary: "Hungary", desc: bpestDesc)]

let timeDestinations: [destination] = [.init(title: "Ancient Rome", secondary: "20 BCE", desc: parisDesc), .init(title: "Jurassic", secondary: "145 Million years ago", desc: parisDesc), .init(title: "Mars Colony", secondary: "Unforseeable Future", desc: parisDesc)]

let coordinates: [[CLLocationDegrees]] = [[48.8566, 2.3522], [41.9021, 12.4964], [52.52, 13.405], [47.4979, 19.0402]]

struct ContentView: View {
    
    struct Response: Codable {
        var results: [Result]
    }

    struct Result: Codable {
        var trackId: Int
        var trackName: String
        var collectionName: String
    }
    
    @State private var results = [Result]()
    
    @State var recording: Bool = false
    @State var currentDestination: Int = 0
    @State var currentTimeDestination: Int = 0
    @State public var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    @State public var modeIsTime: Bool = false
    var body: some View {
        ZStack(alignment: .center){
            Image("travel bg")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.2)
                .blur(radius: 20)
            
            Image("travel bg")
                .resizable()
                .scaledToFit()
                .scaleEffect(1.2)
                .mask(
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 700, height: 600)
                        .offset(y: -150)
                )
                .shadow(radius: 20)
            
            
            VStack(alignment: .center) {
                
                Spacer()
                
                VStack{
//                    Text("Choose where you'd like to travel!")
//                        .foregroundColor(.white)
//                        .font(.system(size: 50))
//                        .bold()
                    HStack{
                        Label("Space Travel", systemImage: "network")
                            .foregroundColor(modeIsTime ? .white : .orange)
                            .font(.largeTitle.bold())
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12.5)
                                    .foregroundColor(modeIsTime ? .orange : .white)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12.5)
                                            .stroke(Color.orange, lineWidth: 5)
                                            .opacity(modeIsTime ? 0 : 1)
                                    )
                            )
                            .animation(.default, value: modeIsTime)
                            .onTapGesture {
                                withAnimation(.default) {
                                    modeIsTime = false
                                }
                            }
                            
                        Text("or")
                            .foregroundColor(.white)
                            .font(.largeTitle)
                            .bold()
                        Label("Time Travel", systemImage: "clock")
                            .foregroundColor(modeIsTime ? .orange : .white)
                            .font(.largeTitle.bold())
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12.5)
                                    .foregroundColor(modeIsTime ? .white : .orange)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12.5)
                                            .stroke(Color.orange, lineWidth: 5)
                                            .opacity(modeIsTime ? 1 : 0)
                                    )
                            )
                            .animation(.default, value: modeIsTime)
                            .onTapGesture {
                                withAnimation(.default) {
                                    modeIsTime = true
                                }
                            }
                        
                    }.padding(.top)
                }
                .padding(.bottom, 50)
                .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
                
                Spacer()
                
                ZStack {
                    HStack(spacing: 20) {
                        ForEach(0...destinations.count-1, id: \.self) { dest in
                                GeometryReader { geometry in
                                    Card(cardNumber: dest,destination: destinations[dest], currentDest: $currentDestination)
                                        .scaleEffect(1-pow((geometry.frame(in: .global).midX - 420) / 900, 2))
                                        .scaleEffect(modeIsTime ? 0.7 : 1)
                                    
                                }
                                .frame(width: 400, height: 500)
                            }
                    }
                    .frame(width: 400)
                    .modifier(ScrollingHStackModifier(items: destinations.count, itemWidth: 400, itemSpacing: 20))
                    .opacity(modeIsTime ? 0 : 1)
                    
                    HStack(spacing: 20) {
                        ForEach(0...timeDestinations.count-1, id: \.self) { dest in
                                GeometryReader { geometry in
                                    Card(cardNumber: dest, destination: timeDestinations[dest], currentDest: $currentTimeDestination)
                                        .scaleEffect(1-pow((geometry.frame(in: .global).midX - 512) / 800, 2))
                                        .scaleEffect(modeIsTime ? 1 : 0.7)
                                    
                                }
                                .frame(width: 400, height: 500)
                            }
                    }
                    .frame(width: 400)
                    .modifier(ScrollingHStackModifier(items: destinations.count, itemWidth: 400, itemSpacing: 20))
                    .offset(x: -200)
                    .opacity(modeIsTime ? 1 : 0)
                    
                    
                }
                .mask(
                    Rectangle()
                        .frame(width: 700, height: 600)
                )
                
                Spacer()
                
                
                RoundedRectangle(cornerRadius: 50)
                    .foregroundColor(.white)
                    .frame(height: 450)
                    .shadow(color: /*@START_MENU_TOKEN@*/.black/*@END_MENU_TOKEN@*/, radius: 20, x: /*@START_MENU_TOKEN@*/0.0/*@END_MENU_TOKEN@*/, y: -5)
                    .overlay(
                        HStack{
                            VStack {
                                HStack(alignment: .bottom, spacing: 0){
                                    Text(modeIsTime ? timeDestinations[currentTimeDestination].title : destinations[currentDestination].title)
                                        .font(.system(size: 50, weight: .bold)) +
                                    Text(", " + (modeIsTime ? timeDestinations[currentTimeDestination].title2 : destinations[currentDestination].title2))
                                        .font(.system(size: 50, weight: .regular))
                                    Spacer()
                                }
                                Text(destinations[currentDestination].description)
                                    .font(.title3)
                            }
                            Spacer()
                            Map(coordinateRegion: $region)
                                .cornerRadius(25.0)
                                .padding(.leading, 50)
                                .onChange(of: currentDestination, perform: { value in
                                    self.updateRegion()
                                })
                            .frame(width: 420)
                            .overlay(
                                CameraButton(color: .blue, tColor: .white, symbol: "camera.fill", title: "Take a picture")
                                    .onTapGesture {
                                        print("here")
                                        let url = URL(string: "http://10.165.1.71:5000/screenshot" )
                                        guard let requestUrl = url else {fatalError()}
                                        var request = URLRequest(url: requestUrl)
                                        request.httpMethod = "POST"
                                        let body = SentData(email: "hi@lol.com")
                                        let finalBody = try? JSONEncoder().encode(body)
                                        request.httpBody = finalBody
                                        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                                            print(data)
                                        }
                                        task.resume()
                                    }
                                    .frame(width: 300, height: 80)
                                    .padding()
                                , alignment: .bottomTrailing
                            )
                        }
                        .padding(50)
                    )
            }
        }
        .frame(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        
        
    }
    func updateRegion(){
        region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: coordinates[currentDestination][0], longitude: coordinates[currentDestination][1]), span: MKCoordinateSpan(latitudeDelta: 6, longitudeDelta: 6))
    }
    
}

struct CameraButton: View{
    var color: Color
    var tColor: Color
    var symbol: String
    var title: String
    var body: some View{
        RoundedRectangle(cornerRadius: 25.0)
            .foregroundColor(color)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .overlay(
                HStack(alignment: .bottom, spacing: 15){
                    Image(systemName: symbol)
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundColor(tColor)
                    Text(title)
                        .font(.title)
                        .fontWeight(.semibold)
                        .foregroundColor(tColor)
                }
            )
    }
}

func updateCard(){
    
}

struct Card: View {
    var cardNumber: Int
    var destination: destination
    @Binding var currentDest: Int
    var body: some View {
        VStack(alignment: .leading){
            Spacer()
            Text(destination.title)
                .foregroundColor(.white)
                .font(.largeTitle)
                .bold()
                .padding(.leading)
//                .padding(.trailing, -100)
            Button(action: {
                currentDest = self.cardNumber
                
                let url = URL(string: "http://10.165.1.71:5000/goto?place=\(destination.title)" )
                guard let requestUrl = url else {fatalError()}
                var request = URLRequest(url: requestUrl)
                request.httpMethod = "GET"
                let task = URLSession.shared.dataTask(with: request) { (data, response, error) in

                }
                task.resume()
            }){
                    Text("Travel here")
                        .foregroundColor(.white)
                        .font(.title)
                        .padding()
            }
        }
        .padding(.trailing, 140)
        .padding(40)
        .frame(width: 400, height: 500)
        .background(
            LinearGradient(gradient: Gradient(colors: [Color.black.opacity(0), Color.black.opacity(0.5)]), startPoint: .top, endPoint: UnitPoint(x:0.5,y:0.9))
        )
        .background(
            Image(destination.title)
                .resizable()
                .aspectRatio(contentMode: .fill)
        )
        .mask(
            RoundedRectangle(cornerRadius: 50, style: .continuous)
        )
        //Stroke
        .overlay(
            RoundedRectangle(cornerRadius: 50, style: .continuous)
                .stroke(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 1)
                .blendMode(.overlay)
                .overlay(
                    RoundedRectangle(cornerRadius: 50, style: .continuous)
                        .stroke(LinearGradient(gradient: Gradient(colors: [Color.white, Color.gray.opacity(0.5)]), startPoint: .topLeading, endPoint: .bottomTrailing), lineWidth: 3)
                        .blur(radius:5)
                )
        )
        .shadow(radius: 5)
    }
}

struct ScrollingHStackModifier: ViewModifier {
    
    @State private var scrollOffset: CGFloat
    @State private var dragOffset: CGFloat
    
    var items: Int
    var itemWidth: CGFloat
    var itemSpacing: CGFloat
    
    init(items: Int, itemWidth: CGFloat, itemSpacing: CGFloat) {
        self.items = items
        self.itemWidth = itemWidth
        self.itemSpacing = itemSpacing
        
        // Calculate Total Content Width
        let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
        let screenWidth = UIScreen.main.bounds.width
        
        // Set Initial Offset to first Item
        let initialOffset = (contentWidth/2.0) - (screenWidth/2.0) + ((screenWidth - itemWidth) / 2.0)
        
        self._scrollOffset = State(initialValue: initialOffset)
        self._dragOffset = State(initialValue: 0)
    }
    
    func body(content: Content) -> some View {
        content
            .offset(x: scrollOffset + dragOffset, y: 0)
            .gesture(DragGesture()
                .onChanged({ event in
                    dragOffset = event.translation.width
                })
                .onEnded({ event in
                    // Scroll to where user dragged
                    scrollOffset += event.translation.width
                    dragOffset = 0
                    
                    // Now calculate which item to snap to
                    let contentWidth: CGFloat = CGFloat(items) * itemWidth + CGFloat(items - 1) * itemSpacing
                    let screenWidth = UIScreen.main.bounds.width
                    
                    // Center position of current offset
                    let center = scrollOffset + (screenWidth / 2.0) + (contentWidth / 2.0)
                    
                    // Calculate which item we are closest to using the defined size
                    var index = (center - (screenWidth / 2.0)) / (itemWidth + itemSpacing)
                    
                    // Should we stay at current index or are we closer to the next item...
                    if index.remainder(dividingBy: 1) > 0.5 {
                        index += 1
                    } else {
                        index = CGFloat(Int(index))
                    }
                    
                    // Protect from scrolling out of bounds
                    index = min(index, CGFloat(items) - 1)
                    index = max(index, 0)
                    
                    // Set final offset (snapping to item)
                    let newOffset = index * itemWidth + (index - 1) * itemSpacing - (contentWidth / 2.0) + (screenWidth / 2.0) - ((screenWidth - itemWidth) / 2.0) + itemSpacing
                    
                    // Animate snapping
                    withAnimation {
                        scrollOffset = newOffset
                    }
                    
                })
            )
    }
}

struct SentData: Codable{
    var email: String
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
