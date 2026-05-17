# Introduction to Performance Engineering

Performance engineering is a complex activity,
which is based on existing, fundamental knowledge,
but also requires active investigation.
  
The goal typically is to reduce the consumption of resources
(be it time, compute time or energy - this is getting more and more important)
for a given computational task.


This brief introductory courses aims to:
- give an overview of the knowledge required 
  to do performance engineering work,
  in the spirit of reducing the
  *unknown unknowns* for beginners,
  with a focus on HPC and scientific computing;
- discuss the tools to analyze application behaviour
  in the most common programming languages
  used in HPC in the field of scientific research
  (profiling, tracing);
- give elementary notions of computer architecture, 
  including CPU, memory systems, GPU and Filesystem,
  which sets the maximum performance that can be achieved;
- give a hands-on demonstration of the performance optimization loop.

The choice of topics is based 
on the sources of inspiration (see below)
and on the personal experiences
of the maintainers of this lesson,
with a slight bias - which must be acknowledged and managed - 
towards *interesting* problems.

```{toctree}
---
maxdepth: 1
caption: Episodes
---


loop
application-diagnostics
computer-architecture
notebooks/likwid.ipynb
compilers
sources-of-irreproducibility

```

## Credits

The current course material is inspired by and based on:
- The course [*Introduction to Performance Engineering on HPC*](https://indico.kit.edu/event/3507/)
  by Holger Obermaier and Begatim Bytyqi from KIT 
- The material for [*Node Level Performance Engineering*](https://moodle.nhr.fau.de/course/view.php?id=55) course at HLRS
- The [Algorithmica.org](https://en.algorithmica.org/) book/website by Sergej Slotin


```{toctree}
---
maxdepth: 1
caption: Supplementary Material
---

pointer-chasing-and-latency

```
