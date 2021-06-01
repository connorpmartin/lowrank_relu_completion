%%
% This file performs two experiments, each experiment has its own code.
% 1.  Keep number of rows, rank fixed, change number of columns, ReLU mask.
% 2.  Keep dimensions fixed, change rank, ReLU mask.

% Use MOSEK solver to do very fast MC experiments. Download MOSEK solver from official website, 
% get an academic license using UMich account, add path to its bin folder in MATLAB PATH collection,
% run this command: mosekdiag
% then, run this command: cvx_setup so that cvx recognises this new solver.

% cvx_solver mosek_3 % set solver for one session
% cvx_save_prefs % save settings for future sessions.


%%
clear all;close all;

% ReLU 200x{50-400} column variation experiment. 

r = 5;
d = 200;
% n=200;
ns = [50,150,200,250,300];
% rs = 2:9;
n_ns = length(ns);
n_reps = 10; % number of replicated trials
output = zeros(n_ns, n_reps);



for j = 1:n_reps
for i = 1:n_ns
    tic
    n = ns(i);
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
figure(1);clf;

hold on

log2op = log2(output);
log10op = log10(output);

Medians = quantile(log10op,0.5,2);
Lower_conf = quantile(log10op,0.2,2);
Upper_conf = quantile(log10op,0.8,2);

Abscissa = ns;

xconf = [Abscissa Abscissa(end:-1:1)] ;         
yconf = [Upper_conf; Lower_conf(end:-1:1)];

p = fill(xconf,yconf,'red');
p.FaceColor = [1 0.8 0.8];      
p.EdgeColor = 'none';           

% hold on
plot(Abscissa,Medians,'red', 'LineWidth',2);

scatter(repmat(Abscissa',size(output,2),1),log10op(:),'ro');
xlabel("Number of Columns");
% ylabel("log_{10}(MSE)");
title("ReLU MC\newline X_{true} = v*w',\newline, d=" +  num2str(d) +" , r="+r+", n changes");
ylabel("log_{10}(NRMSE) of \hat{X} w.r.t. X_{true}");


legend("20-80% confidence interval","median","a single run");
set(gca, 'FontName', 'Arial');

savefig('ReLUMC_columns_50-500_rank5.fig');
save('ReLUMC_columns_50-500_rank5.mat');


%%

clear all;

% ReLU 100x200 rank variation experiment.


d = 100;
n=200;
rs = [2,3,5,7,9,12,16,20,24,28,32,36];

n_rs = length(rs);
n_reps = 15; % number of replicated trials
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










