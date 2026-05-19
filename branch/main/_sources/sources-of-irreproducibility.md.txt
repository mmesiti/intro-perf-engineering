# Reproducibility problems in performance measurements

Consistent results in measurements are paramount
to properly inform judgement and action 
when doing performance optimization.

## Common sources of irreproducibility

If you repeat a performance measurement
and you notice an unexpected variation,
consider these aspects:

```{list-table} Non-comprehensive list of sources of irreproducibility, and their mitigations
:header-rows: 1 
:stub-columns: 1

* - Class 
  - Cause 
  - Mitigation/Solution
  - Notes
* - Software
  - Software versions  
    (dependencies)
  - Proper dependency tracking,  
    with pinned  
    (`.lock` files, `Manifest.toml`)  
    under **version control**
  - 
* - 
  - Compiler flags
  - Automation of builds,  
    build scripts under VC 
  - (also for Julia)
* - Hardware 
  - CPU frequency variations
  - `likwid-setFrequencies`,  
    `--cpu-freq` SLURM flag,  
    system monitoring  
    ([CC](https://www.clustercockpit.org/),
    [JM](https://hpc-jobmon.scc.kit.edu)),  
    [MachineState](https://github.com/RRZE-HPC/MachineState)
  - factor of 4 observed
* - 
  - Microcode updates 
  - Track microcode versions  
    (`cat /proc/cpuinfo`)
  - (Rare)
* - Multithreading
  - Thread migration  
    (process migration)
  - [thread/process pinning](https://hpc-wiki.info/hpc/Binding/Pinning)  
    with OMP/MPI  
    ([likwid-pin](https://github.com/RRZE-HPC/likwid/wiki/Likwid-Pin),  
    [ThreadPinning.jl](https://carstenbauer.github.io/ThreadPinning.jl/stable/examples/ex_pinning_julia_threads/#pinthreads))
    
  -
* - 
  - Dynamic thread scheduling
  - Use static scheduling instead  
    (if reasonable) 
  - dynamic scheduling necessary  
    for load balancing (at times)
* - "Noisy Neighbour"
  - node sharing
  - use `--exclusive`  
    `sbatch` allocation
  - 
* - 
  - shared filesystem  
    congestion
  - Isolate, manage  
    and monitor I/O
  - 
* -
  - Network congestion
  - topology control  
    via `sbatch` 
  -
```
