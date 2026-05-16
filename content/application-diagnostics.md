# Performance Characterization of applications


## Tools

There is a myriad of tools that can be used 
to study the performance of applications.


```{list-table} Taxonomy of performance analysis techniques}
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
  - [Perf](https://www.brendangregg.com/perf.html),  
    Intel VTune,  
    Julia's Profile
  - Best for initial assessment
* - Profiling  
    (Instrumentation)
  - precise results,  
    overhead needs  
    to be managed
  - score-p/scalasca  
    LIKWID (marker API)  
    Python's cProfile  
    gprof  
    GPU profilers 
  - choose region/functions  
    to observe,  
    estimate overhead  
    from baseline
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

- Profiling

  - Sampling

    - Advantages: lower overhead
    - Disadvantages: lack of precision 

  - Instrumentation

    - Advantages: higher overhead, must be always checked
    - Disadvantages: lack of precision 

  - Tools:
    - Intel
    - NVidia
    - AMD
    - Python's cProfile
    - Julia's Profile
    - [perf](https://www.brendangregg.com/perf.html)
    - Score-p, Scalasca and the whole system of tools ([VI-HPS](https://www.vi-hps.org/))
    - gprof
    - LIKWID

- Tracing
  - Instrumentation

- Performance Counters

- Visualization
  - Flame Graph
  - Tree representations
  - Gantt plots (timeline)
  - Time Series plots

- Performance Modelling and simulation
  - Valgrind
  - Machine Code Analysis
