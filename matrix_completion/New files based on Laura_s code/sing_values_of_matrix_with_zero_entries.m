close all;
rng(0);
figure(1);
A = rand(10,10);
A = A - 1.1*min(min(A));
s = svds(A,10);
plot(1:10,s, 'go','MarkerSize',10);
title(["Singular Values for Original Matrix with all entries from";
    "Normal Dist. with Variance = 1 and all non-negative values."]);
figure(2);
i=1;
for t = 1:+10:100
    subplot(2,5,i);    
    ind = randsample(1:100,t);
    A2 = A;
    A2(ind) = 0;
    s = svds(A2,10);
    plot(1:10,s, 'go','MarkerSize',10);
    title(['Positive Entries = ',num2str(100-t),'%']);
    i=i+1;
end
legend("singular values");