%code by Yutong.
close all;
d = 2^10;
id=1;
krange=2:4:40;
lenk=length(krange);
for k = 2:4:40
    v = randn(d,k); w = randn(d,k);
    Iv = dict_order(v); Iw = dict_order(w);
    % ensure that these are indeed permutations
    assert(all(sort(Iv)' == 1:d) && all(sort(Iw)' == 1:d));
    subplot(ceil(lenk/3),3,id);
    imagesc(v(Iv,:)*w(Iw,:)'>=0);
    title("d = " + num2str(d) + ", k = " + num2str(k));
    axis off
    id=id+1;
end
sgtitle("Each panel shows the matrix v*w', where v,w = randn(d,k). \newlineRows of v is sorted by the dictionary order on sign(v). Same for w.");


function idx = dict_order(v)
    % sort the rows of the binary matrix "v>=0"
    % by dictionary order
    k = size(v,2);
    pows_of_two = 2.^((1:k)-1); % the vector [2^0 2^1 ... 2^(k-1)]
    vrow_encoded = (v >= 0)*pows_of_two';
    [~,idx] = sort(vrow_encoded);
end