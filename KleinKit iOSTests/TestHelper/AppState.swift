import Foundation

public struct AppState: Equatable {
    var sutA = "a"
    var sutB = "b"
    var sutC = AnotherStateC()
    var sutD = AnotherStateD()

    public static func == (lhs: AppState, rhs: AppState) -> Bool {
        return lhs.sutA == rhs.sutA &&
            lhs.sutB == rhs.sutB &&
            lhs.sutC == rhs.sutC &&
            lhs.sutD == rhs.sutD
    }
}

public struct AnotherStateC: Equatable {
    var sutC1 = "c1"
    var sutC2 = "c2"

    public static func == (lhs: AnotherStateC, rhs: AnotherStateC) -> Bool {
        return lhs.sutC1 == rhs.sutC1 && lhs.sutC2 == rhs.sutC2
    }
}

public struct AnotherStateD: Equatable {
    var sutD1 = "d1"
    var sutD2 = "d2"

    public static func == (lhs: AnotherStateD, rhs: AnotherStateD) -> Bool {
        return lhs.sutD1 == rhs.sutD1 && lhs.sutD2 == rhs.sutD2
    }
}
