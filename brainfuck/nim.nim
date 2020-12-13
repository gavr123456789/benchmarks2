import net
import os
import posix
import strformat

type
  OpType = enum Inc, Move, Loop, Print
  Ops = seq[Op]
  Op = object
    case op: OpType
    of Inc, Move: val: int
    of Loop: loop: Ops
    else: discard

  StringIterator = iterator(): char
  Tape = object
    pos: int
    tape: seq[int]

  Printer = object
    sum1: int
    sum2: int
    quiet: bool

  Program = distinct Ops

proc newTape(): Tape =
  Tape(pos: 0, tape: newSeq[int](1))

proc get(t: Tape): int =
  t.tape[t.pos]

proc inc(t: var Tape, x: int) =
  t.tape[t.pos] += x

proc move(t: var Tape, x: int) =
  t.pos += x
  while t.pos >= t.tape.len:
    t.tape.setLen 2 * t.tape.len

func newStringIterator(s: string): StringIterator =
  result = iterator(): char =
             for i in s:
               yield i

proc newPrinter(quiet: bool): Printer =
  Printer(sum1: 0, sum2: 0, quiet: quiet)

proc print(p: var Printer, n: int) =
  if p.quiet:
    p.sum1 = (p.sum1 + n) mod 255
    p.sum2 = (p.sum2 + p.sum1) mod 255
  else:
    stdout.write n.chr()
    stdout.flushFile()

proc parse(iter: StringIterator): Ops =
  for i in iter():
    case i
    of '+': result.add Op(op: Inc, val: 1)
    of '-': result.add Op(op: Inc, val: -1)
    of '>': result.add Op(op: Move, val: 1)
    of '<': result.add Op(op: Move, val: -1)
    of '.': result.add Op(op: Print)
    of '[': result.add Op(op: Loop, loop: parse iter)
    of ']': break
    else: discard

proc parse(code: string): Program =
  let iter = newStringIterator(code)
  result = Program parse iter

proc run(ops: Ops, t: var Tape, p: var Printer) =
  for op in ops:
    case op.op
    of Inc: t.inc op.val
    of Move: t.move op.val
    of Loop:
      while t.get() > 0: run(op.loop, t, p)
    of Print:
      p.print(t.get())

proc run(ops: Program, p: var Printer) =
  var tape = newTape()
  run Ops ops, tape, p

when isMainModule:
  let text = paramStr(1).readFile()
  var p = newPrinter(existsEnv("QUIET"))

  var compiler = "Nim/clang"
  when defined(gcc):
    compiler = "Nim/gcc"
  text.parse().run(p)

