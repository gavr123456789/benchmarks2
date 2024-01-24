package mainNiva

//kotlinc kt.kt -include-runtime -d kt.jar
//java -jar kt.jar bench.b
import okio.Path.Companion.toPath

import kotlin.time.measureTime

sealed class Op() {
    class Inc(val v: Int) : Op()
    class Move(val v: Int) : Op()
    class Loop(val loop: Array<Op>) : Op()
    object Print : Op()
}

class Tape {
    private var tape: IntArray = IntArray(1)
    private var pos: Int = 0

    fun get(): Int {
        return tape[pos]
    }

    fun inc(x: Int) {
        tape[pos] += x
    }

    fun move(x: Int) {
        pos += x
        while (pos >= tape.size) {
//            this.tape = Arrays.copyOf(this.tape, this.tape.size * 2)
            this.tape = this.tape.copyOf(this.tape.size * 2)
        }
    }
}

class Printer(val quiet: Boolean) {
    private var sum1: Int = 0
    private var sum2: Int = 0

    fun print(n: Int) {
        if (quiet) {
            sum1 = (sum1 + n) % 255
            sum2 = (sum2 + sum1) % 255
        } else {
            print(n.toChar())
        }
    }

    fun getChecksum() = (sum2 shl 8) or sum1
}

class Program(code: String, val p: Printer) {
    private val ops: Array<Op>

    init {
        val it = code.iterator()
        ops = parse(it)
    }

    private fun parse(it: CharIterator): Array<Op> {
        val res = arrayListOf<Op>()
        while (it.hasNext()) {
            when (it.next()) {
                '+' -> res.add(Op.Inc(1))
                '-' -> res.add(Op.Inc(-1))
                '>' -> res.add(Op.Move(1))
                '<' -> res.add(Op.Move(-1))
                '.' -> res.add(Op.Print)
                '[' -> res.add(Op.Loop(parse(it)))
                ']' -> return res.toTypedArray()
            }
        }
        return res.toTypedArray()
    }

    fun run() {
        _run(ops, Tape())
    }

    private fun _run(program: Array<Op>, tape: Tape) {
        for (op in program) {
            when (op) {
                is Op.Inc -> tape.inc(op.v)
                is Op.Move -> tape.move(op.v)
                is Op.Loop -> while (tape.get() > 0) {
                    _run(op.loop, tape)
                }

                is Op.Print -> p.print(tape.get())
                else -> {}
            }
        }
    }
}

//const val PATH = "/home/gavr/Documents/Projects/Fun/benchmarks2/brainfuck/bench.b"
const val PATH = "/home/gavr/Documents/Projects/Fun/benchmarks2/brainfuck/mandel.b"

fun main(args: Array<String>) {
    val path = if (args.isNotEmpty()) args[0] else PATH
    val code = okio.FileSystem.SYSTEM.read(path.toPath()) { readUtf8() }

    val p = Printer(false)

    val q = measureTime {
        Program(code, p).run()
    }


    println(q)
//    val startTime = System.currentTimeMillis()
//    val timeDiff = (System.currentTimeMillis() - startTime) / 1e3

//    println("time: ${timeDiff}s")
}
