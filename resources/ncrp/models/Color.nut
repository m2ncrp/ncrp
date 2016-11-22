class Color {
    r = 0;
    g = 0;
    b = 0;
    a = 0;

    constructor(red = 255, green = 255, blue = 255, alpha = 255)
    {
        this.r = red;
        this.g = green;
        this.b = blue;
        this.a = alpha;
    }

    function toHex() {
        return fromRGB(this.r, this.g, this.b, this.a);
    }

    function fromHex(hex) {
        local c = toRGBA(hex);
        this.r = c[0];
        this.g = c[1];
        this.b = c[2];
        this.a = c[3];
    }

    function applyAlpha(alpha)
    {
        local obj = clone this;
        obj.a = alpha;
        return obj;
    }
}

function rgb(red = 255, green = 255, blue = 255, alpha = 255) {
    return Color(red, green, blue, alpha);
}
