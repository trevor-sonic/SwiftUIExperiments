//
//  WeatherView.swift
//  Experimental
//
//  Created by Beydag, (Trevor) Duygun (Proagrica-HBE) on 06/03/2023.
//

import SwiftUI

struct WeatherInfo: Identifiable {
    var id = UUID()
    var image: String
    var temp: Int
    var city: String
}

struct WeatherView: View {
    
    let weatherData: [WeatherInfo] = [
        WeatherInfo(image: "snow", temp: 5, city:"New York"),
        WeatherInfo(image: "cloud", temp:5, city:"Kansas City"),
        WeatherInfo(image: "sun.max", temp: 80, city:"San Francisco"),
        WeatherInfo(image: "snow", temp: 5, city:"Chicago"),
        WeatherInfo(image: "cloud.rain", temp: 49,      city:"Washington DC"),
        WeatherInfo(image: "cloud.heavyrain", temp: 60,       city:"Seattle"),
        WeatherInfo(image: "sun.min", temp: 75,       city:"Baltimore"),
        WeatherInfo(image: "sun.dust", temp: 65,       city:"Austin"),
        WeatherInfo(image: "sunset", temp: 78,       city:"Houston"),
        WeatherInfo(image: "moon", temp: 80, city:"Boston"),
        WeatherInfo(image: "moon.circle", temp: 45,      city:"denver"),
        WeatherInfo(image: "cloud.snow", temp: 8,      city:"Philadelphia"),
        WeatherInfo(image: "cloud.hail", temp: 5,       city:"Memphis"),
        WeatherInfo(image: "cloud.sleet", temp:5,       city:"Nashville"),
        WeatherInfo(image: "sun.max", temp: 80,       city:"San Francisco"),
        WeatherInfo(image: "cloud.sun", temp: 5,       city:"Atlanta"),
        WeatherInfo(image: "wind", temp: 88, city:"Las Vegas"),
        WeatherInfo(image: "cloud.rain", temp: 60,       city:"Phoenix"),
    ]
    
    var body: some View {
        List {
            ForEach(self.weatherData){ weather in
                HStack{
                    Image(systemName: weather.image)
                        .frame(width: 50, alignment: .leading)
                    
                    Text("\(weather.temp)°F")
                        .frame(width: 80, alignment: .leading)
                    
                    Text(weather.city)
                }
                .font(.system(size: 20))
                .padding(.vertical, 15)
            }
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    static var previews: some View {
        WeatherView()
    }
}
