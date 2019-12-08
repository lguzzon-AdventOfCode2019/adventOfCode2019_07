
import strutils
import sequtils
import algorithm

const
  gcMemory = "input".readFile.split(',').mapIt(parseBiggestInt(it))

type
  AmplifierStatus = enum
    ready
    waitInput
    finish
    error

  Amplifier = tuple
    status: AmplifierStatus
    input: seq[BiggestInt]
    memory: seq[BiggestInt]
    ip: BiggestInt
    output: seq[BiggestInt]

proc initAmplifier(aPhase: BiggestInt): Amplifier =
  result = (ready, @[aPhase], toSeq(gcMemory.items), 0i64, @[])

proc runProgram(aAmplifier: var Amplifier) =
  if ready == aAmplifier.status:
    while true:
      let lInstructionStr = ($aAmplifier.memory[aAmplifier.ip]).align(5, '0')
      let lOpCode = lInstructionStr[3..4].parseBiggestInt
      case lOpCode
      of 1:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        let lC = aAmplifier.memory[aAmplifier.ip + 3]
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
        aAmplifier.memory[lC] = (lA + lB)
        aAmplifier.ip += 4

      of 2:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        let lC = aAmplifier.memory[aAmplifier.ip + 3]
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
        aAmplifier.memory[lC] = (lA * lB)
        aAmplifier.ip += 4

      of 3:
        if aAmplifier.input.len > 0:
          var lA = aAmplifier.memory[aAmplifier.ip + 1]
          aAmplifier.memory[lA] = aAmplifier.input.pop
          aAmplifier.ip += 2
        else:
          aAmplifier.status = waitInput
          break

      of 4:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
        aAmplifier.output.insert(lA, 0)
        aAmplifier.ip += 2

      of 5:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
        if (0 != lA):
          aAmplifier.ip = lB
        else:
          aAmplifier.ip += 3

      of 6:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
        if (0 == lA):
          aAmplifier.ip = lB
        else:
          aAmplifier.ip += 3

      of 7:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        let lC = aAmplifier.memory[aAmplifier.ip + 3]
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
        if (lA < lB):
          aAmplifier.memory[lC] = 1
        else:
          aAmplifier.memory[lC] = 0
        aAmplifier.ip += 4

      of 8:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        let lC = aAmplifier.memory[aAmplifier.ip + 3]
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
        if (lA == lB):
          aAmplifier.memory[lC] = 1
        else:
          aAmplifier.memory[lC] = 0
        aAmplifier.ip += 4

      of 99:
        aAmplifier.status = finish
        break

      else:
        aAmplifier.status = error
        break

proc partOne =
  var result = BiggestInt.low
  var lPhases = @[0i64, 1i64, 2i64, 3i64, 4i64]
  let lPhasesMaxIndex = lPhases.len.pred
  while true:
    var lAmplifiers = lPhases.map(initAmplifier)
    lAmplifiers[0].input.insert(0i64, 0)
    for lIndex in 0 .. lPhasesMaxIndex:
      if lIndex > 0:
        lAmplifiers[lindex].input.insert(lAmplifiers[lindex.pred].output, 0)
      runProgram(lAmplifiers[lIndex])
    result = result.max(lAmplifiers[lPhasesMaxIndex].output[0])
    if not lPhases.nextPermutation:
      break
  echo "partOne $1"%[$result]

proc partTwo =
  var result = BiggestInt.low
  var lPhases = @[5i64, 6i64, 7i64, 8i64, 9i64]
  let lPhasesMaxIndex = lPhases.len.pred
  while true:
    var lAmplifiers = lPhases.map(initAmplifier)
    lAmplifiers[0].input.insert(0i64, 0)
    block blkPhase:
      while true:
        while lAmplifiers.anyIt(ready == it.status):
          lAmplifiers.apply(runProgram)
        if lAmplifiers.allit(finish == it.status):
          result = result.max(lAmplifiers[lPhasesMaxIndex].output[0])
          break blkPhase
        else:
          for lIndex in 0 .. lPhasesMaxIndex:
            if waitInput == lAmplifiers[lIndex].status:
              let lPredIndex = (lIndex + lPhasesMaxIndex).mod(lAmplifiers.len)
              if lAmplifiers[lPredIndex].output.len > 0:
                lAmplifiers[lIndex].input.insert(lAmplifiers[lPredIndex].output, 0)
                lAmplifiers[lIndex].status = ready
                lAmplifiers[lPredIndex].output = @[]
    if not lPhases.nextPermutation:
      break
  echo "partTwo $1"%[$result]


partOne() #17790
partTwo() #19384820
