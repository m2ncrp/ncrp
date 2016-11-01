/**
 * Call a delayed function
 *
 * @param {int} time in ms
 * @param {Function} callback
 * @param {mixed} [additional] optional argument
 *     that will be passed to a callback
 *
 * @return {int} timer id
 */
function delayedFunction(time, callback, additional = null) {
    return additional ? timer(callback, time, 1, additional) : timer(callback, time, 1);
}
