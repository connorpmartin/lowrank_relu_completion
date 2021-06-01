k = 2;
d = 2^10;

v = randn(d,k); w = randn(d,k);
Iv = dict_order(v); Iw = dict_order(w);

% ensure that these are indeed permutations
assert(all(sort(Iv)' == 1:d) && all(sort(Iw)' == 1:d));

figure(1);clf;
imagesc(v(Iv,:)*w(Iw,:)'>=0);
title("d = " + num2str(d) + ", k = " + num2str(k));