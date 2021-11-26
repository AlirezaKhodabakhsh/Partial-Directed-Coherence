clearvars;
close all;
clc;
%% Achieve estimated PDC from "CONNECTIVITY_PDC" %%
[ePDC, f,p_e]=CONNECTIVITY_PDC('A:\Term 5th\Paper\MVAR&PDC - MatLab\SCHIZO',...
    '32w1.eea', 128, 7680, 0, 5, 'TRUE');
%% Convert ePDC to Connectivity Matrix %%
freq_range=[1,4;4,7;8,13;14,30;30,64]; %frequency range EEG signal
connectivity_matrix=zeros(16,16,5);
for k=1:5 % k:different frequency EEG bands
    for i=1:16
        for j=1:16
            %find index of frequency range 
            freq_indx=(find(f>=freq_range(k,1) & f<=freq_range(k,2)));
            %averange of band limited ePDC
            connectivity_matrix(i,j,k)=mean(squeeze(ePDC(i,j,freq_indx)));
            %delete diag elemets
            connectivity_matrix(:,:,k)=connectivity_matrix(:,:,k)-diag(diag(connectivity_matrix(:,:,k)));
        end
    end
end
%% Save in manual directory to use in Python %%
save('A:\Term 5th\Paper\MVAR&PDC - MatLab\connectivity matrix for python\subject_schizo_2')