function random(min = 0, max = RAND_MAX) {
    return (rand() % ((max + 1) - min)) + min;
}
