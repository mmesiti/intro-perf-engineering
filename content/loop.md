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

In what follows, we try to show this loop 
and 
