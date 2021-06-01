%% This file performs quantile variation experiment.
% Keep dimensions, rank fixed, change % quantile of largest entries being observed in a matrix.

clear all;

% ReLU 100x200 quantile variation experiment.

%vary over percent removal

d = 100;
n=200;
r = 8;

%what're these used for?
qt = d*n;%total
q1 = d*r+n*r-50;
q2 = d*r+n*r+10;
q3 = int32(d*log2(d));
q4 = int32(n*log2(n));

qs = [2,4,9,12,15,20,30,35,45,50,51,60,70];
n_qs = length(qs);
n_reps = 4; % number of replicated trials
output = zeros(n_qs, n_reps);



for j = 1:n_reps
for i = 1:n_qs
    tic
    %r = rs(i);
    
    X = randn(d,r)*randn(r,n);
    
    X_vals = sort(vec(X),'descend');
    q = qs(i);%qt = 0.5;
    X_val_thresh = X_vals(floor(q*numel(X)/100));    
    
    Omega = (X >= X_val_thresh);%X_val_thresh=0.0; %ReLU MC.

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
figure(10);clf;

hold on

log2op = log2(output);
log10op = log10(output);

Medians = quantile(log10op,0.5,2);
Lower_conf = quantile(log10op,0.2,2);
Upper_conf = quantile(log10op,0.8,2);

Abscissa = qs;

xconf = [Abscissa Abscissa(end:-1:1)] ;         
yconf = [Upper_conf; Lower_conf(end:-1:1)];

p = fill(xconf,yconf,'red');
p.FaceColor = [1 0.8 0.8];      
p.EdgeColor = 'none';           

% hold on
plot(Abscissa,Medians,'red', 'LineWidth',2);

scatter(repmat(Abscissa',size(output,2),1),log10op(:),'ro');
xlabel("Quantile (% largest entries observed)");
% ylabel("log_{10}(MSE)");
title("Quantile MC Error\newline X_{true} = v*w', d=" +  num2str(d) +" , n="+n+",r="+num2str(r))%+"\newline NRMSE vs. % quantile observed");
ylabel("log_{10}(NRMSE) of {X}^\^ w.r.t. X_{true}");


legend("20-80% confidence interval","median","a single run");
set(gca, 'FontName', 'Arial');

savefig('QuantileMC_100x200_rank8.fig');
save('QuantileMC_100x200_rank8.mat');










