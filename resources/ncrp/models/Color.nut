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
}

function rgb(red = 255, green = 255, blue = 255, alpha = 255) {
    return Color(red, green, blue, alpha);
}
