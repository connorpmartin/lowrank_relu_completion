

%iterate over rows 



r = 5;
ds = [25,37,50,62,75,87,100,125,150,175,200,225,250,275,300];
% n=200;
n = 100;
% rs = 2:9;
n_ds = length(ds);
n_reps = 5; % number of replicated trials
output = zeros(n_ds, n_reps);



for j = 1:n_reps
for i = 1:n_ds
    tic
    d = ds(i);
    X = randn(d,r)*randn(r,n);

    X_vals = sort(X(:));
    qt = 0.5;
    X_val_thresh = X_vals(floor(qt*numel(X)));

    %disp(X_val_thresh);
    
    Omega = (X >= X_val_thresh);

    tic
    X_comp = lrmc(X,Omega);
    [U,S,V] = svds(X_comp,r);
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

log2op = log2(output);
log10op = log10(output);

Medians = quantile(log10op,0.5,2);
Lower_conf = quantile(log10op,0.2,2);
Upper_conf = quantile(log10op,0.8,2);

Abscissa = ds;

xconf = [Abscissa Abscissa(end:-1:1)] ;         
yconf = [Upper_conf; Lower_conf(end:-1:1)];

p = fill(xconf,yconf,'red');
p.FaceColor = [1 0.8 0.8];      
p.EdgeColor = 'none';           

% hold on
plot(Abscissa,Medians,'red', 'LineWidth',2);

scatter(repmat(Abscissa',size(output,2),1),log10op(:),'ro');
xlabel("Number of Rows");
% ylabel("log_{10}(MSE)");
title("Nuclear norm MC\newline X_{orig} = v*w' where \Omega:" + num2str(qt*100) +"% of the largest entries,\newline v= randn(d,r), n=" +  num2str(n) +" ,r="+r+", w= randn(r,n), d changes");
ylabel("log_{10}(MSE) of recovered entries\newlinemean(vec(X_{orig}[~\Omega] - X_{recov}[~\Omega]).^2)");


legend("20-80% confidence interval","median","a single run");
set(gca, 'FontName', 'Arial');
savefig('ReLUMC_row_change.fig');
save('ReLUMC_row_change.mat');