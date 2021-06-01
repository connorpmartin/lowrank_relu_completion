function idx = dict_order(v)
    % sort the rows of the binary matrix "v>=0"
    % by dictionary order
    k = size(v,2);
    pows_of_two = 2.^((1:k)-1); % returns the vector [2^0 2^1 ... 2^(k-1)]'
    vrow_encoded = (v >= 0)*pows_of_two';
    [~,idx] = sort(vrow_encoded);
end

