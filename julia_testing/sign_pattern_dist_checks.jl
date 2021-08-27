"""
Checking for sign pattern distribution consistency!
If the paper's statement is true, then regardless of the orientation of hyperplanes, the distribution of sign patterns should be exactly the same.

"""
#monte carlo 
rn = 100:25:300
data = zeros(size(rn))
global irtf = 1
for n in rn
    ybig,ycnt = n-25,0
    for y in n-25:1:n
        cnt = 0
        for i in 1:200
            if sum(sum(randn(n,y) * randn(y,n) .> 0,dims=1) .> 75) == n
                cnt += 1
            end
        end
        if cnt > ycnt
            ycnt = cnt
            ybig = y
        end
    end
    data[irtf] = ybig
    global irtf += 1
end
    plot(rn,data)
    savefig("montecarlo.png")