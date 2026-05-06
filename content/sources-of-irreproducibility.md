# Reproducibility problems in performance measurements

Consistent results in measurements are paramount
to properly inform judgement and action 
when doing performance optimization.

## Common sources of irreproducibility

If you repeat a performance measurement
and you notice an unexpected variation,
consider these aspects:

- Software-related:
  - Different versions might be used in the software stack.
    Versions of the compiler and of the libraries used 
    might have 
  - **Optimization flags**: for compiled languages (including Julia) 
- System-related:

  System-level monitoring is of great help
  in detecting some issues.

  - CPU Frequencies might vary by a factor of ~4. 
    We can mitigate that with `likwid-setFrequencies` 
    or with sbatch option `--cpu-freq` on a HPC system.
  - Multithreading context:

    - Thread migration. The operating system might move a thread to another core. With *thread pinning*, we avoid that problem.
    - Dynamic thread scheduling: 
      while dynamic scheduling might be very useful 
      for load balancing, 
      it can also lead to random variability 
      in performance measurements.

  - "Noisy Neighbour" problems: are other processes/jobs which we do not control sharing the same resources?

    - Is any other process running on the same compute node?
    - How "busy" is the fabric? 
    - For I/O heavy workloads, 
      if our job is interacting with a global filesystem,
      since other jobs are sharing it,
      performance measurements can be affected.



