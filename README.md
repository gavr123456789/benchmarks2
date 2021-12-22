# benchmarks2
Languages benchmarks


# Intel® Core™ i5-10400 CPU @ 2.90GHz × 12
## brainfuck bench.b

|                 Language |                   Time, s |
| :----------------------- | ------------------------: |
|                      C++ |                      1,27 |
|              Nim Cpp orc |                      1,31 |
|              Nim regions |                      1,36 |
|                     Vala |                      1,38 |
|                        C |                      1,40 |
|                  Nim Cpp |                      1,40 |
|                    Nim C |                      1,40 |
|                        D |                      1,42 | 
|       Nim C markAndSweep |                      1,43 |
|                Nim C orc |                      1,43 |
|                     Rust |                      1,50 |
|              Nim Cpp arc |                      1,61 |
|                       Go |                      1,82 |
|                  Crystal |                      2,18 |


## brainfuck mandel.b

|                 Language |                   Time, s |
| :----------------------- | ------------------------: |
|                      C++ |                     11,56 |
|                        C |                     13,15 |
|                     Vala |                     13,81 |
|                Nim C arc |                     13,85 |
|                     Rust |                     14,00 |
|              Nim Cpp orc |                     14,13 |
|                        D |                     14,18 |
|              Nim Cpp arc |                     14,68 |
|                Nim C orc |                     14,68 |
|                  Nim Cpp |                     18,63 |
|                    Nim С |                     18,92 |
|                  Crystal |                     22,52 |
|            Nim C regions |                     23,25 |
|                       Go |                     28,39 |



### Versions
|                 Language |                   Time, s |
| :----------------------- | ------------------------: |
|            g++ --version |                    11.1.0 |
|           vala --version |                    0.52.3 |
|            gcc --version |                    11.1.0 |
|            nim --version |                     1.4.6 |
|            ldc --version | 1.26.0 DMD v2.096.1 LLVM 11.1.0 | 
|        crystal --version | Crystal 1.0.0 (2021-03-29) LLVM: 10.0.1| 
|          gccgo --version |         gccgo (GCC) 11.1.0| 
|          rustc --version |               rustc 1.52.1| 


# AMD® Ryzen 5 1600 six-core processor × 12

## brainfuck bench.b

|                 Language |                   Time, s |
| :----------------------- | ------------------------: |
|                      C++ |                      1,73 |
|                     Vala |                      2.10 |
|            Kotlin JDK 13 |                      1.96 |
|                        C |                      2,38 |
|                      Nim |                      2,08 |
|                        D |                      3,09 | 

## brainfuck mandel.b

|                 Language |                   Time, s |
| :----------------------- | ------------------------: |
|                      C++ |                     17.35 |
|                        C |                     24,42 |
|                  Nim arc |                     24,55 |
|                     Vala |                     25.07 |
|                   Kotlin |                     26,02 |
|                 Nim refc |                     28,33 |
|                        D |                     31,68 | 

### Versions
|                 Language |                   Time, s |
| :----------------------- | ------------------------: |
|            g++ --version |                       11.1.0 |
|           vala --version |                       0.54.4 |
|            gcc --version |                       11.1.0 |
|          kotlin -version |     1.4.21 (JRE 15.0.1+9-18) |
|            nim --version |                        1.7.1 |
|            ldc --version | DMD v2.098.0 and LLVM 13.0.0 | 

### CPU
