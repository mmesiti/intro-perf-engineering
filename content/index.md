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



```{toctree}
:maxdepth 1

loop.md
application-diagnostics.md
computer-architecture.md
compilers.md
sources-of-irreproducibility.md

```

## Credits

The current course material is inspired by and based on:
- The course [*Introduction to Performance Engineering on HPC*](https://indico.kit.edu/event/3507/)
  by Holger Obermaier and Begatim Bytyqi from KIT 
- The [*Node Level Performance Engineering*]
