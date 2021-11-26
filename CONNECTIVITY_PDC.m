function [ePDC, f, p_e]=CONNECTIVITY_PDC(folder_address, file_name, fc, nfft, idMode, p, show)
    %% Read DATA %%
    Y=schizo_eeg_converter_func(folder_address, file_name);
    %% Parameters %%
    % fc=128; %sample frequ
    % nfft=7680; % number of frequency bins
    % idMode=0; %identification algorithm (0:Least Squares covariance
    % p=5; %order of MVAR
    % show ; if is True/true, show ePDCs
    %% outputs %%
    % ePDC
    % p_e ; estimated order
    %% PDC - MVAR model - Effective Connectivity %%
    %% Estimate Order %%
    pcrit='aic';
    if pcrit(1)=='a' || pcrit(1)=='m' 
        [pottaic,pottmdl,aic,mdl] = mos_idMVAR(Y,20,idMode);
        if pcrit(1)=='a', p_e=pottaic; else p_e=pottmdl; end
    else
        p_e=pcrit; % p estimation
    end
    %% Estimate Coeeff %%
    [eAm,eSu,~,~]=idMVAR(Y,p,idMode);
    %% %%% Estimated spectral functions
    % [~,~,pdc,gpdc,~,~,~,~,~,~,f] = fdMVAR(Am,Su,nfft,fc);
    [~,~,~,gpdc2,~,~,~,~,~,~,f] = fdMVAR(eAm,eSu,nfft,fc);
    ePDC=abs(gpdc2).^2; % partial directed coherence
    %% SHOW %%
    if strcmpi(show,'True')
        %% reshape in order to plot %%
        % This section perform due to reduce computational cost
        mydata=zeros(4,4,nfft,16);
        k=1;
        % convert ePDC to a 4D-Tesnor
        for i=0:3
            for j=0:3 
                mydata(:,:,:,k)=ePDC((4*i+1):(4*i+4),...
                                     (4*j+1):(4*j+4),...
                                      :            );
                k=k+1;
            end
        end
        %% Plot 4D-Tesnor %% 
        M=size(eAm,1);
        for k=1:16
            figure(k)
            sgtitle(['Block', num2str(k) ,'th'])
            q=1;
            for i=1:M/4          
                for j=1:M/4
                    subplot(4,4,q);
                    plot(f, squeeze(mydata(i,j,:,k)),'r'); hold on; 
                    grid on;
                    axis([0 fc/2 -0.05 1.05]); 
                    title(['PDC : ',num2str(j),'\rightarrow',num2str(i)])
                    q=q+1;
                end
            end
        end
    end
end