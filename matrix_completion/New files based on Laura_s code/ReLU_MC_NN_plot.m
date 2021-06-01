% load Relu_MC_NN-04-10-2019.mat

    boxlabels = {'ReLU MC-C','ReLU MC', 'MC 30%', 'MC 40%', 'MC 50%'};


for ri=1:length(ranks)
    
    errorplot = squeeze(log(errors(:,ri,:)))';
    figure
    boxplot(errorplot, 'labels',boxlabels);
    title(['Rank=' num2str(ranks(ri))], 'FontSize',20);
    set(gca,'FontSize',20)
end