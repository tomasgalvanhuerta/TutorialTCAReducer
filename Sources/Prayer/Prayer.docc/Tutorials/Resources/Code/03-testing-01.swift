import Testing
import ComposableArchitecture

@MainActor
@Suite("Prayer Reducer Tests")
struct ParentFeatureTests {
    
    @Test("Prayer transforms child error into parent action")
    func prayerHandlesChildError() async {
        let store = TestStore(
            initialState: ParentFeature.State()
        ) {
            ParentFeature()
        }
    }
}
