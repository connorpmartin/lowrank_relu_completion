e = randn(15,5)
r = randn(5,10000)

sum(sum(e * r .> 0,dims=1) .< 5)