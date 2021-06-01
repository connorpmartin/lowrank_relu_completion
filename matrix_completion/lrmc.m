function Y = lrmc(X,Omega)
% Low-rank matrix completion using nuclear norm minimization
% Reference:
% Candès, Emmanuel J., and Benjamin Recht. "Exact matrix completion via convex optimization." Foundations of Computational mathematics 9.6 (2009): 717-772.
% X and Omega are matrices of the same size
% Omega is a 01 matrix (binary mask)
%   The output is the solution to the optimization:
%   min_{Y : shape(Y) = shape(X)} norm_nuc(Y)
%   subject to Y_omega = X_omega
if exist('Y','var')
    clear Y;
end
cvx_begin quiet
    variable Y(size(X,1),size(X,2))
    minimize( norm_nuc(Y) )
    subject to
    Y(Omega) == X(Omega);
cvx_end

end

