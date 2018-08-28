function [p_value,random_distribution_means]=dependent_samples_permutation_test(group1,group2,visualize,onesided)
% This functio  will perform a permutation test for dependent samples
% means.
% Input may be: 1 vector of the two group differences, or the two groups.

% for replicability
rng(1)

if ~exist('group1','var')
    error('An input data must be supplied');
end

% If only one group is provided, that group is assumed to be differences
if exist('group2','var')&&~isempty(group2)
    try
        differences=group1-group2;
    catch
        % make sure both groups are of equal size
        error('the two groups must be paired and of equal size')
    end
else
    differences=group1;
end

if ~exist('onesided','var')
    onesided=false;
end

if ~exist('visualize','var')
    visualize=true;
end

my_mean=mean(differences);
random_sample_n=100000;
[N,is_col_vec]=size(differences);
if is_col_vec~=1
    % if data is in row vector, transform into a col vector
    if N==1
        differences=differences';
        [N,~]=size(differences);
        % if differences are not a vector
    else
        error('Data must be a vector of differences, or two vectors of equal length')
    end
end

% randomly flip signs
random_sample_mat=sign(1-2*rand(random_sample_n,N));
% calculate mean as sum/N
random_distribution_means=random_sample_mat*differences/N;
% calculate p-value as number of means more extreme than my_mean
p_value_onesided=min([sum(random_distribution_means<my_mean),sum(random_distribution_means>my_mean)]/random_sample_n);

if onesided
    p_value=p_value_onesided;
else
    p_value=p_value_onesided*2;
end

if visualize
    figure
    histogram(random_distribution_means);
    hold on
    plot([my_mean,my_mean],ylim,'r--')
    hold off
end

end
