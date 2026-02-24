//
//  ContentView.swift
//  Dogs
//
//  Created by Bryce Stryker Haug  on 2/24/26.
//

import SwiftUI

struct ContentView: View{
    @State var doggoImage: URL?
    var body: some View {
        VStack {
            AsyncImage(url: doggoImage) { img in
                if let error = img.error {
                    Text("We have an error")
                    Text("\(error.localizedDescription)")
                }
                if let image = img.image {
                    image
                        .resizable()
                        .frame(width: 200, height: 200)
                }
            }
            Text("Ovi")
                .bold()
                .font(.largeTitle)
            Button {
                Task {
                    let ourData = await getServerData()
                    doggoImage = URL(string: ourData.message)
                }
            } label: {
                Text("Fetch new Doggo!")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }
    func getServerData() async -> ServerReasponse? {
            do {
                guard let serverURL = URL(string: "https://dog.ceo/api/breeds/image/random") else {
                    return nil
                }
                let (data, response) = try await URLSession.shared.data(from: serverURL)

                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    print("We got a bad status code!")
                    return nil
                }
                let decoded = try JSONDecoder().decode(ServerReasponse.self, from: data)
                return decoded
            } catch {
                print(error)
            }
            return nil
        }
}

#Preview {
    ContentView()
}
struct ServerReasponse: Codable {
    let message: String
    let status: String
}

