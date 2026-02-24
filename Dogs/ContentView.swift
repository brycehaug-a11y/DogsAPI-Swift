//
//  ContentView.swift
//  Dogs
//
//  Created by Bryce Stryker Haug  on 2/24/26.
//

//Your challeng - Get the photo to load to load on application start
//and Make it look professional!
//
import SwiftUI

struct ContentView: View{
    @State var doggoImage: URL?
    
    var body: some View {
        VStack(spacing: 20) {
            
            // Rounded professional image card
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white)
                    .shadow(color: .black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .frame(height: 260)

                AsyncImage(url: doggoImage) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()

                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                            .padding()

                    case .failure:
            VStack {
                Image(systemName: "photo")
                    .font(.largeTitle)
                    Text("Image failed to load")
            }

        @unknown default:
            EmptyView()
                    }
                }
            }
            .padding(.horizontal)

            Text("Ovi")
                .bold()
                .font(.largeTitle)

            Button {
                Task {
                    let ourData = await getServerData()
                    if let ourData = ourData {
                        doggoImage = URL(string: ourData.message)
                    }
                }
            } label: {
                Text("Fetch new Doggo!")
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
        
        // Auto-load image when the app starts
        .task {
            let ourData = await getServerData()
            if let ourData = ourData {
                doggoImage = URL(string: ourData.message)
            }
        }
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
