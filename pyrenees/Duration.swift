public class Duration {
    private var millisecondValue: Double

    var milliseconds: Double {
        return millisecondValue
    }

    var seconds: Double {
        return milliseconds / 1000
    }

    var timer: Double {
        return seconds
    }

    public init(milliseconds: Double) {
        self.millisecondValue = milliseconds
    }

    public convenience init(seconds: Double) {
        self.init(milliseconds: seconds * 1000)
    }
}