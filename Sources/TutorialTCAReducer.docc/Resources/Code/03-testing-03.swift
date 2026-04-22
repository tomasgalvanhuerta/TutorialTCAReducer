import Testing
import ComposableArchitecture

@MainActor
@Suite("Prayer Reducer Tests")
struct ParentFeatureTests {
    
    @Test("Prayer transforms child error into parent action")
    func prayerHandlesChildError() async {
        let store = TestStore(
            initialState: ParentFeature.State(
                createTrainingCycle: CreateTrainingCycleFeature.State()
            )
        ) {
            ParentFeature()
        }
        
        // Send a child error action
        await store.send(
            .createTrainingCycle(.presented(.failedToSave("Network error")))
        )
        
        // Prayer automatically sends the handleError action
        await store.receive(\.handleError) { state in
            state.errorMessage = "Network error"
        }
    }
    
    @Test("Prayer handles errors from any child")
    func prayerHandlesMultipleChildren() async {
        let store = TestStore(
            initialState: ParentFeature.State(
                editPlan: EditPlanFeature.State()
            )
        ) {
            ParentFeature()
        }
        
        // Send an error from a different child
        await store.send(
            .editPlan(.presented(.failedToSave("Database error")))
        )
        
        // Same handleError action is triggered
        await store.receive(\.handleError) { state in
            state.errorMessage = "Database error"
        }
    }
}
