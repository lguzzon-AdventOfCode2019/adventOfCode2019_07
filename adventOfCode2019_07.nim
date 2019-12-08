
import strutils
import sequtils
import algorithm


const
  gcMemory = "input".readFile.split(',').mapIt(parseBiggestInt(it))


proc runProgram(aInput: seq[BiggestInt], aMemory: var seq[BiggestInt]): BiggestInt =
  var
    lInstructionPointer: BiggestInt = 0
    lInputPointer = 0
  while true:
    let lInstructionStr = ($aMemory[lInstructionPointer]).align(5, '0')
    # echo "IP[$1] - $2"%[$lInstructionPointer, lInstructionStr]
    let lOpCode = lInstructionStr[3..4].parseBiggestInt
    # echo "IP[$1] - $2"%[$lInstructionPointer, $lOpCode]
    case lOpCode
    of 1:
      var lA = aMemory[lInstructionPointer + 1]
      var lB = aMemory[lInstructionPointer + 2]
      let lC = aMemory[lInstructionPointer + 3]
      # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
      # var lShow = false
      if ('0' == lInstructionStr[2]):
        lA = aMemory[lA]
        # lShow = true
      if ('0' == lInstructionStr[1]):
        lB = aMemory[lB]
        # lShow = true
      # if (lShow):
        # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
      aMemory[lC] = (lA + lB)
      lInstructionPointer += 4

    of 2:
      var lA = aMemory[lInstructionPointer + 1]
      var lB = aMemory[lInstructionPointer + 2]
      let lC = aMemory[lInstructionPointer + 3]
      # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
      # var lShow = false
      if ('0' == lInstructionStr[2]):
        lA = aMemory[lA]
        # lShow = true
      if ('0' == lInstructionStr[1]):
        lB = aMemory[lB]
        # lShow = true
      # if (lShow):
        # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
      aMemory[lC] = (lA * lB)
      lInstructionPointer += 4

    of 3:
      var lA = aMemory[lInstructionPointer + 1]
      # echo "-- Values $1"%[$lA]
      aMemory[lA] = aInput[lInputPointer]
      lInputPointer.inc
      lInstructionPointer += 2

    of 4:
      var lA = aMemory[lInstructionPointer + 1]
      # echo "-- Values $1"%[$lA]
      # var lShow = false
      if ('0' == lInstructionStr[2]):
        lA = aMemory[lA]
        # lShow = true
      # if (lShow):
        # echo "-- Values $1"%[$lA]
      # echo "Output --> " & $lA
      result = lA
      lInstructionPointer += 2

    of 5:
      var lA = aMemory[lInstructionPointer + 1]
      var lB = aMemory[lInstructionPointer + 2]
      # echo "-- Values $1,$2"%[$lA, $lB]
      # var lShow = false
      if ('0' == lInstructionStr[2]):
        lA = aMemory[lA]
        # lShow = true
      if ('0' == lInstructionStr[1]):
        lB = aMemory[lB]
        # lShow = true
      # if (lShow):
        # echo "-- Values $1,$2"%[$lA, $lB]
      if (0 != lA):
        lInstructionPointer = lB
      else:
        lInstructionPointer += 3

    of 6:
      var lA = aMemory[lInstructionPointer + 1]
      var lB = aMemory[lInstructionPointer + 2]
      # echo "-- Values $1,$2"%[$lA, $lB]
      # var lShow = false
      if ('0' == lInstructionStr[2]):
        lA = aMemory[lA]
        # lShow = true
      if ('0' == lInstructionStr[1]):
        lB = aMemory[lB]
        # lShow = true
      # if (lShow):
        # echo "-- Values $1,$2"%[$lA, $lB]
      if (0 == lA):
        lInstructionPointer = lB
      else:
        lInstructionPointer += 3

    of 7:
      var lA = aMemory[lInstructionPointer + 1]
      var lB = aMemory[lInstructionPointer + 2]
      let lC = aMemory[lInstructionPointer + 3]
      # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
      # var lShow = false
      if ('0' == lInstructionStr[2]):
        lA = aMemory[lA]
        # lShow = true
      if ('0' == lInstructionStr[1]):
        lB = aMemory[lB]
        # lShow = true
      # if (lShow):
        # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
      if (lA < lB):
        aMemory[lC] = 1
      else:
        aMemory[lC] = 0
      lInstructionPointer += 4

    of 8:
      var lA = aMemory[lInstructionPointer + 1]
      var lB = aMemory[lInstructionPointer + 2]
      let lC = aMemory[lInstructionPointer + 3]
      # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
      # var lShow = false
      if ('0' == lInstructionStr[2]):
        lA = aMemory[lA]
        # lShow = true
      if ('0' == lInstructionStr[1]):
        lB = aMemory[lB]
        # lShow = true
      # if (lShow):
        # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
      if (lA == lB):
        aMemory[lC] = 1
      else:
        aMemory[lC] = 0
      lInstructionPointer += 4

    else:
      # echo "Current IP [$1] Value [$2]"%[$lInstructionPointer, lInstructionStr]
      break


proc partOne =
  var result = BiggestInt.low
  var lPhases = @[0i64, 1i64, 2i64, 3i64, 4i64]
  while true:
    result = result.max(runProgram(@[lPhases[4],
        runProgram(@[lPhases[3],
        runProgram(@[lPhases[2],
        runProgram(@[lPhases[1],
        runProgram(@[lPhases[0], 0i64],
        toSeq(gcMemory.items))],
        toSeq(gcMemory.items))],
        toSeq(gcMemory.items))],
        toSeq(gcMemory.items))],
        toSeq(gcMemory.items)))
    if not lPhases.nextPermutation:
      break

  echo "partOne $1"%[$result]

proc partTwo =
  var result = BiggestInt.low
  var lPhases = @[5i64, 6i64, 7i64, 8i64, 9i64]
  var lPrograms = @[toSeq(gcMemory.items), toSeq(gcMemory.items), toSeq(gcMemory.items), toSeq(gcMemory.items), toSeq(gcMemory.items)]
  var lOutSignal = 0i64
  while true:
    echo $lOutSignal
    let la = runProgram(@[lPhases[0], lOutSignal, 0i64],lPrograms[0])
    echo $la
    lOutSignal = 
      runProgram(@[lPhases[4],
      runProgram(@[lPhases[3],
      runProgram(@[lPhases[2],
      runProgram(@[lPhases[1],
      runProgram(@[lPhases[0], lOutSignal],
      lPrograms[0])],
      lPrograms[1])],
      lPrograms[2])],
      lPrograms[3])],
      lPrograms[4])
    result = result.max(lOutSignal)
    if not lPhases.nextPermutation:
      break

  echo "partTwo $1"%[$result]


# partOne() #17790
partTwo() #9217546
