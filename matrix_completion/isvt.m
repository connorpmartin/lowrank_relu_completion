function X = isvt(M,Omega,tau,delta, decfac,niter)
% Iterated Singular Value Thresholding algorithm

% MATLAB reimplementation of
% https://www.convexoptimization.com/wikimization/index.php/Matrix_Completion.m

% It would be good to implement ADMM or Nestorov accelerated version of
% this.
%
% See here:
% https://web.eecs.umich.edu/~fessler/course/551/julia/demo/09_lr_complete3.html
    
    Y = Omega.*M;
    for i = 1:niter
        [U,S,V] = svd(Y);
        s = SoftTh(diag(S),tau);
        S = diag(s);
        
        Y = Y + delta*(Omega.*(M-U*S*V'));
        delta = decfac*delta;
    end
    X = U*S*V';
end


function  z = SoftTh(s,thld)
    z = sign(s).*max(0,abs(s)-thld); 
end