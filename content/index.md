# Introduction to Performance Engineering

Performance engineering is a complex activity,
which is based on a lot of knowledge 
but also requires active investigation.
  
The goal typically is to reduce the consumption of resources
(be it time, compute time or energy - this is getting more and more important)
for a given computational task.



This brief introductory courses aims to:
- give an overview of the knowledge required 
  to do performance engineering work,
  in the spirit of reducing the
  *unknown unknowns* for beginners.
- discuss the tools to analyze application behaviour
  in the most common programming languages
  used in HPC in the field of scientific research
  (profiling, tracing)
- give elementary notions of computer architecture, 
  including CPU, memory systems, GPU and Filesystem,
  which sets the maximum performance limits
- give a hands on demonstration of the performance optimization loop


## The closed loop of performance tuning

"Scientific" workflow:

1. Make a falsifiable hypothesis
2. Get data and analyse it plan code changes (design experiment)
3. Action: implement changes (perform experiment)

Another more concrete view:

1. Measurement 
   - What to measure? 
2. Analysis 
   - Performance analysis tools might produce *a lot* of data.
     what is relevant? 
3. Generation of Alternatives
   - How to make hypotheses?
4. Implementation
   - how to decide if a code change is worth it? (Trade-off between complexity and performance).
   - What if a new optimization makes an optimization of previous cycles redundant/unnecessary?




```{toctree}
:maxdepth 1

application-diagnostics.md
computer-architecture.md
compilers.md
sources-of-irreproducibility.md

```

## Credits

The current course is based on 
