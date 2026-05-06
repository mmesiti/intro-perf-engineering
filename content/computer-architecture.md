# Elements of Computer Architecture and their effects

Compute balance: Raw compute power is cheap, memory bandwidth is not.
This is why most HPC workloads are memory bound.

## Tools for system investigation

To understand what are the limits of the system 
we are working on,
we can use some predefined benchmarks to assess the performance of the system.

- [likwid-topology](https://github.com/RRZE-HPC/likwid/wiki/likwid-topology)
- [likwid-bench](https://github.com/RRZE-HPC/likwid/wiki/Likwid-Bench): 
  suite of tunable micro benchmarks for CPU and main memory
- [fio](https://github.com/axboe/fio) for IO benchmarks and tests
- [OSU Micro Benchmarks](https://mvapich.cse.ohio-state.edu/benchmarks/): suite of micro benchmarks for different types of MPI communication


## Trade-offs 
- Memory: Size vs Speed and latency. 

  | System | Bandwidth | Latency | Size  | Notes |
  |--------|-----------|---------|-------|-------|
  | Registers |         |  < 1cy  | 1KB| per core |
  | L1 cache |         |  ~1ns   | 32KB  | per core |
  | L2 cache |         |  ~4ns   |512KB | per core/tile |
  | L3 cache |         |  ~16ns       | 50MB   | per package, shared|
  | HBM      | 2-8TB/s |         | 64GB    | per package|
  | Main Memory | 50-250GB/s     |  ~100ns(*)    | 200GB   | per node    |
  | Network (IB) | <100GB/s |         |  -   |     |
  | Local SDD     |  ~1GB/s     |         | ~1TB      |     |
  | Global Filesystem |  ~50GB/s     |         |  ~PBs      |     |

  The numbers in this table must be intended only as 
  **order of magnitude**.
  
  With `likwid-topology` and `likwid-bench` we can get 
  more precise values or better estimates.

  **Challenge:**
  What if our data structures do not fit in memory/storage system X? 
  

  - Memory granularity:
    - Registers (there's only a handful of them unfortunately)
    - Cache line (64B on most CPUs, 64B-128B on GPUs)
    - Memory Pages: >4MB 

## Parallelism in the core: Vectorization and superscalarity

CPUs can do more things at the same time
in two ways:
- Vectorization (SIMD, Single Instruction Multiple Data).
- Superscalarity and pipelining (TODO: define)

  Note: Vector operations have typically higher bandwidth 
  (verify with `likwid-bench`).
  

## Caches 

 - Data is moved between cache levels 
   and between caches and the RAM
   only in "chunks" of 64Bytes 
   (the size of a *cache line*).
   
   This means that if we use only a single value 
   out of a 64B cache line,
   we will potentially trash a lot of data.
   
 - Cache is typically not fully associative:
   not all 64B chunks of the main memory 
   can be "mirrored" in all cache lines,
   but typically each of them can only fit 
   in a specific "cache line group".
   
   Some access patterns can lead to poor cache utilization
   due to cache associativity.

 - Cache levels can also be inclusive, esclusive or neither
   ([cache inclusion policy](https://en.wikipedia.org/wiki/Cache_inclusion_policy)).
   
 - When working with multiple threads,
   be aware that different threads working on different cores
   accessing the same data might "fight" 
   over a single cache line,
   as the hardware is forced to give a consistent view
   of the data to both threads.
   In that situation, called *false sharing*,
   the workload becomes latency-bound.
   
   
## Main memory: Non-Uniform-Memory-Access



## Simple performance modelling: the roofline model

## Recommendations

- **Ensuring Data reuse is paramount**:
  - use as much data as possible out of every cache line
    before it is evicted 
    (split "hot" and "cold" data between different memory)
  - reuse as much as possible data that has been read or written 
    shortly before
    
  
    

## References

- [Infiniband max Bandwidth](https://www.infinibandta.org/ibta-specification/)
- [Algorithmica: Algorithms for Modern Hardware](https://en.algorithmica.org/hpc/cpu-cache/associativity/)
- [What every programmer should know about memory](https://people.freebsd.org/~lstewart/articles/cpumemory.pdf)
