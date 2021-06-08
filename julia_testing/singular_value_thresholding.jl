#original matrix X, m by n
#mask A, b by m * n (sorta identity)
#A * X[:] -> y, b dimensional vector (b < m * n)
#
#observations: , total data: 
#mask is  by 
function svt(observations::Vector,mask::Matrix,nIters::Integer,thresh = β,stepsize = δ)
    guess = reshape(pinv(mask) * observations,m,n)
    for i in 1:nIters
        
        U,Σ,V = svd(guess)
        Σ = sign.(Σ) * max.(abs.(Σ) - β,0)
        guess = U * Σ * V'

        guess += δ * mask * 
    end
end