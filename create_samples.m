function [samples, nSamples, sampleLength] = create_samples(signal,sampleRate,sampleLengthTime)
% CREATE_SAMPLES  Divivides an signal into samples.
%   signal - Input signal
%   sampleRate - Number of samples per time unit
%   sampleLengthTime - Length of each sample in time units

sampleLength=floor(sampleLengthTime*sampleRate); % The number of elements in the samples

sampleLength=2^(nextpow2(sampleLength)); % Make the sample to the next power of 2

signalSize=size(signal);
signalLength= signalSize(1);
signalChannels=signalSize(2);
nSamples=floor(signalLength/sampleLength);

samples = zeros(sampleLength,nSamples);

for i=1:nSamples
    sStart=(i-1)*sampleLength+1;
    sEnd=i*sampleLength;
    samples(:,i)=sum(signal(sStart:sEnd,:),2)/signalChannels;
end


end