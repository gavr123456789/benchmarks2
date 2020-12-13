enum OpT {INC, MOVE, PRINT, LOOP}
namespace Test {
    struct Op {
        public OpT op;
        public int v;
        public Op[] loop;

        public Op(OpT _op, int _v) { op = _op; v = _v; loop = null; }
        public Op.vnull(OpT _op, Op[] _l) { op = _op; loop = _l; v = 0; }
    }

    [Compact]
    class Tape {
        public int pos = 0;
        public int[] tape = new int[1];

        public inline int Get() { return tape[pos]; }
        public inline void Inc(int x) { tape[pos] += x; }
        public inline void Move(int x) { pos += x; while (pos >= tape.length) tape.resize(tape.length*2);}
    }

    [Compact]
    class Printer {
        public int sum1 = 0;
        public int sum2 = 0;
        public bool quiet;

        public Printer(bool quiet) {
            this.quiet = quiet;
        }

        public inline void print(int n) {
            if (quiet) {
                sum1 = (sum1 + n) % 255;
                sum2 = (sum2 + sum1) % 255;
            } else {
                stdout.putc((char)n);
                stdout.flush();
            }
        }
    }

    class Program {
        private string code;
        private int pos = 0;
        private Op[] ops;
        private unowned Printer p;

        Program(string text, Printer p) {
            code = text;
            ops = parse();
            this.p = p;
        }

        private Op[] parse() {
            Op[] res = {};
            while (pos < code.length) {
                char c = code[pos];
                pos++;
                switch (c) {
                    case '+': res += (Op(OpT.INC, 1)); break;
                    case '-': res += (Op(OpT.INC, -1)); break;
                    case '>': res += (Op(OpT.MOVE, 1)); break;
                    case '<': res += (Op(OpT.MOVE, -1)); break;
                    case '.': res += (Op(OpT.PRINT, 0)); break;
                    case '[': res += (Op.vnull(OpT.LOOP, parse())); break;
                    case ']': return res;
                }
            }
            return res;
        }

        public void run() {
            _run(ops, new Tape());
        }

        private void _run(Op[] program, Tape tape) {
            for (int i=0;i<program.length;i++) {
                switch (program[i].op) {
                case OpT.INC: tape.Inc(program[i].v); break;
                case OpT.MOVE: tape.Move(program[i].v); break;
                case OpT.LOOP: while (tape.Get() > 0) _run(program[i].loop, tape); break;
                case OpT.PRINT: p.print(tape.Get());break;
                }
            }
        }

        static void main(string[] args) {
            string text;
            try {
                FileUtils.get_contents(args[1], out text);
            } catch (FileError e) {
                stdout.printf("Error: %s\n", e.message);
            }
            if (text.length == 0) {
                Process.exit(1);
            }
            var p = new Printer(Environment.get_variable("QUIET") != null);

            var timer = new Timer();
            new Program(text, p).run();
            timer.stop();

            message("time: " + timer.elapsed().to_string() + " s");

        }
    }
}