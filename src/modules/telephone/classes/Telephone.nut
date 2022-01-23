class Telephone {
    static classname = "Telephone";

    _isCalling = false;
    _isRinging = false;
    number = null;
    name = null;
    type = null;

    constructor(number, name, type) {
        this.number = number;
        this.name = name,
        this.type = type;
    }

    function isCalling() {
        return this._isCalling;
    }

    function startCalling() {
        this._isCalling = true;
    }

    function stopCalling() {
        this._isCalling = false;
    }

    function isRinging() {
        return this._isRinging;
    }

    function startRinging() {
        this._isRinging = true;
    }

    function stopRinging() {
        this._isRinging = false;
    }
}