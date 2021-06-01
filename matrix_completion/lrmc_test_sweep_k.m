kmax = 5;
d = 2^kmax;

ks = 2:9;
n_ks = length(ks);
n_reps = 5; % number of replicates
output = zeros(n_ks, n_reps);



for j = 1:n_reps
for i = 1:n_ks
    tic
    k = ks(i);
    X = randn(d,k)*randn(k,d);

    X_vals = sort(vec(X));
    qt = 0.5;
    X_val_thresh = X_vals(floor(qt*numel(X)));

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
figure(1);clf;

hold on


Medians = quantile(output,0.5,2);
Lower_conf = quantile(output,0.2,2);
Upper_conf = quantile(output,0.8,2);

Abscissa = ks;

xconf = [Abscissa Abscissa(end:-1:1)] ;         
yconf = [Upper_conf; Lower_conf(end:-1:1)];

p = fill(xconf,yconf,'red');
p.FaceColor = [1 0.8 0.8];      
p.EdgeColor = 'none';           

% hold on
plot(Abscissa,Medians,'red', 'LineWidth',2);

scatter(repmat(Abscissa',size(output,2),1),output(:),'ro');
xlabel("k")
title("Nuclear norm matrix completion\newline X_{orig} = v*w' where Ω= " + num2str(qt*100) +"% of the largest entries,\newlinev,w = randn(d,k),d = " +  num2str(d) +" , k = "+min(ks)+",...,"+max(ks));
ylabel("MSE of recovered entries\newlinemean(vec(X_{orig}[~\Omega] - X_{recov}[~\Omega]).^2)");


legend("20-80% confidence interval","median","a single run");
set(gca, 'FontName', 'Arial');
