
import unittest

import adventOfCode2019_07
import adventOfCode2019_07/consts


suite "unit-test suite":
    test "getMessage":
        assert(cHelloWorld == getMessage())
