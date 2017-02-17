open class Period {
    fileprivate var millisecondValue: Double

    open var milliseconds: Double {
        return millisecondValue
    }

    open var seconds: Double {
        return milliseconds / 1000
    }

    open var timerValue: Double {
        return seconds
    }

    public init(milliseconds: Double) {
        self.millisecondValue = milliseconds
    }

    public convenience init(seconds: Double) {
        self.init(milliseconds: seconds * 1000)
    }
}
