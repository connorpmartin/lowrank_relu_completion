close all; clear all;

d=100;
n=200;
ranks=[5];
trials=1;
errors = zeros(5, length(ranks), trials);

Msdp1 = cell(length(ranks), trials);
Msdp2 = Msdp1;
Msdp3 = Msdp1;
Msdp4 = Msdp1;
Msdp5 = Msdp1;

Y1 = cell(length(ranks), trials);
Y2 = Y1;
Y3 = Y1;
Y4 = Y1;
Y5 = Y1;

ri = 1;
for r = ranks
    
    for t = 1:trials
        
        U = orth(randn(d,r));
        V = randn(n,r);
        
        X = U*V';
        [ux, sx, vx] = svd(X);
        sx = diag(sx);
        
        % First we do the ReLU MC with non-positivity constraints.
        
        omega = find(X>0);
        Y = zeros(size(X));
        Y(omega) = X(omega);
        omegac = setdiff(1:d*n, omega);
        m = length(omega);
        mc = length(omegac);
        
        cvx_begin sdp
        variable Msdp(d,n)
        minimize (norm_nuc(Msdp))
        subject to
        for j=1:m
            Msdp(omega(j))==Y(omega(j));
        end
        for k=1:mc
            Msdp(omegac(k))<=0;
        end
        cvx_end
        [u,s,v]=svd(Msdp);
        Uhat = u(:,1:r);
        What = s(1:r,1:r)*v(:,1:r)';
        
        errors(1,ri,t) = norm(Uhat*What - X,'fro')/norm(X,'fro');
        Msdp1{ri,t} = Msdp;
        Y1{ri,t} = Y;
        
        save Relu_MC_NN.mat
        
        % Now ReLU MC with no additional constraints beyond measurements.
        
        clear Msdp
        
        cvx_begin sdp
        variable Msdp(d,n)
        minimize (norm_nuc(Msdp))
        subject to
        for j=1:m
            Msdp(omega(j))==Y(omega(j));
        end
        cvx_end
        [u,s,v]=svd(Msdp);
        Uhat = u(:,1:r);
        What = s(1:r,1:r)*v(:,1:r)';
        
        
        errors(2,ri,t) = norm(Uhat*What - X,'fro')/norm(X,'fro');
        Msdp2{ri,t} = Msdp;
        Y2{ri,t} = Y;
        
        save Relu_MC_NN.mat
        
        % Now matrix completion with 30% observations
        
        clear Msdp
        
        m=d*n*.3;
        omega = randsample(1:d*n, m);
        Y = zeros(size(X));
        Y(omega) = X(omega);
        
        cvx_begin sdp
        variable Msdp(d,n)
        minimize (norm_nuc(Msdp))
        subject to
        for j=1:m
            Msdp(omega(j))==Y(omega(j));
        end
        cvx_end
        [u,s,v]=svd(Msdp);
        Uhat = u(:,1:r);
        What = s(1:r,1:r)*v(:,1:r)';
        
        errors(3,ri,t) = norm(Uhat*What - X,'fro')/norm(X,'fro');
        Msdp3{ri,t} = Msdp;
        Y3{ri,t} = Y;
        
        save Relu_MC_NN.mat
        
        % Now matrix completion with 40% observations
        
        clear Msdp omega
        
        m=d*n*.4;
        omega = randsample(1:d*n, m);
        Y = zeros(size(X));
        Y(omega) = X(omega);
        
        
        cvx_begin sdp
        variable Msdp(d,n)
        minimize (norm_nuc(Msdp))
        subject to
        for j=1:m
            Msdp(omega(j))==Y(omega(j));
        end
        cvx_end
        [u,s,v]=svd(Msdp);
        Uhat = u(:,1:r);
        What = s(1:r,1:r)*v(:,1:r)';
        
        errors(4,ri,t) = norm(Uhat*What - X,'fro')/norm(X,'fro');
        Msdp4{ri,t} = Msdp;
        Y4{ri,t} = Y;
        
        save Relu_MC_NN.mat
        
        % Now matrix completion with 50% observations
        
        clear Msdp omega
        
        m=d*n*.5;
        omega = randsample(1:d*n, m);
        Y = zeros(size(X));
        Y(omega) = X(omega);
        
        cvx_begin sdp
        variable Msdp(d,n)
        minimize (norm_nuc(Msdp))
        subject to
        for j=1:m
            Msdp(omega(j))==Y(omega(j));
        end
        cvx_end
        [u,s,v]=svd(Msdp);
        Uhat = u(:,1:r);
        What = s(1:r,1:r)*v(:,1:r)';
        
        
        errors(5,ri,t) = norm(Uhat*What - X,'fro')/norm(X,'fro');
        Msdp5{ri,t} = Msdp;
        Y5{ri,t} = Y;
        
        save Relu_MC_NN.mat
        
    end
    
    ri = ri+1;
end

