import SwiftUI
import _SpriteKit_SwiftUI
import Foundation

struct MetaSportNavigatieLab: View {
    @EnvironmentObject var bekijkmodel: MetaSportLabbekijkmodel 
    
    var body: some View {
        ZStack {
            Color.black
            .ignoresSafeArea()
            
            if bekijkmodel.truMetaSportLab {
                MetaSportUitzichtLabWeergave()
                    .oriëntatiegegevens(.all)
            } else {
                ZStack {
                    RootView()
                        .oriëntatiegegevens(.all)
                }
            }
        }
    }
    
}
 
