# Performance Characterization of applications


## Tools

There is a myriad of tools that can be used 
to study the performance of applications.


```{list-table} Taxonomy of performance analysis techniques and tools}
:header-rows: 1
:stub-columns: 1

* - Technique
  - Advantages,  
    Disadvantages
  - Tools (examples)
  - Recommendation
* - total runtime/memory  
    measurement
  - very simple,  
    little information
  - `/usr/bin/time`
  - first thing to do
* - Profiling - Sampling
  - low overhead,  
    imprecise results
  - [Perf](https://perfwiki.github.io/main/),  
    gprof,  
    Intel VTune,  
    Julia's Profile
  - Best for initial assessment
* - Profiling  
    (Instrumentation)
  - precise results,  
    overhead needs  
    to be managed
  - [score-p/scalasca](https://www.vi-hps.org/)  
    [LIKWID](https://github.com/RRZE-HPC/likwid/wiki) (marker API)  
    Python's cProfile  
    gprof  
    GPU profilers 
  - choose region/functions  
    to observe,  
    estimate overhead  
    from baseline
* - Simulation
  - Precision, 
    deep understanding,  
    extremely slow
  - valgrind/callgrind,  
    machine code analysis
  - 
* - Tracing
  - show task   
    dependencies,  
    HUGE output 
  - Intel ITAC,  
    Nvidia NSight,  
    BSC Extrae,  
    (Score-p)
  - create *mini app*  
    with short run time
  
    
```


