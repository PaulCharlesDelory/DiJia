import SwiftUI

struct IASelectionView: View {
    @Binding var selectedIA: IA?
    @Binding var isIASelected: Bool
    let iaList: [IA]

    // Grid layout 2 colonnes
    let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        NavigationView {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(iaList) { ia in
                        Button(action: {
                            withAnimation {
                                selectedIA = ia
                                isIASelected = true
                            }
                        }) {
                            VStack {
                                AsyncImage(url: URL(string: ia.avatar_url)) { image in
                                    image
                                        .resizable()
                                        .scaledToFill()
                                } placeholder: {
                                    Color.gray.opacity(0.3)
                                }
                                .frame(width: 100, height: 100)
                                .clipShape(Circle())
                                .shadow(radius: 4)

                                Text(ia.name)
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding()
                            .background(Color.black.opacity(0.2))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        }
                    }
                }
                .padding()
            }
            .background(Color.black.ignoresSafeArea())
            .navigationTitle("Choisis ton IA")
            .foregroundColor(.white)
        }
    }
}

