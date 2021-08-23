"""
Checking for sign pattern distribution consistency!
If the paper's statement is true, then regardless of the orientation of hyperplanes, the distribution of sign patterns should be exactly the same.

"""

#monte carlo 

    A = randn(40,10) * randn(10,40)
    counta += any(.!(sum(A .> 0,dims=1) > 10))
d