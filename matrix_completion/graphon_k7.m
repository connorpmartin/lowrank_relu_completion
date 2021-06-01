kmax = 7;
d = 2^kmax;
figure(1);clf;
for k = 1:9
    v = randn(d,k); w = randn(d,k);
    Iv = dict_order(v); Iw = dict_order(w);
    
    % ensure that these are indeed permutations
    assert(all(sort(Iv)' == 1:d) && all(sort(Iw)' == 1:d));
    
    subplot(3,3,k);
    imagesc(v(Iv,:)*w(Iw,:)'>=0);
    title("d = " + num2str(d) + ", k = " + num2str(k));
    axis off
end
sgtitle("Each panel shows the matrix v*w', where v,w = randn(d,k). \newlineRows of v is sorted by the dictionary order on sign(v). Same for w.");