d = 2^10;
for k = 2:10
    v = randn(d,k); w = randn(d,k);
    Iv = dict_order(v); Iw = dict_order(w);
    
    % ensure that these are indeed permutations
    assert(all(sort(Iv)' == 1:d) && all(sort(Iw)' == 1:d));
    
    subplot(3,3,k-1);
    imagesc(v(Iv,:)*w(Iw,:)'>=0);
    title("d = " + num2str(d) + ", k = " + num2str(k));
    axis off
end
sgtitle("Each panel shows the matrix v*w', where v,w = randn(d,k). \newlineRows of v is sorted by the dictionary order on sign(v). Same for w.");