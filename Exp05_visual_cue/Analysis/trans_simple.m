
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Intransivity analysis for snacks and faces sessions based on pairwise comparison and BDM results
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
%Step 0 - Preparations for intransitivity analysis
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

%Getting basic data for further calculations
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
clear all;

path='./../'; % Fill the path where the Dropbox folder is located
experiment_name=input('Please enter experiment name', 's');
num_of_sub=input('Please enter the number of subjects who participated in the experiment', 's');
subjects_code=input('Please enter subjects` general code. i.e. "snf"', 's');
assignment_type=input('Please enter the assignment type (ItemRankingResults/BDM/ItemRankingResults and BDM)', 's');
session_type=input('Please enter the session type (Snacks/Faces/Snacks and Faces)', 's');
num_of_stim=input('Please enter the number of stimuli (per snacks/faces)');
threshold_for_cutoff=0;

flag=initiation(assignment_type, session_type);

%Preparing cell array for exporting final data
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
final_data_array_parameters=cell(length(flag)*str2double(num_of_sub), 12);

final_data_array_stimuli=repmat({'---'}, num_of_stim*str2double(num_of_sub)+4*str2double(num_of_sub)-1, 24);

final_data_array_stimuli{1,7}='Faces';
%----------------------------------------
final_data_array_stimuli{1,19}='Snacks';


final_data_array_stimuli{2,3}='To remove stimuli by max intransiant violations';
final_data_array_stimuli{2,7}='To remove stimuli by max intransiant values';
final_data_array_stimuli{2,11}='To remove stimuli by max intransiant rankings';
%---------------------------------------------------------------
final_data_array_stimuli{2,15}='To remove stimuli by max intransiant violations';
final_data_array_stimuli{2,19}='To remove stimuli by max intransiant values';
final_data_array_stimuli{2,23}='To remove stimuli by max intransiant rankings';


final_data_array_stimuli{3,2}='Trans Stim';
final_data_array_stimuli{3,3}='Intrans Stim';
final_data_array_stimuli{3,4}='Bad luck';
%-----------------------------------------------
final_data_array_stimuli{3,6}='Trans Stim';
final_data_array_stimuli{3,7}='Intrans Stim';
final_data_array_stimuli{3,8}='Bad luck';
%-----------------------------------------------
final_data_array_stimuli{3,10}='Trans Stim';
final_data_array_stimuli{3,11}='Intrans Stim';
final_data_array_stimuli{3,12}='Bad luck';
%-----------------------------------------------------------------------
final_data_array_stimuli{3,14}='Trans Stim';
final_data_array_stimuli{3,15}='Intrans Stim';
final_data_array_stimuli{3,16}='Bad luck';
%-----------------------------------------------
final_data_array_stimuli{3,18}='Trans Stim';
final_data_array_stimuli{3,19}='Intrans Stim';
final_data_array_stimuli{3,20}='Bad luck';
%-----------------------------------------------
final_data_array_stimuli{3,22}='Trans Stim';
final_data_array_stimuli{3,23}='Intrans Stim';
final_data_array_stimuli{3,24}='Bad luck';

values_for_cutoff_item_ranking_snacks=[];
values_for_cutoff_item_ranking_faces=[];
values_for_cutoff_BDM_snacks=[];
values_for_cutoff_BDM_faces=[];

colley_values_snacks=zeros(num_of_stim,str2double(num_of_sub));
colley_values_faces=zeros(num_of_stim,str2double(num_of_sub));

%Chronological procedure for intransitivity analysis
%------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
for k=1:str2double(num_of_sub)
    if k<10
        subject_ID=([subjects_code, '_10', num2str(k)]);
    else subject_ID=([subjects_code, '_1', num2str(k)]);
    end
    
    for j=1:1:length(flag)
        if flag(j) <= 1
            session_type='snacks';
        else session_type='faces';
        end
        if flag(j)==0 || flag(j)==2
            assignment_type='ItemRankingResults';
        else   assignment_type='BDM';
        end
        
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %Step 1 - Extracting data about subject's ranking
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
        di_1=dir([path, 'Output/', subject_ID, '_', assignment_type, '*']);
        f_1=fopen([path, 'Output/', di_1.name]);
        
        %Calculating Conversion vec for colley ranking
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        if  strcmp(assignment_type,'ItemRankingResults')==1
            data_1=textscan(f_1, '%s');
            data_1_vec=data_1{1};
            data_1_array=cell(num_of_stim,2);
            for i=1:num_of_stim
                data_1_array{i,1}=data_1_vec{9+(i-1)*7};
                data_1_array{i,2}=data_1_vec{11+(i-1)*7};
            end
            ranking_values_vec=str2double(data_1_array(:,2));
            [sorted_ranking_values,conversion_vec]=sort(ranking_values_vec,'descend'); %Conversion vec: values represent stimuli identities (i.e.- "Apropo" equals 1, "BabyDoll" equals 2, etc..), indexes of values represent snacks'/faces' rankings
            
            if flag(j)==0
                colley_values_snacks(1:end,k)=ranking_values_vec;
            else colley_values_faces(1:end,k)=ranking_values_vec;
            end
            
            %Calculating Conversion vec for BDM ranking
            %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        else data_1=textscan(f_1, '%s');
            data_1_vec=data_1{1};
            data_1_array=cell(num_of_stim,2);
            for i=1:num_of_stim
                data_1_array{i,1}=data_1_vec{6+(i-1)*4};
                data_1_array{i,2}=data_1_vec{7+(i-1)*4};
            end
            data_1_array=sortrows(data_1_array);
            ranking_values_vec=str2double(data_1_array(:,2));
            [sorted_ranking_values,conversion_vec]=sort(ranking_values_vec,'descend'); %Conversion vec: values represent stimuli identities (i.e.- "Apropo" equals 1, "BabyDoll" equals 2, etc..), indexes of values represent snacks'/faces' rankings
        end
        
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %Step 2 - Extracting data about subject's pairwise comparisons results
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
        di_2=dir([path, 'Output/', subject_ID, '_binary_ranking*.txt']);
        f_2=fopen([path, 'Output/', di_2.name]);
        data_2=textscan(f_2, '%s');
        data_2_vec=data_2{1};
        num_of_com=((length(data_2_vec)-20)/10+1);
        data_2_array=cell(3,num_of_com);
        for i=1:num_of_com
            data_2_array{1,i}=data_2_vec{16+(i-1)*10};
            data_2_array{2,i}=data_2_vec{17+(i-1)*10};
            data_2_array{3,i}=data_2_vec{18+(i-1)*10};
        end
        pcr_array=data_2_array; %pcr - pairwise comparisons results
        
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %Step 3 - Organizing subject's pairwise comparisons results
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
        for i=3:3:3*num_of_com
            if data_2_array{i}=='i'
                pcr_array{i-2}=data_2_array{i-1};
                pcr_array{i-1}=data_2_array{i-2};
            elseif data_2_array{i}=='x'
                pcr_array(i-2)={0};
                pcr_array(i-1)={0};
            end
        end
        
        pcr_mat=str2double(pcr_array);
        w_l_vec=pcr_mat(pcr_mat>0);
        num_of_real_com=length(w_l_vec)/2; %num_of_real_com- comparisons which subject made a choice. unresponded comparisons are excluded
        w_l_mat=reshape(w_l_vec, 2, num_of_real_com);
        
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %Step 4 - Calculating subject's intransitivity
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
        %Relevant variables
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        trans_mat=zeros(3,num_of_stim); %trans_mat: columns- stimulus number (=stimulus identity),1st row- number of transitivity violations, 2rd row- intransitivity index expressed by ranks, 3rd row- intransitivity index expressed by values.
        ranking_vec=1:num_of_stim;
        normalization_fac=1/3; %normalization_fac-relevant only for calculating intransitivity index expressed by values (depends on the max amount of money participant were allowed to BID in the BDM assigment)
        
        %Handling ties
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        if sum(sorted_ranking_values(diff(sorted_ranking_values)==0))>0
            ties_values=unique(sorted_ranking_values(diff(sorted_ranking_values)==0));
            for i=1:length(ties_values)
                con_ties_values=find(ranking_values_vec==ties_values(i));%con_ties_values- contains the values in the conversion_vec which their appropriate value in the sorted_ranking_values has at least another equal value (in the sorted_ranking_values)
                con_ties_indexes=zeros(1,length(con_ties_values));
                for l=1:length(con_ties_values)
                    con_ties_indexes(l)=find(conversion_vec==con_ties_values(l));
                end
                tie=mean(con_ties_indexes);
                for m=1:length(con_ties_values)
                    ranking_vec(con_ties_indexes(m))=tie;
                end
            end
        end
        
        %Calculating number of violations of transitivity and intransitivity index (ranks and values) for each stimulus
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        for i=1:2:num_of_real_com*2
            if ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i))>threshold_for_cutoff
                trans_mat(1,w_l_mat(i))=trans_mat(1,w_l_mat(i))+1; %Calculating number of violations of transitivity for each stimulus
                trans_mat(1,w_l_mat(i+1))=trans_mat(1,w_l_mat(i+1))+1; %     -"-         -"-          -"-           -"-          -"-
                
                trans_mat(2,w_l_mat(i))=trans_mat(2,w_l_mat(i))+ranking_vec(conversion_vec==w_l_mat(i))-ranking_vec(conversion_vec==w_l_mat(i+1)); %Calculating intransitivity index expressed by ranks for each stimulus
                trans_mat(2,w_l_mat(i+1))=trans_mat(2,w_l_mat(i+1))+ranking_vec(conversion_vec==w_l_mat(i))-ranking_vec(conversion_vec==w_l_mat(i+1)); %      -"-         -"-          -"-           -"-          -"-
                
                if strcmp(assignment_type,'ItemRankingResults')==1;
                    trans_mat(3,w_l_mat(i))=trans_mat(3,w_l_mat(i))+ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i)); %Calculating intransitivity index expressed by values for each stimulus
                    trans_mat(3,w_l_mat(i+1))=trans_mat(3,w_l_mat(i+1))+ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i));  %     -"-         -"-          -"-           -"-          -"-
                    
                    if flag(j)==0
                        values_for_cutoff_item_ranking_snacks(end+1)=ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i));
                    else values_for_cutoff_item_ranking_faces(end+1)=ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i));
                    end
                else   trans_mat(3,w_l_mat(i))=trans_mat(3,w_l_mat(i))+(ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i)))*normalization_fac; %Calculating intransitivity index expressed by values for each stimulus
                    trans_mat(3,w_l_mat(i+1))=trans_mat(3,w_l_mat(i+1))+(ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i)))*normalization_fac; %     -"-         -"-          -"-           -"-          -"-
                    
                    if flag(j)==1
                        values_for_cutoff_BDM_snacks(end+1)=(ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i)))*normalization_fac;
                    else values_for_cutoff_BDM_faces(end+1)=(ranking_values_vec(w_l_mat(i+1))-ranking_values_vec(w_l_mat(i)))*normalization_fac;
                    end
                    
                end
            end
        end
        
        violations_vec=trans_mat(1,:);
        intransitivity_index_ranks_vec=trans_mat(2,:);
        intransitivity_index_values_vec=trans_mat(3,:);
        
        %General statistical data
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        num_intransitivity_stimuli=sum(violations_vec~=0);
        percent_intransitivity_stimuli=(num_intransitivity_stimuli/num_of_stim)*100;
        total_violations=sum(violations_vec)/2;
        percent_violations=(total_violations/num_of_real_com)*100;
        average_intransitivity_index_ranks=(sum(intransitivity_index_ranks_vec)/2)/total_violations; %Average ranking distance between 2 stimuli which don't obey transitivity
        average_intransitivity_index_values=(sum(intransitivity_index_values_vec)/2)/total_violations; %Average values distance between 2 stimuli which don't obey transitivity
        
        %Recording intransitivity data
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        final_data_array_parameters{4*(k-1)+j, 1}=subject_ID;
        final_data_array_parameters{4*(k-1)+j, 2}=session_type;
        final_data_array_parameters{4*(k-1)+j, 3}=assignment_type;
        final_data_array_parameters{4*(k-1)+j, 4}=num_intransitivity_stimuli;
        final_data_array_parameters{4*(k-1)+j, 5}=percent_intransitivity_stimuli;
        final_data_array_parameters{4*(k-1)+j, 6}=total_violations;
        final_data_array_parameters{4*(k-1)+j, 7}=percent_violations;
        final_data_array_parameters{4*(k-1)+j, 8}=average_intransitivity_index_ranks;
        final_data_array_parameters{4*(k-1)+j, 9}=average_intransitivity_index_values;
        
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %Step 5 - Excluding stimuli - relevant only for "assignment_type='ItemRankingResults'"
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
        
        if   strcmp(assignment_type,'ItemRankingResults')==1;
            
            if flag(j)==2
                final_data_array_stimuli((k-1)*num_of_stim+4*k:k*num_of_stim+4*k-1,2)=data_1_array(:,1);
                final_data_array_stimuli((k-1)*num_of_stim+4*k:k*num_of_stim+4*k-1,6)=data_1_array(:,1);
                final_data_array_stimuli((k-1)*num_of_stim+4*k:k*num_of_stim+4*k-1,10)=data_1_array(:,1);
            else
                final_data_array_stimuli((k-1)*num_of_stim+4*k:k*num_of_stim+4*k-1,14)=data_1_array(:,1);
                final_data_array_stimuli((k-1)*num_of_stim+4*k:k*num_of_stim+4*k-1,18)=data_1_array(:,1);
                final_data_array_stimuli((k-1)*num_of_stim+4*k:k*num_of_stim+4*k-1,22)=data_1_array(:,1);
            end
            
            final_data_array_stimuli{(k-1)*num_of_stim+4*k,1}=subject_ID;
            
            
            %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            %Excluding stimuli as a function of max total violations
            %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            
            num_of_real_stim=num_of_stim;
            stimuli_vec=1:num_of_stim;
            w_l_mat_vio=w_l_mat;
            total_violations_vio=total_violations;
            violations_vec_vio=violations_vec;
            intransitivity_index_ranks_vec_vio=intransitivity_index_ranks_vec;
            intransitivity_index_values_vec_vio=intransitivity_index_values_vec;
            
            iteration=1;
            while total_violations_vio>0
                excluded_stimulus=find(violations_vec_vio==max(violations_vec_vio));
                if length(excluded_stimulus)>1
                    excluded_stimulus=find(intransitivity_index_ranks_vec_vio==max(intransitivity_index_ranks_vec_vio(excluded_stimulus)));
                end
                if length(excluded_stimulus)>1
                    excluded_stimulus=find(intransitivity_index_values_vec_vio==max(intransitivity_index_values_vec_vio(excluded_stimulus)));
                end
                if  length(excluded_stimulus)>1
                    excluded_stimulus=excluded_stimulus(1);
                end
                
                if flag(j)==2
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,3}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,2};
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,2}='-';
                else
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,15}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,14};
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,14}='-';
                end
                
                trans_mat_vio=zeros(3,num_of_stim);
                exclu_indexes=find(w_l_mat_vio==excluded_stimulus);
                loser_pairs_inde=exclu_indexes(mod(exclu_indexes,2)==0);
                winner_pairs_inde=exclu_indexes(mod(exclu_indexes, 2)==1);
                exclu_pairs=[(loser_pairs_inde-1)' (exclu_indexes)' (winner_pairs_inde+1)'];
                w_l_mat_vio(exclu_pairs)=[];
                w_l_mat_vio=reshape(w_l_mat_vio,2,length(w_l_mat_vio)/2);
                
                num_of_real_stim=num_of_real_stim-1;
                num_of_real_com=length(w_l_mat_vio);
                
                stimuli_vec(stimuli_vec==excluded_stimulus)=[];
                
                %Checking for bad luck stimuli
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                N=zeros(num_of_real_stim,3); %create the N matrix of (win,loses,total) for each stimulus (each row represent a specific stimulus). To be used in Colley's ranking
                for i=1:num_of_real_stim
                    N(i,1)=sum(w_l_mat_vio(1,:)==stimuli_vec(i));
                    N(i,2)=sum(w_l_mat_vio(2,:)==stimuli_vec(i));
                    N(i,3)=N(i,1)+N(i,2);
                end
                if all(N(:,3))==0
                    ind_zeros_row=find(N(:,3)==0);
                    bad_luck_excluded_stimulus=stimuli_vec(ind_zeros_row);
                    num_of_real_stim=num_of_real_stim-1;
                    
                    stimuli_vec(stimuli_vec==bad_luck_excluded_stimulus)=[];
                    
                    
                    if flag(j)==2
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,4}=final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,2};
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,2}='-';
                    else
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,16}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,14};
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,14}='-';
                    end
                end
                
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                %Calculating subject's intransitivity
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                
                %Calculating number of violations of transitivity and intransitivity index (ranks and values) for each stimulus
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                for i=1:2:num_of_real_com*2
                    if ranking_values_vec(w_l_mat_vio(i+1))-ranking_values_vec(w_l_mat_vio(i))>threshold_for_cutoff
                        trans_mat_vio(1,w_l_mat_vio(i))=trans_mat_vio(1,w_l_mat_vio(i))+1; %Calculating number of violations of transitivity for each stimulus
                        trans_mat_vio(1,w_l_mat_vio(i+1))=trans_mat_vio(1,w_l_mat_vio(i+1))+1; %     -"-         -"-          -"-           -"-          -"-
                        
                        trans_mat_vio(2,w_l_mat_vio(i))=trans_mat_vio(2,w_l_mat_vio(i))+ranking_vec(conversion_vec==w_l_mat_vio(i))-ranking_vec(conversion_vec==w_l_mat_vio(i+1)); %Calculating intransitivity index expressed by ranks for each stimulus
                        trans_mat_vio(2,w_l_mat_vio(i+1))=trans_mat_vio(2,w_l_mat_vio(i+1))+ranking_vec(conversion_vec==w_l_mat_vio(i))-ranking_vec(conversion_vec==w_l_mat_vio(i+1));  %      -"-         -"-          -"-           -"-          -"-
                        
                        trans_mat_vio(3,w_l_mat_vio(i))=trans_mat_vio(3,w_l_mat_vio(i))+ranking_values_vec(w_l_mat_vio(i+1))-ranking_values_vec(w_l_mat_vio(i)); %Calculating intransitivity index expressed by values for each stimulus
                        trans_mat_vio(3,w_l_mat_vio(i+1))=trans_mat_vio(3,w_l_mat_vio(i+1))+ranking_values_vec(w_l_mat_vio(i+1))-ranking_values_vec(w_l_mat_vio(i));  %     -"-         -"-          -"-           -"-          -"-
                    end
                end
                
                violations_vec_vio=trans_mat_vio(1,:);
                intransitivity_index_ranks_vec_vio=trans_mat_vio(2,:);
                intransitivity_index_values_vec_vio=trans_mat_vio(3,:);
                
                %General statistical data
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                num_intransitivity_stimuli_vio=sum(violations_vec_vio~=0);
                percent_intransitivity_stimuli_vio=(num_intransitivity_stimuli_vio/num_of_real_stim)*100;
                total_violations_vio=sum(violations_vec_vio)/2;
                percent_violations_vio=(total_violations_vio/num_of_real_com)*100;
                average_intransitivity_index_ranks_vio=(sum(intransitivity_index_ranks_vec_vio)/2)/total_violations_vio; %Average ranking distance between 2 stimuli which don't obey transitivity
                average_intransitivity_index_values_vio=(sum(intransitivity_index_values_vec_vio)/2)/total_violations_vio; %Average values distance between 2 stimuli which don't obey transitivity
                
                %Recording intransitivity data
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                
                final_data_array_parameters{4*(k-1)+j, 10}=iteration;
                
                %------------------------------------------------------
                
                iteration=iteration+1;
                
            end
            
            %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            %Excluding stimuli as a function of max intransitivity ranking index
            %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            
            num_of_real_stim=num_of_stim;
            stimuli_vec=1:num_of_stim;
            w_l_mat_iri=w_l_mat;
            total_violations_iri=total_violations;
            violations_vec_iri=violations_vec;
            intransitivity_index_ranks_vec_iri=intransitivity_index_ranks_vec;
            intransitivity_index_values_vec_iri=intransitivity_index_values_vec;
            
            iteration=1;
            while sum(intransitivity_index_ranks_vec_iri)>0
                excluded_stimulus=find(intransitivity_index_ranks_vec_iri==max(intransitivity_index_ranks_vec_iri));
                if length(excluded_stimulus)>1
                    excluded_stimulus=find(intransitivity_index_values_vec_iri==max(intransitivity_index_values_vec_iri(excluded_stimulus)));
                end
                if length(excluded_stimulus)>1
                    excluded_stimulus=find(violations_vec_iri==max(violations_vec_iri(excluded_stimulus)));
                end
                if  length(excluded_stimulus)>1
                    excluded_stimulus=excluded_stimulus(1);
                end
                
                if flag(j)==2
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,7}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,6};
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,6}='-';
                else
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,19}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,18};
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,18}='-';
                end
                
                trans_mat_iri=zeros(3,num_of_stim);
                exclu_indexes=find(w_l_mat_iri==excluded_stimulus);
                loser_pairs_inde=exclu_indexes(mod(exclu_indexes, 2)==0);
                winner_pairs_inde=exclu_indexes(mod(exclu_indexes, 2)==1);
                exclu_pairs=[(loser_pairs_inde-1)' (exclu_indexes)' (winner_pairs_inde+1)'];
                w_l_mat_iri(exclu_pairs)=[];
                w_l_mat_iri=reshape(w_l_mat_iri,2,length(w_l_mat_iri)/2);
                
                num_of_real_stim=num_of_real_stim-1;
                num_of_real_com=length(w_l_mat_iri);
                stimuli_vec(stimuli_vec==excluded_stimulus)=[];
                
                %Checking for bad luck stimuli
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                N=zeros(num_of_real_stim,3); %create the N matrix of (win,loses,total) for each stimulus (each row represent a specific stimulus). To be used in Colley's ranking
                for i=1:num_of_real_stim
                    N(i,1)=sum(w_l_mat_iri(1,:)==stimuli_vec(i));
                    N(i,2)=sum(w_l_mat_iri(2,:)==stimuli_vec(i));
                    N(i,3)=N(i,1)+N(i,2);
                end
                
                if all(N(:,3))==0
                    ind_zeros_row=find(N(:,3)==0);
                    N(ind_zeros_row,:)=[];
                    bad_luck_excluded_stimulus=stimuli_vec(ind_zeros_row);
                    num_of_real_stim=num_of_real_stim-1;
                    
                    stimuli_vec(stimuli_vec== bad_luck_excluded_stimulus)=[];
                    
                    if flag(j)==2
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,8}=final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,6};
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,6}='-';
                    else
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,20}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,18};
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,18}='-';
                    end
                end
                
                
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                %Calculating subject's intransitivity
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                
                %Calculating number of violations of transitivity and intransitivity index (ranks and values) for each stimulus
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                for i=1:2:num_of_real_com*2
                    if ranking_values_vec(w_l_mat_iri(i+1))-ranking_values_vec(w_l_mat_iri(i))>threshold_for_cutoff
                        trans_mat_iri(1,w_l_mat_iri(i))=trans_mat_iri(1,w_l_mat_iri(i))+1; %Calculating number of violations of transitivity for each stimulus
                        trans_mat_iri(1,w_l_mat_iri(i+1))=trans_mat_iri(1,w_l_mat_iri(i+1))+1; %     -"-         -"-          -"-           -"-          -"-
                        
                        trans_mat_iri(2,w_l_mat_iri(i))=trans_mat_iri(2,w_l_mat_iri(i))+ranking_vec(conversion_vec==w_l_mat_iri(i))-ranking_vec(conversion_vec==w_l_mat_iri(i+1)); %Calculating intransitivity index expressed by ranks for each stimulus
                        trans_mat_iri(2,w_l_mat_iri(i+1))=trans_mat_iri(2,w_l_mat_iri(i+1))+ranking_vec(conversion_vec==w_l_mat_iri(i))-ranking_vec(conversion_vec==w_l_mat_iri(i+1));  %      -"-         -"-          -"-           -"-          -"-
                        
                        trans_mat_iri(3,w_l_mat_iri(i))=trans_mat_iri(3,w_l_mat_iri(i))+ranking_values_vec(w_l_mat_iri(i+1))-ranking_values_vec(w_l_mat_iri(i)); %Calculating intransitivity index expressed by values for each stimulus
                        trans_mat_iri(3,w_l_mat_iri(i+1))=trans_mat_iri(3,w_l_mat_iri(i+1))+ranking_values_vec(w_l_mat_iri(i+1))-ranking_values_vec(w_l_mat_iri(i));  %     -"-         -"-          -"-           -"-          -"-
                    end
                end
                
                violations_vec_iri=trans_mat_iri(1,:);
                intransitivity_index_ranks_vec_iri=trans_mat_iri(2,:);
                intransitivity_index_values_vec_iri=trans_mat_iri(3,:);
                
                %General statistical data
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                num_intransitivity_stimuli_iri=sum(violations_vec_iri~=0);
                percent_intransitivity_stimuli_iri=(num_intransitivity_stimuli_iri/num_of_real_stim)*100;
                total_violations_iri=sum(violations_vec_iri)/2;
                percent_violations_iri=(total_violations_iri/num_of_real_com)*100;
                average_intransitivity_index_ranks_iri=(sum(intransitivity_index_ranks_vec_iri)/2)/total_violations_iri; %Average ranking distance between 2 stimuli which don't obey transitivity
                average_intransitivity_index_values_iri=(sum(intransitivity_index_values_vec_iri)/2)/total_violations_iri; %Average values distance between 2 stimuli which don't obey transitivity
                
                %Recording intransitivity data
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                
                final_data_array_parameters{4*(k-1)+j, 11}=iteration;
                
                %----------------------------------------------------
                
                iteration=iteration+1;
                
            end
            
            %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            %Excluding stimuli as a function of max intransitivity value index
            %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
            
            num_of_real_stim=num_of_stim;
            stimuli_vec=1:num_of_stim;
            w_l_mat_ivi=w_l_mat;
            total_violations_ivi=total_violations;
            violations_vec_ivi=violations_vec;
            intransitivity_index_ranks_vec_ivi=intransitivity_index_ranks_vec;
            intransitivity_index_values_vec_ivi=intransitivity_index_values_vec;
            
            iteration=1;
            while sum(intransitivity_index_values_vec_ivi)>0
                excluded_stimulus=find(intransitivity_index_values_vec_ivi==max(intransitivity_index_values_vec_ivi));
                if length(excluded_stimulus)>1
                    excluded_stimulus=find(intransitivity_index_ranks_vec_ivi==max(intransitivity_index_ranks_vec_ivi(excluded_stimulus)));
                end
                if length(excluded_stimulus)>1
                    excluded_stimulus=find(violations_vec_ivi==max(violations_vec_ivi(excluded_stimulus)));
                end
                if  length(excluded_stimulus)>1
                    excluded_stimulus=excluded_stimulus(1);
                end
                
                if flag(j)==2
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,11}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,10};
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,10}='-';
                else
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,23}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,22};
                    final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,22}='-';
                end
                
                trans_mat_ivi=zeros(3,num_of_stim);
                exclu_indexes=find(w_l_mat_ivi==excluded_stimulus);
                loser_pairs_inde=exclu_indexes(mod(exclu_indexes,2)==0);
                winner_pairs_inde=exclu_indexes(mod(exclu_indexes,2)==1);
                exclu_pairs=[(loser_pairs_inde-1)' (exclu_indexes)' (winner_pairs_inde+1)'];
                w_l_mat_ivi(exclu_pairs)=[];
                w_l_mat_ivi=reshape(w_l_mat_ivi,2,length(w_l_mat_ivi)/2);
                
                num_of_real_stim=num_of_real_stim-1;
                num_of_real_com=length(w_l_mat_ivi);
                stimuli_vec(stimuli_vec==excluded_stimulus)=[];
                
                
                %Checking for bad luck stimuli
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                N=zeros(num_of_real_stim,3); %create the N matrix of (win,loses,total) for each stimulus (each row represent a specific stimulus). To be used in Colley's ranking
                for i=1:num_of_real_stim
                    N(i,1)=sum(w_l_mat_ivi(1,:)==stimuli_vec(i));
                    N(i,2)=sum(w_l_mat_ivi(2,:)==stimuli_vec(i));
                    N(i,3)=N(i,1)+N(i,2);
                end
                
                if all(N(:,3))==0
                    ind_zeros_row=find(N(:,3)==0);
                    N(ind_zeros_row,:)=[];
                    bad_luck_excluded_stimulus=stimuli_vec(ind_zeros_row);
                    num_of_real_stim=num_of_real_stim-1;
                    
                    stimuli_vec(stimuli_vec==bad_luck_excluded_stimulus)=[];
                    
                    
                    if flag(j)==2
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,12}=final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,10};
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,10}='-';
                    else
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,24}=final_data_array_stimuli{(k-1)*num_of_stim+excluded_stimulus+4*k-1,22};
                        final_data_array_stimuli{(k-1)*num_of_stim+bad_luck_excluded_stimulus+4*k-1,22}='-';
                    end
                end
                
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                %Calculating subject's intransitivity
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                
                %Calculating number of violations of transitivity and intransitivity index (ranks and values) for each stimulus
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                for i=1:2:num_of_real_com*2
                    if ranking_values_vec(w_l_mat_ivi(i+1))-ranking_values_vec(w_l_mat_ivi(i))>threshold_for_cutoff
                        trans_mat_ivi(1,w_l_mat_ivi(i))=trans_mat_ivi(1,w_l_mat_ivi(i))+1; %Calculating number of violations of transitivity for each stimulus
                        trans_mat_ivi(1,w_l_mat_ivi(i+1))=trans_mat_ivi(1,w_l_mat_ivi(i+1))+1; %     -"-         -"-          -"-           -"-          -"-
                        
                        trans_mat_ivi(2,w_l_mat_ivi(i))=trans_mat_ivi(2,w_l_mat_ivi(i))+ranking_vec(conversion_vec==w_l_mat_ivi(i))-ranking_vec(conversion_vec==w_l_mat_ivi(i+1)); %Calculating intransitivity index expressed by ranks for each stimulus
                        trans_mat_ivi(2,w_l_mat_ivi(i+1))=trans_mat_ivi(2,w_l_mat_ivi(i+1))+ranking_vec(conversion_vec==w_l_mat_ivi(i))-ranking_vec(conversion_vec==w_l_mat_ivi(i+1));  %      -"-         -"-          -"-           -"-          -"-
                        
                        trans_mat_ivi(3,w_l_mat_ivi(i))=trans_mat_ivi(3,w_l_mat_ivi(i))+ranking_values_vec(w_l_mat_ivi(i+1))-ranking_values_vec(w_l_mat_ivi(i)); %Calculating intransitivity index expressed by values for each stimulus
                        trans_mat_ivi(3,w_l_mat_ivi(i+1))=trans_mat_ivi(3,w_l_mat_ivi(i+1))+ranking_values_vec(w_l_mat_ivi(i+1))-ranking_values_vec(w_l_mat_ivi(i));  %     -"-         -"-          -"-           -"-          -"-
                    end
                end
                
                violations_vec_ivi=trans_mat_ivi(1,:);
                intransitivity_index_ranks_vec_ivi=trans_mat_ivi(2,:);
                intransitivity_index_values_vec_ivi=trans_mat_ivi(3,:);
                
                %General statistical data
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                num_intransitivity_stimuli_ivi=sum(violations_vec_ivi~=0);
                percent_intransitivity_stimuli_ivi=(num_intransitivity_stimuli_ivi/num_of_real_stim)*100;
                total_violations_ivi=sum(violations_vec_ivi)/2;
                percent_violations_ivi=(total_violations_ivi/num_of_real_com)*100;
                average_intransitivity_index_ranks_ivi=(sum(intransitivity_index_ranks_vec_ivi)/2)/total_violations_ivi; %Average ranking distance between 2 stimuli which don't obey transitivity
                average_intransitivity_index_values_ivi=(sum(intransitivity_index_values_vec_ivi)/2)/total_violations_ivi; %Average values distance between 2 stimuli which don't obey transitivity
                
                %Recording intransitivity data
                %------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
                
                final_data_array_parameters{4*(k-1)+j, 12}=iteration;
                
                %------------------------------------------------------
                
                iteration=iteration+1;
                
            end
        end
    end
end


fid_1=fopen([path, experiment_name, '.txt'], 'a');
fprintf(fid_1, ['Subject ID\t Session type\t Assignment type\t Num of intransiant stimuli\t Percentage of intransiant stimuli\t Num of intransiant trials\t Percentage of intransiant trials\t Average ranks violation size\t Average values violation size\t To remove stimuli by max num of intransiant violations\t To remove stimuli by max intransiant rankings\t To remove stimuli by max intransiant values\n']);
[nrows,ncols]=size(final_data_array_parameters);
for i=1:nrows
    fprintf(fid_1,'%s\t %s\t %s\t %.0f\t %.3f\t %.0f\t %.3f\t %.3f\t %.3f\t %.0f\t %.0f\t %.0f\n', final_data_array_parameters{i,:});
end



fid_2=fopen([path, experiment_name, '.txt'], 'a');
[nrows,ncols]=size(final_data_array_stimuli);
for i=1:nrows
    fprintf(fid_2,'%s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\t %s\n', final_data_array_stimuli{i,:});
end

fclose('all');

























































































