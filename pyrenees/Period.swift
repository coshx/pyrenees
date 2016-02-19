public class Period {
    private var millisecondValue: Double

    public var milliseconds: Double {
        return millisecondValue
    }

    public var seconds: Double {
        return milliseconds / 1000
    }

    public var timerValue: Double {
        return seconds
    }

    public init(milliseconds: Double) {
        self.millisecondValue = milliseconds
    }

    public convenience init(seconds: Double) {
        self.init(milliseconds: seconds * 1000)
    }
}