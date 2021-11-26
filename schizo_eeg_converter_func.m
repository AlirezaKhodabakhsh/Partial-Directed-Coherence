function EEG=schizo_eeg_converter_func(address, name)
    %% Parameters %%
    % address = directory of file that contain datas (NOTE: don't feed directory of data, feed just directory of Folder)
    X=importdata([address,'\' ,name]);
    num_sample=numel(X)/16;
    %% Reshape %%
    EEG=zeros(16,num_sample);
    for j=1:16
        Start=(j-1)*num_sample + 1;
        End=j*num_sample;
        EEG(j,:)=X(Start:End,1)';
    end
end