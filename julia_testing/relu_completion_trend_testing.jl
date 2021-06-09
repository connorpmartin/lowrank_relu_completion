#sweep over row and column as well as underlying rank
#find limits of rank and dimension experiments
"""
S. Ma, D. Goldfarb and L. Chen, "Fixed point and Bregman iterative methods for matrix rank minimization", 2009.
K. Lee and Y. Bresler, "Admira: Atomic decomposition for minimum rank approximation", 2009.
K. Toh and S. Yun, "An accelerated proximal gradient algorithm for nuclear norm regularized least squares problems", 2009.
J.-F.Cai,E.J.Cande`s,andZ.Shen.Asingularvaluethresholding algorithm for matrix completion. SIAM Journal on Optimization, 20(4):1956–1982, 2008.
"""
#fields institute 
#wed-fri: learning stuff!
#2.5hrs per day paid

#generative model which makes those patterns high probability
#maybe play around with models which specifically create relu-completable matrices?


"""
Learning Linear Dynamical Systems with Hankel Nuclear Norm Regularization

Hankel matrices: skew diagonals are constant

classical: large least squares problems

recently: regularization via Hankel matrices

"n-dimensional exponential / sum-of-exponentials"
via regularization on the rank of the Hankel matrix

sample complexity: presumably the sample size? so like the second dimension of the observed data

we've got a markov system:
x(t+1) = Ax(t) + b
y(t) = cx + d

y is a single observed value dependent on the underlying data x

h = A^{t-1}b


basically x(t) = Ax(t-1) + b ... 
so we have a bunch of summed terms x(t) = h_1 + h_2 + ... + h_n + A^tx(0)
we can think of this as a set of changes h_1, ...., h_n

so the order of the system?? is the rank of the matrix 
rank(H(h_1,...,h_{2n-1}))

here we can basically guess the h_i by introducing a sum matrix U and 

recovery can be gauged via l2 error on the h_i,

or by the spectral distance between the hankel matrices of the h_i
(it's really important to see a gap because it basically means that we're correctly defining the complexity of the system)

they found some cool statistical results 
spectal distance leq sqrt(n/snr*T)
where R is the order, T is the number of observed things
n is the total number of impulses we need to predict?

basically nuclear norm regularization creates sufficiently simple models


understand spectral gap, 


"""