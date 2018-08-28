clear all

okscan=[0 1 2];
test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
while isempty(test_comp) || sum(okscan==test_comp)~=1
    disp('ERROR: input must be 0,1 or 2. Please try again.');
    test_comp=input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
end



if test_comp==0
    outpath='~/Documents/Boost/Output/';
elseif test_comp==2
    outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
end


subjects=  [  148 149 150 151 152 153 154  156 157 158 160 161 162 163 177 180 181 183 184 185 246 247 248 249 250 251] %messed up probe until 148. 155 didn't understand instructions of probe

%exclude:
%159, 179 - due to BDM.
%182 - Ladders
%178, 186 problematic
%244 - BDM too low
%184,185,249 didn't choose enough in sanity comparisons

choices_1=9999*ones(length(subjects),33); % number of choices of each trial type +1 for subject number columnn
    choices_2=9999*ones(length(subjects),33);
    choices_3=9999*ones(length(subjects),33);
    choices_4=9999*ones(length(subjects),33);
    


for subjInd=1:length(subjects)
    outpath='~/Dropbox/Documents/Trained_Inhibition/Boost/Output/';
    
    if subjects(subjInd)<100
        
        filename=strcat(outpath,sprintf('BM2_0%d',subjects(subjInd)));
        
    else
        filename=strcat(outpath,sprintf('BM2_%d',subjects(subjInd)));
    end
    
   
%    
%     clear fid ;
%     
    logs=dir(strcat(filename, '_boostprobe','*.txt'))
    fid=fopen(strcat(outpath,logs(1).name));
   
    % for i=1:runnum
    % Ladder2alls=[Ladder2alls; Ladder2{i}];
    % Ladder1alls=[Ladder1alls; Ladder1{i}];
    % stops1(subjInd,i)=size(find(respInTime{i}==1),1);
    % stops2(subjInd,i)=size(find(respInTime{i}==2),1);
    % mean_RT_HL1(subjInd,i)=mean(respTime{i}(find(respInTime{i}==12)));
    % mean_RT_HL2(subjInd,i)=mean(respTime{i}(find(respInTime{i}==24)));
    % median_RT_HL1(subjInd,i)=median(respTime{i}(find(respInTime{i}==12)));
    % median_RT_HL2(subjInd,i)=median(respTime{i}(find(respInTime{i}==24)));
    % median_Ladders_HL1(subjInd,i)=median(Ladder1{i});
    % median_Ladders_HL2(subjInd,i)=median(Ladder2{i});
    % length_Ladders_HL1(subjInd,i)=length(Ladder1{i});
    % length_Ladders_HL2(subjInd,i)=length(Ladder2{i});
    % end
    %
    %
    % Ladders1AllSubs(subjInd,:)=Ladder1alls';
    % Ladders2AllSubs(subjInd,:)=Ladder2alls';
    % figure
    % plot(Ladder1alls,'-')
    % hold on
    % plot(Ladder2alls,'r-')
    %
    %
    %
  
      P=textscan(fid, '%s%d%d%d%d%d%s%s%d%d%d%s%d%d%.2f%.2f%.2f' , 'HeaderLines', 1);     %read in probe output file into P ;
   
    
    
    type1Count=1;
    type2Count=1;
    type3Count=1;
    type4Count=1;
    
    
    for trialnum=1:length(P{12})
        
        
        switch P{13}(trialnum) %these are trial types
            case 1
                if strcmp(P{12}(trialnum),'u') % chose the left image
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices_1(subjInd,1)=subjects(subjInd);
                        choices_1(subjInd,2)=P{13}(trialnum);
                        choices_1(subjInd,2+type1Count)=sum(P{9}(trialnum)==[8 11 12 15]);
                        
                        
                    else % if order==2
                        
                         choices_1(subjInd,1)=subjects(subjInd);
                        choices_1(subjInd,2)=P{13}(trialnum);
                        choices_1(subjInd,2+type1Count)=sum(P{9}(trialnum)==[9 10 13 14]);
                        
                        
                    end
                    
                elseif strcmp(P{12}(trialnum),'i') % chose the right image
                    
                    if P{3}(trialnum)==1 %order 1 or 2
                        choices_1(subjInd,1)=subjects(subjInd);
                        choices_1(subjInd,2)=P{13}(trialnum);
                        choices_1(subjInd,2+type1Count)=sum(P{10}(trialnum)==[8 11 12 15]);
                        
                        
                    else % if order==2
                        
                         choices_1(subjInd,1)=subjects(subjInd);
                        choices_1(subjInd,2)=P{13}(trialnum);
                        choices_1(subjInd,2+type1Count)=sum(P{10}(trialnum)==[9 10 13 14]);
                        
                        
                    end
                end
                type1Count=type1Count+1;
            case 2
                
                if strcmp(P{12}(trialnum),'u') % chose the left image
                    if P{3}(trialnum)==1 %order 1 or 2
                        
                        choices_2(subjInd,1)=subjects(subjInd);
                        choices_2(subjInd,2)=P{13}(trialnum);
                        
                        
                        
                        choices_2(subjInd,2+type2Count)=sum(P{9}(trialnum)==[46 49 50 53]);
                    else
                        
                      choices_2(subjInd,1)=subjects(subjInd);
                        choices_2(subjInd,2)=P{13}(trialnum)
                        choices_2(subjInd,2+type2Count)=sum(P{9}(trialnum)==[47 48 51 52]);
                        
                    end
                    
                elseif strcmp(P{12}(trialnum),'i') % chose the right image
                    if P{3}(trialnum)==1 %order 1 or 2
                        
                       choices_2(subjInd,1)=subjects(subjInd);
                        choices_2(subjInd,2)=P{13}(trialnum)
                        choices_2(subjInd,2+type2Count)=sum(P{10}(trialnum)==[46 49 50 53]);
                    else
                        
                       choices_2(subjInd,1)=subjects(subjInd);
                        choices_2(subjInd,2)=P{13}(trialnum)
                        choices_2(subjInd,2+type2Count)=sum(P{10}(trialnum)==[47 48 51 52]);
                        
                    end
                end
                type2Count=type2Count+1;
                
            case 3
                if strcmp(P{12}(trialnum),'u') % chose the left image
                    if P{3}(trialnum)==1 %order 1 or 2
                       choices_3(subjInd,1)=subjects(subjInd);
                        choices_3(subjInd,2)=P{13}(trialnum);
                        choices_3(subjInd,2+type3Count)=sum(P{9}(trialnum)==[16 19 20 23]);
                    else
                        
                        choices_3(subjInd,1)=subjects(subjInd);
                        choices_3(subjInd,2)=P{13}(trialnum);
                        choices_3(subjInd,2+type3Count)=sum(P{9}(trialnum)==[17 18 21 22]);
                        
                    end
                    
                    
                    
                    
                elseif strcmp(P{12}(trialnum),'i')  % chose the right image
                    if P{3}(trialnum)==1 %order 1 or 2
                      choices_3(subjInd,1)=subjects(subjInd);
                        choices_3(subjInd,2)=P{13}(trialnum);
                        choices_3(subjInd,2+type3Count)=sum(P{10}(trialnum)==[16 19 20 23]);
                    else
                        
                        choices_3(subjInd,1)=subjects(subjInd);
                        choices_3(subjInd,2)=P{13}(trialnum);
                        choices_3(subjInd,2+type3Count)=sum(P{10}(trialnum)==[17 18 21 22]);
                        
                    end
                    
                    
                end
                
                type3Count=type3Count+1;
                
                
            case 4
                if strcmp(P{12}(trialnum),'u') % chose the left image
                    
                    if P{3}(trialnum)==1 %order 1 or 2
                        
                        
                        choices_4(subjInd,1)=subjects(subjInd);  
                        choices_4(subjInd,2)=P{13}(trialnum);
                        choices_4(subjInd,1+type4Count)=sum(P{9}(trialnum)==[17 18 21 22]);
                    else
                        
                        choices_4(subjInd,1)=subjects(subjInd);  
                        choices_4(subjInd,2)=P{13}(trialnum);
                        choices_4(subjInd,2+type4Count)=sum(P{9}(trialnum)==[16 19 20 23]);
                        
                    end
                    
                    
                    
                    
                elseif strcmp(P{12}(trialnum),'i') % chose the right image
                    if P{3}(trialnum)==1 %order 1 or 2
                        
                        
                        
                        
                        choices_4(subjInd,1)=P{13}(trialnum);
                        choices_4(subjInd,1+type4Count)=sum(P{10}(trialnum)==[17 18 21 22]);
                    else
                        
                        choices_4(subjInd,1)=P{13}(trialnum);
                        choices_4(subjInd,1+type4Count)=sum(P{10}(trialnum)==[16 19 20 23 ]);
                        
                    end
                end
                
                
                
                type4Count=type4Count+1;
                
                
                
                
        end % end switch trialtype
        
    end % end run across all trials
    
    
   fclose(fid);
  
end % run across subject

A=[ones(16,1) ; 2*ones(16,1)]; % block number - 16 choices per trial type per block


for subjInd=1:length(subjects)
choices_1_Rstyle(1+32*(subjInd-1):32*subjInd,1)=subjects(subjInd); % subject
choices_1_Rstyle(1+32*(subjInd-1):32*subjInd,2)=1; % trial type
choices_1_Rstyle(1+32*(subjInd-1):32*subjInd,3)=choices_1(subjInd,3:size(choices_1,2))'; % choices by trial type
%choices_1_Rstyle(1+32*(subjInd-1):32*subjInd,5)=order_several(subjInd,1);  % several side - 2 means several on the right 

choices_2_Rstyle(1+32*(subjInd-1):32*subjInd,1)=subjects(subjInd);
choices_2_Rstyle(1+32*(subjInd-1):32*subjInd,2)=2;
choices_2_Rstyle(1+32*(subjInd-1):32*subjInd,3)=choices_2(subjInd,3:size(choices_2,2))';
%choices_2_Rstyle(1+32*(subjInd-1):32*subjInd,5)=order_several(subjInd,1);


choices_3_Rstyle(1+32*(subjInd-1):32*subjInd,1)=subjects(subjInd);
choices_3_Rstyle(1+32*(subjInd-1):32*subjInd,2)=3;
choices_3_Rstyle(1+32*(subjInd-1):32*subjInd,3)=choices_3(subjInd,3:size(choices_3,2))';
%choices_3_Rstyle(1+32*(subjInd-1):32*subjInd,5)=order_several(subjInd,1);



choices_4_Rstyle(1+32*(subjInd-1):32*subjInd,1)=subjects(subjInd);
choices_4_Rstyle(1+32*(subjInd-1):32*subjInd,2)=4;
choices_4_Rstyle(1+32*(subjInd-1):32*subjInd,3)=choices_4(subjInd,3:size(choices_4,2))';
%choices_4_Rstyle(1+32*(subjInd-1):32*subjInd,5)=order_several(subjInd,1);



end


choices_1_Rstyle(1:length(choices_1_Rstyle),4)=repmat(A,[length(subjects) 1]); % entering block numbers
choices_2_Rstyle(1:length(choices_2_Rstyle),4)=repmat(A,[length(subjects) 1]);
choices_3_Rstyle(1:length(choices_3_Rstyle),4)=repmat(A,[length(subjects) 1]);
choices_4_Rstyle(1:length(choices_4_Rstyle),4)=repmat(A,[length(subjects) 1]);

choices_all_R=[choices_1_Rstyle ; choices_2_Rstyle ; choices_3_Rstyle ;choices_4_Rstyle];



fid1=fopen(('boostprobe_choices_for_R.txt'), 'w');    

fprintf(fid1,'subjid trialType choices blockNum \n'); %write the header line

for i=1:length(choices_all_R)
             %write out the full list with the bids and also which item will be a stop item
    fprintf(fid1, '%d\t%d\t%d\t%d\t\n', choices_all_R(i,1:4)); % write item names, the stop/go high/low oneSeveral and item indeex
end
fprintf(fid1, '\n');
    
fclose(fid1);



% 

