%relu_SVs for uniform distributed matrices.
close all; %clear all;

sizelist=[10,50,100,200,300,1000];
r=10;
idx = 1:15;
projnorm=zeros(1,10);

for i=1:length(sizelist)


d=sizelist(i);
n=sizelist(i);
U = orth(randn(d,r));
V = randn(n,r);
X = U*V';

% D = rand(d,r); % from 0 to 1.
% D = D - 1.25*mean(D(:)); % some negative values.
% X =  repmat(D,[1,cast(n/r,'uint8')]);
% [ux, sx, vx] = svd(X);
% sx = diag(sx);

Xrelu = max(X,0);
Omega = (Xrelu>0);
% [uxr, sxr, vxr] = svd(Xrelu);
% sxr = diag(sxr);

figure(1);
subplot(2,3,i);
imshow(Omega);
% plot(idx, sx(idx), 'rx','MarkerSize',10);
hold on;
% plot(idx,sxr(idx), 'go','MarkerSize',10)
title(['size=',num2str(n),', rank=',num2str(r)],'FontSize',12);

% figure(2);
% subplot(2,5,r);
% histogram(X(:));
% title(['rank=' num2str(r)],'FontSize',20);
% Uest = uxr(:,1:r+1);
% projnorm(r) = norm(U - Uest*Uest'*U,'fro');

% fprintf("rank = %d, elements through ReLU (%%) = %0.1f \n",rank(X),100*length(find(Xrelu~=0))/(size(Xrelu,1)*size(Xrelu,2)));
end
figure(1);
% legend('singular values','singular values after ReLU','FontSize',8)
% 
% figure
% plot(projnorm)
