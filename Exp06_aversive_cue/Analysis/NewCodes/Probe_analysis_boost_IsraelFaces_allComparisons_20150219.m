clear all

% okscan = [0 1 2];
% test_comp = input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
% while isempty(test_comp) || sum(okscan==test_comp)~=1
%     disp('ERROR: input must be 0,1 or 2. Please try again.');
%     test_comp = input('Are you scanning? 2 Toms_iMac, 1 MRI, 0 if testooom: ');
% end



% if test_comp == 0
%     outpath = '~/Documents/Boost/Output/';
% elseif test_comp == 2
%     outpath = 'C:/users/YanivA_99/desktop/Faces_Feb17/Output';
% end

% 3 and 4 are good only from subject 148 but potential problem with 149.

% messed up probe until 136

subjects = [101 102 103 104 105 106 107 108 109 110 111 112 113 114] % %

% matrices for all comparisons, according to pairType
choices = zeros(length(subjects),8);
choicesRT = zeros(length(subjects),8);
choicesNot = zeros(length(subjects),8);
choicesNotRT = zeros(length(subjects),8);

% matrices for comparisons of HV GO-NOGO, according to subPairType
choices_Higher_HV = zeros(length(subjects),1);
choices_Lower_HV = zeros(length(subjects),1); 
choices_between_HV = zeros(length(subjects),1);
choicesNot_Higher_HV = zeros(length(subjects),1);
choicesNot_Lower_HV = zeros(length(subjects),1);
choicesNot_between_HV = zeros(length(subjects),1);

% matrices for comparisons of LV GO-NOGO, according to subPairType
choices_Higher_LV = zeros(length(subjects),1);
choices_Lower_LV = zeros(length(subjects),1);
choices_between_LV = zeros(length(subjects),1);
choicesNot_Higher_LV = zeros(length(subjects),1);
choicesNot_Lower_LV = zeros(length(subjects),1);
choicesNot_between_LV = zeros(length(subjects),1);


order_probe = zeros(length(subjects));


for subjInd = 1:length(subjects)
    outpath = 'C:/users/YanivA_99/desktop/Faces_Feb17/Output/';
    Ladder1alls = [];
    Ladder2alls = [];
    
    clear Ladder1 Ladder2 respInTime respTime
    
    %    if subjects(subjInd)<100
    %
    %    filename=strcat(outpath,sprintf('BM2_0%d',subjects(subjInd)));
    %
    %    else
    filename = strcat(outpath,sprintf('BMI_bf_%d',subjects(subjInd)));
    %  end
    
    results = dir(strcat(filename, '_probe','*.txt')) ;
    mats = dir(strcat(filename, '_probe','*.mat')) ;
    mats_train = dir(strcat(filename, '_boost','*.mat')) ;
    
    allBlocksProbeResults = cell(length(results),18);
    P = cell(1,size(allBlocksProbeResults,2));
    
    for blockNum = 1:length(results)
        
        
        fid = fopen(strcat(outpath,results(blockNum).name));
        % load(strcat(outpath,mats_train(1).name));
        
        
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
        
        
        %     P=textscan(fid, '%s%d%d%d%d%d%s%s%d%d%d%s%d%d%.2f%.2f%.2f' , 'HeaderLines', 1);     %read in probe output file into P ;
        probeResults = textscan(fid, '%s %d %d %d %d %d %d %s %s %d %d %d %s %d %d %.2f %.2f %.2f' , 'HeaderLines',1);     %read in probe output file into P ;
        allBlocksProbeResults(blockNum,:) = probeResults;
        fclose(fid);
        for column = 1:size(probeResults,2)
            P{column} = [P{column}; allBlocksProbeResults{blockNum,column}];
        end % end for column
    end % end for blockNum = 1:length(results)
    
    
    order = P{3}(1);
    order_probe(subjInd) = order;
    
    % Compute subPairType to cell P{19}
    P{19} = zeros(length(P{1}),1);
    
    % high-value GO-NOGO comparisons
    P{19}(P{10}>6 & P{10}<15 & P{11}>6 & P{11}<15) = 11; % highest 8 HV comparisons
    P{19}(P{10}>14 & P{10}<23 & P{11}>14 & P{11}<23) = 12; % lowest 8 HV comparisons
    P{19}(P{10}>14 & P{10}<23 & P{11}>6 & P{11}<15) = 13; % comparisons between 8 highest and 8 lowest HV items
    P{19}(P{10}>6 & P{10}<15 & P{11}>14 & P{11}<23) = 13; % comparisons between 8 highest and 8 lowest HV items
    
    % low-value GO-NOGO comparisons
    P{19}(P{10}>38 & P{10}<47 & P{11}>38 & P{11}<47) = 21; % highest 8 LV comparisons
    P{19}(P{10}>46 & P{10}<55 & P{11}>46 & P{11}<55) = 22; % lowest 8 LV comparisons
    P{19}(P{10}>46 & P{10}<55 & P{11}>38 & P{11}<47) = 23; % comparisons between 8 highest and 8 lowest LV items
    P{19}(P{10}>38 & P{10}<47 & P{11}>46 & P{11}<55) = 23; % comparisons between 8 highest and 8 lowest LV items
    
    % sum outcome=1 when subPairType=11
    choices_Higher_HV(subjInd) = sum(P{15}(P{19}==11)==1);
    % sum outcome=0 when subPairType=11
    choicesNot_Higher_HV(subjInd) = sum(P{15}(P{19}==11)==0);
    % sum outcome=1 when subPairType=12
    choices_Lower_HV(subjInd) = sum(P{15}(P{19}==12)==1);
    % sum outcome=0 when subPairType=12
    choicesNot_Lower_HV(subjInd) = sum(P{15}(P{19}==12)==0);
    % sum outcome=1 when subPairType=13
    choices_between_HV(subjInd) = sum(P{15}(P{19}==13)==1);
    % sum outcome=0 when subPairType=13
    choicesNot_between_HV(subjInd) = sum(P{15}(P{19}==13)==0);
    
    % sum outcome=1 when subPairType=21
    choices_Higher_LV(subjInd) = sum(P{15}(P{19}==21)==1);
    % sum outcome=0 when subPairType=21
    choicesNot_Higher_LV(subjInd) = sum(P{15}(P{19}==21)==0);
    % sum outcome=1 when subPairType=22
    choices_Lower_LV(subjInd) = sum(P{15}(P{19}==22)==1);
    % sum outcome=0 when subPairType=22
    choicesNot_Lower_LV(subjInd) = sum(P{15}(P{19}==22)==0); 
    % sum outcome=1 when subPairType=23
    choices_between_LV(subjInd) = sum(P{15}(P{19}==23)==1);
    % sum outcome=0 when subPairType=23
    choicesNot_between_LV(subjInd) = sum(P{15}(P{19}==23)==0);
    
    for trialnum = 1:length(P{13})
           
        switch P{14}(trialnum) %these are trial types
            case 1                
                
            if strcmp(P{13}(trialnum),'u') % chose the left image
                if P{3}(trialnum) == 1 %order 1 or 2
                    choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[7 10 12 13 15 18 20 21]); %sum only choices of stop items
                    choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[7 10 12 13 15 18 20 21])*P{16}(trialnum)/1000; %sum only choices of stop items
                    
                    choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[8 9 11 14 16 17 19 22]); %sum only choice
                    choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[8 9 11 14 16 17 19 22])*P{16}(trialnum)/1000;
                    
                else % if order==2
                    choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[8 9 11 14 16 17 19 22]);
                    choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[8 9 11 14 16 17 19 22])*P{16}(trialnum)/1000;
                    
                    choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[7 10 12 13 15 18 20 21]); %sum only choice
                    choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[7 10 12 13 15 18 20 21])*P{16}(trialnum)/1000; %sum only choice
                    
                end
                
            elseif strcmp(P{13}(trialnum),'i') % chose the right image
                if P{3}(trialnum) == 1 %order 1 or 2
                    choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[7 10 12 13 15 18 20 21]);
                    choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[7 10 12 13 15 18 20 21])*P{16}(trialnum)/1000;
                    
                    choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[8 9 11 14 16 17 19 22]); %sum only choice
                    choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[8 9 11 14 16 17 19 22])*P{16}(trialnum)/1000; %sum only choice
                    
                else
                    choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[8 9 11 14 16 17 19 22]);
                    choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[8 9 11 14 16 17 19 22])*P{16}(trialnum)/1000;
                    
                    choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[7 10 12 13 15 18 20 21]); %sum only choice
                    choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[7 10 12 13 15 18 20 21])*P{16}(trialnum)/1000; %sum only choice
                    
                end
            end
            
            case 2
                               
                if strcmp(P{13}(trialnum),'u') % chose the left image
                    if P{3}(trialnum) == 1 %order 1 or 2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[39 42	44	45	47	50	52	53]); %sum only choices of stop items
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[39 42	44	45	47	50	52	53])*P{16}(trialnum)/1000; %sum only choices of stop items
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[40	41	43	46	48	49	51	54]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[40	41	43	46	48	49	51	54])*P{16}(trialnum)/1000; %sum only choice
                        
                    else % if order==2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[40 41	43	46	48	49	51	54]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[40 41	43	46	48	49	51	54])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[39 42	44	45	47	50	52	53]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[39 42	44	45	47	50	52	53])*P{16}(trialnum)/1000; %sum only choice
                        
                    end
                    
                elseif strcmp(P{13}(trialnum),'i') % chose the right image
                    if P{3}(trialnum) == 1 %order 1 or 2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[39 42 44	45	47	50	52	53]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[39 42 44	45	47	50	52	53])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[40	41	43	46	48	49	51	54]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[40	41	43	46	48	49	51	54])*P{16}(trialnum)/1000; %sum only choice
                        
                    else
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[40 41 43	46	48	49	51	54]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[40 41 43	46	48	49	51	54])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[39	42	44	45	47	50	52	53]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[39	42	44	45	47	50	52	53])*P{16}(trialnum)/1000; %sum only choice
                        
                    end
                end
                
                
                
                
                
            case 4 % pay attention that although the codes were meant to use pairType=3 as comparison between high and low NOGO items, the organizeProbe code used pairType 4 as NOGO sanity comparison and pairType 3 as GO sanity comparison
                if strcmp(P{13}(trialnum),'u') % chose the left image
                    if P{3}(trialnum) == 1 %order 1 or 2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[23 26]); %sum only choices of stop items % these are the high value items of the sanity check of NOGO items
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[23 26])*P{16}(trialnum)/1000; %sum only choices of stop items
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[35 38]); %sum only choice % these are the low value items of the sanity check of NOGO items
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[35 38])*P{16}(trialnum)/1000; %sum only choice
                        
                    else % if order==2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[24 25]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[24 25])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[36 37]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[36 37])*P{16}(trialnum)/1000; %sum only choice
                        
                    end
                    
                    
                elseif strcmp(P{13}(trialnum),'i')  % chose the right image
                    if P{3}(trialnum) == 1 %order 1 or 2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[23 26]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[23 26])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[35 38]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[35 38])*P{16}(trialnum)/1000; %sum only choice
                        
                    else
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[24 25]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[24 25])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[36 37]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[36 37])*P{16}(trialnum)/1000; %sum only choice
                        
                    end
                end
                
            case 3 % pay attention that although the codes were meant to use pairType=3 as comparison between high and low NOGO items, the organizeProbe code used pairType 4 as NOGO sanity comparison and pairType 3 as GO sanity comparison
                if strcmp(P{13}(trialnum),'u') % chose the left image
                    if P{3}(trialnum) == 1 %order 1 or 2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[24 25]); %sum only choices of stop items % these are the high value items of the sanity check of GO items
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[24 25])*P{16}(trialnum)/1000; %sum only choices of stop items
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[36 37]); %sum only choice % these are the low value items of the sanity check of GO items
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[36 37])*P{16}(trialnum)/1000; %sum only choice
                    else % if order==2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[23 26]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[23 26])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[35 38]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{10}(trialnum)==[35 38])*P{16}(trialnum)/1000; %sum only choice
                    end
                    
                elseif strcmp(P{13}(trialnum),'i') % chose the right image
                    if P{3}(trialnum) == 1 %order 1 or 2
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[24 25]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[24 25])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[36 37]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[36 37])*P{16}(trialnum)/1000; %sum only choice
                        
                    else
                        choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choices(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[23 26]);
                        choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[23 26])*P{16}(trialnum)/1000;
                        
                        choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNot(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[35 38]); %sum only choice
                        choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4) = choicesNotRT(subjInd,P{14}(trialnum)+(P{4}(trialnum)-1)*4)+sum(P{11}(trialnum)==[35 38])*P{16}(trialnum)/1000; %sum only choice
                    end
                end
                
                
                
                
                
                
                
        end % end switch trialtype
        
    end % end run across all trials
    
    
end % run across subject



average_chiocesRT = choicesRT./choices ;
average_choicesNotRT = choicesNotRT./choicesNot;

[h,p] = ttest(choices(:,1)+choices(:,5),64);
[h,p] = ttest(choices(:,2)+choices(:,6),64);

highs = choices(:,1)+choices(:,5);
lows = choices(:,2)+choices(:,6);
highs_ratio=highs./(choices(:,1)+choices(:,5)+choicesNot(:,1)+choicesNot(:,5))
mean(highs_ratio)
lows_ratio=lows./(choices(:,2)+choices(:,6)+choicesNot(:,2)+choicesNot(:,6))
mean(lows_ratio)

sanity_go=choices(:,3)+choices(:,7);
sanity_go_ratio = sanity_go./(choices(:,3)+choices(:,7)+choicesNot(:,3)+choicesNot(:,7))
mean(sanity_go_ratio)
sanity_stop=choices(:,4)+choices(:,8);
sanity_stop_ratio = sanity_stop./(choices(:,4)+choices(:,8)+choicesNot(:,4)+choicesNot(:,8))
mean(sanity_stop_ratio)



mean(lows(find(highs>64)))
mean(highs(find(lows>64)))


highs_ratio = highs./(choices(:,1)+choices(:,5)+choicesNot(:,1)+choicesNot(:,5))
lows_ratio = lows./(choices(:,2)+choices(:,6)+choicesNot(:,2)+choicesNot(:,6))


%   mean(lows(find(highs>16)))
%   mean(highs(find(lows>16)))


(sanity_go-mean(sanity_go))/sqrt(var(sanity_go));
(sanity_stop-mean(sanity_stop))/sqrt(var(sanity_stop));

meanRT_highsgo=mean(average_chiocesRT(:,1)+average_chiocesRT(:,5),2)
meanRT_highsnogo=mean(average_choicesNotRT(:,1)+average_choicesNotRT(:,5),2)
meanRT_lowsgo=mean(average_chiocesRT(:,2)+average_chiocesRT(:,6),2)
meanRT_lowsnogo=mean(average_choicesNotRT(:,2)+average_choicesNotRT(:,6),2)

[h,p] = ttest2(lows_ratio(find(order_probe(:)==2)),lows_ratio(find(order_probe(:,1)==1)))
[h,p] = ttest2(highs_ratio(find(order_probe(:)==2)),highs_ratio(find(order_probe(:,1)==1)))
[h,p] = ttest(highs_ratio(find(order_probe(:)==2)),0.5)
[h,p] = ttest(highs_ratio(find(order_probe(:)==1)),0.5)
[h,p] = ttest(highs_ratio,0.5)
[h,p] = ttest(lows_ratio,0.5)
[h,p] = ttest(lows_ratio(find(order_probe(:)==2)),0.5)
[h,p] = ttest(lows_ratio(find(order_probe(:)==1)),0.5)

ratio_choices_higher_HV = choices_Higher_HV./(choices_Higher_HV+choicesNot_Higher_HV)
mean_ratio_choices_higher_HV = mean(ratio_choices_higher_HV)
ratio_choices_lower_HV = choices_Lower_HV./(choices_Lower_HV+choicesNot_Lower_HV)
mean_ratio_choices_lower_HV = mean(ratio_choices_lower_HV)
ratio_choices_between_HV = choices_between_HV./(choices_between_HV+choicesNot_between_HV)
mean_ratio_choices_between_HV = mean(ratio_choices_between_HV)

ratio_choices_higher_LV = choices_Higher_LV./(choices_Higher_LV+choicesNot_Higher_LV)
mean_ratio_choices_higher_LV = mean(ratio_choices_higher_LV)
ratio_choices_lower_LV = choices_Lower_LV./(choices_Lower_LV+choicesNot_Lower_LV)
mean_ratio_choices_lower_LV = mean(ratio_choices_lower_LV)
ratio_choices_between_LV = choices_between_LV./(choices_between_LV+choicesNot_between_LV)
mean_ratio_choices_between_LV = mean(ratio_choices_between_LV)




