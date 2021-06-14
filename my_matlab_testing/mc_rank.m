d = 100;
n= 200;
rs = [2,3,5,7,9,12,16,20,24,28,32,36];

n_rs = length(rs);
n_reps = 5; % number of replicated trials
output = zeros(n_rs, n_reps);



for j = 1:n_reps
for i = 1:n_rs
    tic
    r = rs(i);
    X = randn(d,r)*randn(r,n);

    %X_vals = sort(vec(X));
    %qt = 0.5;
    %X_val_thresh = X_vals(floor(qt*numel(X)));
    
    X_val_thresh=0.0; %ReLU MC.
    Omega = (X >= X_val_thresh);

    tic
    X_comp = lrmc(X,Omega);
    [U,S,V] = svds(X_comp,r);
    X_comp = U*S*V';
    t_lrmc = toc;
    
    %mse_missing = mean(vec(X(~Omega)-X_comp(~Omega)).^2);    
    output(i,j) = norm(X_comp - X,'fro')/norm(X,'fro');

    toc
end
end
%%
figure(2);clf;

hold on

log2op = log2(output);
log10op = log10(output);

Medians = quantile(log10op,0.5,2);
Lower_conf = quantile(log10op,0.2,2);
Upper_conf = quantile(log10op,0.8,2);

Abscissa = rs;

xconf = [Abscissa Abscissa(end:-1:1)] ;         
yconf = [Upper_conf; Lower_conf(end:-1:1)];

p = fill(xconf,yconf,'red');
p.FaceColor = [1 0.8 0.8];      
p.EdgeColor = 'none';           

% hold on
plot(Abscissa,Medians,'red', 'LineWidth',2);

scatter(repmat(Abscissa',size(output,2),1),log10op(:),'ro');
xlabel("rank(r)");
% ylabel("log_{10}(MSE)");
title("ReLU MC\newline X_{true} = v*w',\newline, d=" +  num2str(d) +" , n="+n+", r changes");
ylabel("log_{10}(NRMSE) of \hat{X} w.r.t. X_{true}");


legend("20-80% confidence interval","median","a single run");
set(gca, 'FontName', 'Arial');

savefig('ReLUMC_ranks_100x200_2-36.fig');
save('ReLUMC_ranks_100x200_2-36.mat');