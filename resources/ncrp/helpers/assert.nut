__passed <- 0;
__total <- 0;

function test_error() {
    throw "Condition return false";
}

function assert(condition) {
    return condition ? condition : test_error();
}

function expect(unitname, expected, actual) {
    try {
        assert(expected == actual); __passed++;
        ::print("  \x1B[32m[✓ PASSED]\x1B[0m " + unitname);
    } catch (e) {
        ::print("  \x1B[31m[✗ FAILED]\x1B[0m " + unitname + ". Expected: " + expected + "; Got: "+actual);
    }
}




class TestQueue {
    test_cases = [];

    /**
     * Put function to the end of queue
     * @param  {pointer} test case function pointer
     * @return {void}
     */
    function pushback(testedFunc) {
        test_cases.push(testedFunc);
    }

    /**
     * Add a lot of cases at once
     * @param  {array} pointers to test functions
     * @return {void}
     */
    function pushall(vargv) {
        foreach (test in vargv) {
            pushback(test);
        }
    }

    /**
     * Get first test function in queue and invoke it
     * Used by admins if any test case failed to retry it once again
     * @return {void}
     */
    function pop(playerid) {
        local f = test_cases[0];
        f(playerid);
        test_cases.remove(0);
    }

    /**
     * Invoke all test cases in queue
     * @param  {integer} playerid
     * @return {void}
     */
    function invokeAll(playerid) {
        foreach (key, test_case in test_cases) {
            test_case(playerid);
            __total++;
        }
        ::print("Test cases passed " + __total + "\\" + __passed + " in total.\n");
        clear();
    }

    function clear() {
        __passed = 0;
        __total = 0;
        test_cases.clear();
    }
}
