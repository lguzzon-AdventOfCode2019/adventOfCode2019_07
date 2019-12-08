
import strutils
import sequtils
import algorithm


const
  gcMemory = "input".readFile.split(',').mapIt(parseBiggestInt(it))

type
  AmplifierStatus = enum
    running
    waitInput
    finish
    error

  Amplifier = tuple
    status : AmplifierStatus
    input:seq[BiggestInt]
    memory:seq[BiggestInt]
    ip: BiggestInt
    output:seq[BiggestInt]

proc initAmplifier(aPhase:BiggestInt):Amplifier = 
  result = (AmplifierStatus.running, @[aPhase], toSeq(gcMemory.items), 0i64, @[])

proc runProgram(aAmplifier : var Amplifier) = 
  if AmplifierStatus.running == aAmplifier.status:
    while true:
      let lInstructionStr = ($aAmplifier.memory[aAmplifier.ip]).align(5, '0')
      # echo "IP[$1] - $2"%[$aAmplifier.ip, lInstructionStr]
      let lOpCode = lInstructionStr[3..4].parseBiggestInt
      # echo "IP[$1] - $2"%[$aAmplifier.ip, $lOpCode]
      case lOpCode
      of 1:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        let lC = aAmplifier.memory[aAmplifier.ip + 3]
        # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
        # var lShow = false
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
          # lShow = true
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
          # lShow = true
        # if (lShow):
          # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
        aAmplifier.memory[lC] = (lA + lB)
        aAmplifier.ip += 4

      of 2:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        let lC = aAmplifier.memory[aAmplifier.ip + 3]
        # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
        # var lShow = false
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
          # lShow = true
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
          # lShow = true
        # if (lShow):
          # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
        aAmplifier.memory[lC] = (lA * lB)
        aAmplifier.ip += 4

      of 3:
        if aAmplifier.input.len > 0:
          var lA = aAmplifier.memory[aAmplifier.ip + 1]
          # echo "-- Values $1"%[$lA]
          aAmplifier.memory[lA] = aAmplifier.input.pop
          aAmplifier.ip += 2
        else:
          aAmplifier.status = AmplifierStatus.waitInput
          break

      of 4:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        # echo "-- Values $1"%[$lA]
        # var lShow = false
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
          # lShow = true
        # if (lShow):
          # echo "-- Values $1"%[$lA]
        # echo "Output --> " & $lA
        aAmplifier.output.insert(lA,0)
        aAmplifier.ip += 2

      of 5:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        # echo "-- Values $1,$2"%[$lA, $lB]
        # var lShow = false
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
          # lShow = true
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
          # lShow = true
        # if (lShow):
          # echo "-- Values $1,$2"%[$lA, $lB]
        if (0 != lA):
          aAmplifier.ip = lB
        else:
          aAmplifier.ip += 3

      of 6:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        # echo "-- Values $1,$2"%[$lA, $lB]
        # var lShow = false
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
          # lShow = true
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
          # lShow = true
        # if (lShow):
          # echo "-- Values $1,$2"%[$lA, $lB]
        if (0 == lA):
          aAmplifier.ip = lB
        else:
          aAmplifier.ip += 3

      of 7:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        let lC = aAmplifier.memory[aAmplifier.ip + 3]
        # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
        # var lShow = false
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
          # lShow = true
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
          # lShow = true
        # if (lShow):
          # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
        if (lA < lB):
          aAmplifier.memory[lC] = 1
        else:
          aAmplifier.memory[lC] = 0
        aAmplifier.ip += 4

      of 8:
        var lA = aAmplifier.memory[aAmplifier.ip + 1]
        var lB = aAmplifier.memory[aAmplifier.ip + 2]
        let lC = aAmplifier.memory[aAmplifier.ip + 3]
        # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
        # var lShow = false
        if ('0' == lInstructionStr[2]):
          lA = aAmplifier.memory[lA]
          # lShow = true
        if ('0' == lInstructionStr[1]):
          lB = aAmplifier.memory[lB]
          # lShow = true
        # if (lShow):
          # echo "-- Values $1,$2,$3"%[$lA, $lB, $lC]
        if (lA == lB):
          aAmplifier.memory[lC] = 1
        else:
          aAmplifier.memory[lC] = 0
        aAmplifier.ip += 4
      
      of 99:
        aAmplifier.status = AmplifierStatus.finish
        break

      else:
        # echo "Current IP [$1] Value [$2]"%[$aAmplifier.ip, lInstructionStr]
        aAmplifier.status = AmplifierStatus.error
        break

proc partOne =
  var result = BiggestInt.low
  var lPhases = @[BiggestInt(0i64), BiggestInt(1i64), BiggestInt(2i64), BiggestInt(3i64), BiggestInt(4i64)]
  while true:
    var amplifiers = lPhases.map(initAmplifier)
    amplifiers[0].input.add(0i64)
    amplifiers.apply(runProgram)
    for (index,amplifier) in amplifiers.pairs:
      if AmplifierStatus.running == amplifier.status:
        amplifiers[index.mod(lPhases.len)].input.insert(amplifier.output,0)
        amplifiers[index].output = @[]

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

  result = aAmplifier.status
  echo "partTwo $1"%[$result]


# partOne() #17790
partTwo() #9217546
