kmax = 6;
k = 6;
d = 2^kmax;
n = d;

rng(0);

X = randn(d,k)*randn(k,n);


X_vals = sort(vec(X));
qt = 0.5;
X_val_thresh = X_vals(floor(qt*numel(X)));

Omega = (X >= X_val_thresh);

figure(1);clf;
subplot(2,2,1);
imagesc(X);
subplot(2,2,2);
imagesc(Omega);

tic
X_comp = lrmc(X,Omega);
t_lrmc = toc;

tic
X_comp2 = isvt(X,Omega,10*d, 1, 1, 1000);
t_isvt = toc;

subplot(2,2,3);
scatter(X_comp(~Omega), X(~Omega));
title("Runtime of LRMC via CVX " + num2str(t_lrmc));


subplot(2,2,4);
scatter(X_comp2(~Omega), X(~Omega));
title("Runtime of ISVT " + num2str(t_isvt));