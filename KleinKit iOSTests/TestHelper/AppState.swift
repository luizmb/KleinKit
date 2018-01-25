import Foundation

public struct AppState: Equatable {
    var a: String = "a"
    var b: String = "b"
    var c: AnotherStateC = AnotherStateC()
    var d: AnotherStateD = AnotherStateD()

    public static func ==(lhs: AppState, rhs: AppState) -> Bool {
        return lhs.a == rhs.a &&
            lhs.b == rhs.b &&
            lhs.c == rhs.c &&
            lhs.d == rhs.d
    }
}

public struct AnotherStateC: Equatable {
    var c_1: String = "c1"
    var c_2: String = "c2"

    public static func ==(lhs: AnotherStateC, rhs: AnotherStateC) -> Bool {
        return lhs.c_1 == rhs.c_1 && lhs.c_2 == rhs.c_2
    }
}

public struct AnotherStateD: Equatable {
    var d_1: String = "d1"
    var d_2: String = "d2"

    public static func ==(lhs: AnotherStateD, rhs: AnotherStateD) -> Bool {
        return lhs.d_1 == rhs.d_1 && lhs.d_2 == rhs.d_2
    }
}
