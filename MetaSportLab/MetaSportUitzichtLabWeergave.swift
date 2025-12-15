import SwiftUI

struct MetaSportUitzichtLabWeergave: View {
    @EnvironmentObject var uitzichtMetaSportLab: MetaSportLabbekijkmodel
    @State private var behoefteMetaSportLab: Bool = false
    @State private var aniMetaSportLab = false
    @State private var animerenLogo = false
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            VStack {
                BekijkSportWrapper(bekijkmodel: uitzichtMetaSportLab)
                
                HStack {
                    HStack {
                        Button(action: uitzichtMetaSportLab.backMetaSportLab) {
                            Image(systemName: "chevron.left")
                                .imageScale(.large)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                        }
                        .disabled(!uitzichtMetaSportLab.whyMetaSportLab.canGoBack)
                        
                        Button(action: uitzichtMetaSportLab.worvMetaSportLab) {
                            Image(systemName: "chevron.right")
                                .imageScale(.large)
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 32, height: 32)
                        }
                        .disabled(!uitzichtMetaSportLab.whyMetaSportLab.canGoForward)
                        
                        Spacer()
                    }
                }
            }
            VStack {
                if !behoefteMetaSportLab {
                    LaderUitzichtSport()
                }
            }
            .ignoresSafeArea()
        }
        .onAppear {
            aniMetaSportLab = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.behoefteMetaSportLab = true
                }
            }
        }
    }
}

struct BekijkSportWrapper: UIViewRepresentable {
    @ObservedObject var bekijkmodel: MetaSportLabbekijkmodel
    
    func makeUIView(context: Context) -> UIView {
        let view = bekijkmodel.whyMetaSportLab
        view.allowsBackForwardNavigationGestures = true
        return view
    }
    
    func updateUIView(_ uiView: UIView, context: Context) {}
}
