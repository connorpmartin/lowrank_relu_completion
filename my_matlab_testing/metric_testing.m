%generate a bunch of random matrices and try to find a trend with rmse with various
%metrics

d = 100;
n= 200;
r = 5;

niters = 100;
rmse = zeros(niters);
metric = zeros(niters);



for j = 1:niters
    tic
    X = randn(d,r);
    [X,~] = qr(X);
    
    metric(j) = row_angle_metric(X);
    
    X = X * randn(r,n);
    
    X_val_thresh=0.0; %ReLU MC.
    Omega = (X >= X_val_thresh);

    tic
    X_comp = lrmc(X,Omega);
    [U,S,V] = svds(X_comp,r);
    X_comp = U*S*V';
    t_lrmc = toc;
    
    %mse_missing = mean(vec(X(~Omega)-X_comp(~Omega)).^2);    
    rmse(j) = norm(X_comp - X,'fro')/norm(X,'fro');

    toc
end
%%
figure(2);clf;

hold on

log2op = log2(rmse);
log10op = log10(rmse);

scatter(metric,log10op,'ro');
xlabel("metric on rows");
% ylabel("log_{10}(MSE)");
title("ReLU MC\newline X_{true} = v*w',\newline, d=" +  num2str(d) +" , n="+num2str(n));
ylabel("log_{10}(NRMSE) of \hat{X} w.r.t. X_{true}");


set(gca, 'FontName', 'Arial');

savefig('metric.fig');
save('metric.mat');