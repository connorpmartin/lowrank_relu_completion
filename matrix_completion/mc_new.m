%cvx_solver mosek_3 %one session
%cvx_save_prefs %save settings.

%plots mse of rank constraint on basic lrmc recovery of thresholded low-rank matrices.


kmax = 5;
d = 100;
n=200;
ks = 2:9;
n_ks = length(ks);
n_reps = 1; % number of replicated trials
output = zeros(n_ks, n_reps);



for j = 1:n_reps
for i = 1:n_ks
    tic
    k = ks(i);
    X = randn(d,k)*randn(k,n);

    X_vals = sort(vec(X));
    qt = 0.5;
    X_val_thresh = X_vals(floor(qt*numel(X)));

    X_val_thresh
    Omega = (X >= X_val_thresh);

    tic
    X_comp = lrmc(X,Omega);
    [U,S,V] = svds(X_comp,k);
    X_comp = U*S*V';
    t_lrmc = toc;
    
    mse_missing = mean(vec(X(~Omega)-X_comp(~Omega)).^2);
    output(i,j) = mse_missing;

    toc
end
end
%%
% output = output(1:7,1:5);
figure(1);clf;

hold on


log2op = log2(output);
log10op = log10(output);

Medians = quantile(log10op,0.5,2);
Lower_conf = quantile(log10op,0.2,2);
Upper_conf = quantile(log10op,0.8,2);

Abscissa = ks;%(1:7);

xconf = [Abscissa Abscissa(end:-1:1)] ;         
yconf = [Upper_conf; Lower_conf(end:-1:1)];

p = fill(xconf,yconf,'red');
p.FaceColor = [1 0.8 0.8];      
p.EdgeColor = 'none';           

% hold on
plot(Abscissa,Medians,'red', 'LineWidth',2);

scatter(repmat(Abscissa',size(output,2),1),log10op(:),'ro');
xlabel("k")
title("Nuclear norm MC\newline X_{orig} = v*w' where \Omega: " + num2str(qt*100) +"% of the largest entries,\newline v=randn(d,k), d=" +  num2str(d) +", w=randn(n,k), n="+  num2str(n) +", k="+min(ks)+",...,"+(max(ks)));
ylabel("log_{10}(MSE) of recovered entries\newlinemean(vec(X_{orig}[~\Omega] - X_{recov}[~\Omega]).^2)");


legend("20-80% confidence interval","median","a single run");
set(gca, 'FontName', 'Arial');
