using LinearAlgebra: svd
using SparseArrays: sparse
using IterativeSolvers: lsqr
"""
Implementation of Rank 2r iterative least squares ('R2RILS') for
matrix completion [1].
Code by Jonathan Bauch and Boaz Nadler, 2020, cf.
Translation into Julia by anyama
- https://github.com/Jonathan-WIS/R2RILS
- http://www.wisdom.weizmann.ac.il/~nadler/Projects/R2RILS/R2RILS.html
=========================================================================
[1] Jonathan Bauch and Boaz Nadler. Rank 2r iterative least squares: 
efficient recovery of ill-conditioned low rank matrices from few entries, 
preprint, arXiv:2002.01849.
=========================================================================
WRITTEN BY BAUCH & NADLER / 2020

INPUT: 
y = vector of observed entries, X[Ω]
omega = mask matrix
r = target rank of reconstructed matrix
t_max = maximal number of iterations [optional] 
"""

#lsqr precision is ideal

#todo: add sparse matrix support & sparse mask support. convert the u and v steps into a mask
function R2RILS(x::Vector,Ω::BitMatrix,r::Integer;t_max::Integer = 50,ϵ = 1e-15,show=false)
    h,w = size(Ω);   #w,h = number of rows / colums
    nv = length(x); 
    
    #todo: faster way to define this
    Ω_indices = [(i,j) for j in 1:w for i in 1:h][Ω[:]]
    xmax = maximum(abs.(x));   #max absolute value of all observed entries
    
    rhs = zeros(nv);   #vector of visible entries in matrix X
    
    if show
        println("Running R2RILS on $w by $h matrix with $nv observed entries")
    end
    
    #construct observed matrix

    X = zeros(h,w)
    X[Ω] .= x

    # Initialization by rank-r SVD of observed matrix
    U,_,V = svd(X); # U is of size nr x rank; V is of size nc x rank (both column vectors)
    U = U[:,1:r]
    V = V[:,1:r]; 
    
    m = (w + h) * r;  # total number of variables in single update iteration
    
    # Z^T = [a(coordinate 1)  a(coordinate 2) ... a(coordinate nc) | b(coordinate 1) ... b(coordinate nr) ]
    # Z^T = [ Vnew and then Unew ] 
    
    observed_RMSE=zeros(t_max,1); 
    
    X̂_prev = zeros(h,w); 
    
    for loop_idx in 1:t_max
        
        if show
            print("Iteration $(loop_idx)/$(t_max): ")
        end
    
        z = zeros(m,1);    # Z is a long vector with a vectorization of A and of B (notation in paper)
        A = zeros(nv,m);   # matrix of least squares problem 
    
        #CONSTRUCTION OF MATRIX A
        #there must be a way to make this cleaner in julia
        left = @view A[:,1:r*w]
        right = @view A[:,r*w+1:end]
        for i in 1:nv
            j,k = Ω_indices[i]
            row_index= r*(k-1)+1
            col_index = r*(j-1)+1
            left[i,row_index:row_index+r-1] .= U[j,:]
            right[i,col_index:col_index+r-1] .= V[k,:]
        end 
        
        A = sparse(A)

        z = lsqr(A,x)
        
        # construct U and V from the entries of the long vector Z 
        Ũ = zeros(size(U))
        Ṽ = zeros(size(V))

        for i in 1:r
            Ṽ[:,i] .= z[i .+ (0:r:(w*r-r))]
            Ũ[:,i] .= z[r*w .+ i .+ (0:r:(h*r-r))]
        end
       
        X̂ = U * Ṽ' + Ũ * V';   # rank 2r intermediate result

        Ũ /= diagm(vec(mapslices(norm,Ũ,dims=[1]))) #norm weighting
        Ṽ /= diagm(vec(mapslices(norm,Ũ,dims=[1]))) #yes this works
    
        # AVERAGING STEP FOLLOWED BY COLUMN NORMALIZATION
        U += Ũ
        V += Ṽ  
        
        #weight everything again

        U /= diagm(vec(mapslices(norm,U,dims=[1]))) #norm weighting
        V /= diagm(vec(mapslices(norm,U,dims=[1])))
    
        ϵ_current = sqrt(sum((X̂ .- X̂_prev).^2))/sqrt(w*h)
        observed_RMSE[loop_idx] = norm(x - X̂[Ω]) / nv
        println("Norm diff is $(ϵ_current)")
        #EARLY STOPPING
        if ϵ_current < ϵ
            if show
                println("Early stopping")
            end
            return X̂
        end
        X̂_prev = X̂
    end
    return X̂_prev
end