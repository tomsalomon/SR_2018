function [ flag ] = initiation(assignment_type, session_type )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

if  strcmp(session_type,'Snacks and Faces')==1 && strcmp(assignment_type,'ItemRankingResults and BDM')==1
    flag=[0 1 2 3];
elseif  strcmp(session_type,'Snacks')==1 && strcmp(assignment_type,'ItemRankingResults and BDM')==1
    flag=[0 1];
    elseif  strcmp(session_type,'Faces')==1 && strcmp(assignment_type,'ItemRankingResults and BDM')==1
        flag=[2 3];
        elseif  strcmp(session_type,'Snacks and Faces')==1 && strcmp(assignment_type,'ItemRankingResults')==1
            flag=[0 2];
            elseif  strcmp(session_type,'Snacks and Faces')==1 && strcmp(assignment_type,'BDM')==1
                flag=[1 3];
                elseif  strcmp(session_type,'Snacks')==1 && strcmp(assignment_type,'ItemRankingResults')==1
                    flag=0;
                    elseif  strcmp(session_type,'Snacks')==1 && strcmp(assignment_type,'BDM')==1
                        flag=1;
                        elseif  strcmp(session_type,'Faces')==1 && strcmp(assignment_type,'ItemRankingResults')==1
                           flag=2;
                           elseif  strcmp(session_type,'Faces')==1 && strcmp(assignment_type,'BDM')==1
                              flag=3;
end
end

