import platform
import socket
import sys
import os
import itertools
from pathlib import Path

INC = 1
MOVE = 2
LOOP = 3
PRINT = 4


class Op(object):
    def __init__(self, op, val):
        self.op = op
        self.val = val


class Tape(object):
    def __init__(self):
        self.tape = [0]
        self.pos = 0

    def get(self):
        return self.tape[self.pos]

    def inc(self, x):
        self.tape[self.pos] += x

    def move(self, x):
        self.pos += x
        while self.pos >= len(self.tape):
            self.tape.extend(itertools.repeat(0, len(self.tape)))


class Printer(object):
    def __init__(self, quiet):
        self.sum1 = 0
        self.sum2 = 0
        self.quiet = quiet

    def print2(self, n):
        if self.quiet:
            self.sum1 = (self.sum1 + n) % 255
            self.sum2 = (self.sum2 + self.sum1) % 255
        else:
            sys.stdout.write(chr(n))
            sys.stdout.flush()

    @property
    def checksum(self):
        return (self.sum2 << 8) | self.sum1


def parse(iterator):
    res = []
    while True:
        try:
            c = iterator.__next__()
        except StopIteration:
            break

        if c == "+":
            res.append(Op(INC, 1))
        elif c == "-":
            res.append(Op(INC, -1))
        elif c == ">":
            res.append(Op(MOVE, 1))
        elif c == "<":
            res.append(Op(MOVE, -1))
        elif c == ".":
            res.append(Op(PRINT, 0))
        elif c == "[":
            res.append(Op(LOOP, parse(iterator)))
        elif c == "]":
            break

    return res


def _run(program, tape, p):
    for op in program:
        if op.op == INC:
            tape.inc(op.val)
        elif op.op == MOVE:
            tape.move(op.val)
        elif op.op == LOOP:
            while tape.get() > 0:
                _run(op.val, tape, p)
        elif op.op == PRINT:
            p.print2(tape.get())


class Program(object):
    def __init__(self, code):
        self.ops = parse(iter(code))

    def run(self, p):
        _run(self.ops, Tape(), p)


if __name__ == "__main__":
    text = Path(sys.argv[1]).read_text()
    p = Printer(os.getenv("QUIET"))

    Program(text).run(p)

    if p.quiet:
        print("Output checksum:", p.checksum)
