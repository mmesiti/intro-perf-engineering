# What a compiler (and the hardware) can do for you

## Compiler as magicians
With the right flags, compilers can do automatically:

- common subexpression elimination
- Loop unrolling
- Loop reordering
- Auto vectorization
- Some compilers (i.e., Intel) also 
  can auto-parallelize loops using shared-memory parallelization. 

Note: Some advanced optimization options 
can actually change subtly 
the actual behaviour of the code.

### Common optimizations enabled via flags 

- Generation of machine instructions
  for a specific architecture. 
 
- `-Olevel`: Different optimization levels "meta" options,
  typically corresponding to a set of flags 
  for specific optimizations.
  Higher levels typically include all the optimization flags
  included lower levels, plus more.
  
  Higher optimization levels 
  tend to:
  - offer higher performance binaries
    (even by orders of magnitude),
  - increase the compilation times.
  - remove checks and debugging information

  For this reason, consider:
  - For testing during your usual development loop, use `-O0`
  - For debugging, use `-Og` (if available)
  - For performance: use `-O2`/`-O3` or `-Ofast`

  ````{exercise} Compilation options: RTFM
  
  Familiarize yourself with the manual of the GNU 
  and Intel compiler,
  with 
     ```bash
     man gcc
     ```
     for the GNU C compiler, and 
     ```bash
     man icx
     ```
     for the Intel C compiler.
     
     If you are doing this on a HPC system,
     you might need to load the appropriate modules
     to make the manpages for the compilers available.
     
     What are the default optimization options in both cases?
  
  ````
  Note: different compilers have 
  different default values of `-Olevel`, 
  some defaulting to `-O0`, some to `-O2`.
  
- "fast math" optimization options: these allow the compiler 
  to use versions of the math functions 
  that do not have to comply to standard, and thus could be faster. 
  


### How to help a compiler

There are some modifications 
that might help a compiler
produce better assembly code.

- Avoid pointer hopping and indirect addressing
  (this requirement, in higher level languages,
  also translates in avoiding dynamic typing 
  in some situations)
- Loop unrolling 
  (this can be done automatically by modern compilers)

  
  
### Automatic vectorization

Vectorized instructions represent 
one of the most important ways to get high performance
from modern CPUs.

- Use an appropriate memory layout. 
  Going from an *Array of Structures* (AoS)
  to a *Structure of Array* (SoA) layout
  might help. 
  Reads and writes must be done in 128/256/512 bit chunks.

- Avoid complex logic in loops that could be vectorized,
  in particular: 
  - conditionals (e.g., `if` statements)
  - calls to non-trivial functions that cannot be inlined.

To verify the result of the vectorization,
there are a few options
1. Get the assembly output either by
   - running `objdump -d` on the object file produced (can work also with the final linked binary, but might be way larger)
   - compile the source file with the `-s` option 
2. Get the information from the compiler in the form of a vectorization report (`-fopt-info-vec` for GNU, `-qopt-report=max` for Intel's icx/icxx compiler).

## The role of hardware

Once the compiler has produced the assembly instructions,
the 

Each assembly instruction still needs to be decoded
into a number of more fundamental instructions.
This is done by the hardware.
Most assembly instructions on a x86 architecture
do take more than one cycle to complete,
but multiple instructions 
can be executed at the same time
thanks to the superscalar architecture 
of modern CPUs,
so they are executed in a *pipeline*.

Pipelines can get stalled in different ways,
for example:
- when waiting for data to arrive. In that case, typically simultaneous multithreading can be used efficiently to mask these latencies 
- in a conditional statement, the evaluation of the condition might delay the execution of the dependent instructions. The hardware typically tries to compensate with branch prediction and speculative execution.  
