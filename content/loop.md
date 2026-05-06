# The closed loop of performance tuning
Once a way to ascertain the correctness of the code
is available
(preferably *quick* and *automated*),
performance optimization typically proceeds in a loop.

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




