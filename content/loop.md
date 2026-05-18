# The closed loop of performance tuning

## Before starting: ensuring correctness 

Performance tuning requires to change 
aspect of the software.
This might unadvertently break it.

````{discussion}

What do you think it is the most practical way
to guarantee that the performance optimization work
does not break the code?

How often would you check?

```{solution} Possible approaches (but let us discuss first)

The more frequent the testing, 
the less the work needed to find the cause of a bug,
but the more the testing overhead.

For this reason, it would be ideal to have tests that:

- do not require manual inspection of the result
  (full automation)
- take very little time to run
- are as comprehensive as possible
- do not take much time to write and maintain

These aspects are obviously in contrast with each other:
a reasonable balance must be struck,
and it is typically down to personal preferences and experience.

In the absence of pre-existing tests,
a common approach 
(typically used to ensure correctness)
is to write [*characterisation tests*](https://en.wikipedia.org/wiki/Characterization_test):

1. save/determine the output of the 
   legacy/reference/original code
   for a given input 
2. use that as an oracle for the optimized code.

Knowledge of the algorithms 
and of their numerical properties
helps with determining
the most important test cases.

Using **version control** is also paramount,
as with any activity related to software development.

```
````




## Performance tuning workflow

Once a way to ascertain the correctness of the code
is available
(preferably *quick* and *automated*),
performance optimization typically proceeds in an iterative fashion.

"Scientific" workflow:

1. Make a falsifiable hypothesis (why is my code slow?)
2. Get data and analyse it, plan code changes (design experiment)
3. Action: implement changes (perform experiment)

Another, more concrete, view of the same approach:


```{list-table} Phases of the Performance Tuning loop 
:widths: 20 40 40
:header-rows: 1


*  - Step 
   - Possible problems 
   - Problem mitigation  
     (discuss)
*  - 1. Measurement 
   - What to measure? 
     And how? 
   - Domain knowledge  
     (which use cases are relevant?)  
     Computer arch. knowledge  
     Performance tool knowledge  
     
*  - 2. Analysis 
   - Performance analysis tools 
     might produce  
     *a lot* of data.  
     What is relevant? 
   - Computer arch. knowledge  
     (Performance tool knowledge)
*  - 3 Generation of   
       Alternatives
   - How to make hypotheses?
   - Computer arch. knowledge  
      
*  - 4. Implementation
   - Is a code change worth it?  
     (complexity vs. performance).  
     Redundancy of optimizations

   - Version Control,  
     Proper architecture,  
     Domain knowledge  
     (definition of  
      relevant use cases)
```


It is also important:

- to keep track of the progress 
  done during the iterations of the performance optimization loop
  and of the information (or lack thereof)
  that have influenced any decision.
  This can be done, for example, 
  with a [logbook](https://github.com/RRZE-HPC/ThePerformanceLogbook/blob/master/Template/logbook.md).
- to strive for performance reproducibility,
  keeping all [sources of performance irreproducibility](./sources-of-irreproducibility.md)
  under control
 


## Porting to accelerators, Parallelization and performance engineering

In order for software to run efficiently 
modern HPC clusters,
typically it needs to be capable of:
- using multiple cores on the same host 
  (shared memory)
- using multiple nodes 
  (distributed memory)
- using accelerators 

Some care must be taken 
when porting code 
to take advantage of HPC hardware:

- node-level performance 
  should be understood 
  and optimized 
  before attempting parallelization
  (it is common that software 
  that performs poorly at the node level
  seems to scale well 
  on multiple nodes).
- Reaching good performance 
  on GPU might require 
  changes not only in the algorithms
  but also in the in the way 
  data is stored in memory 
  (the memory layout). 
  In general, 
  performance engineering
  is an integral part
  of porting software to another 
  hardware architecture.

Moreover: notice that 
the available hardware 
typically changes every few years,
and that the useful life 
of scientific software is typically longer.
Maintenance costs can be reduced
by making use of *performance portability frameworks*.

