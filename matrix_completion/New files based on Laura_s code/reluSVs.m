close all; clear all;

d=100;
n=200;

idx = 1:15;
projnorm=zeros(1,10);

for r=1:10

U = orth(randn(d,r));
V = randn(n,r);

X = U*V';
[ux, sx, vx] = svd(X);
sx = diag(sx);

Xrelu = max(X,0);
[uxr, sxr, vxr] = svd(Xrelu);
sxr = diag(sxr);

subplot(2,5,r);
plot(idx, sx(idx), 'rx','MarkerSize',10);
hold on;
plot(idx,sxr(idx), 'go','MarkerSize',10)
title(['rank=' num2str(r)],'FontSize',20);


% Uest = uxr(:,1:r+1);
% projnorm(r) = norm(U - Uest*Uest'*U,'fro');

end
legend('singular values','singular values after ReLU','FontSize',20)
% 
% figure
% plot(projnorm)
