clear all, close all, clc

% Add all subfolders to current path
addpath( genpath('.') );


[audio,sampleRate]=load_song('queen.mp3');

[samples,nSamples,sampleLength]=create_samples(audio,sampleRate,0.001);

nFreq=1;

strS=zeros(nSamples,nFreq);
freqS=zeros(nSamples,nFreq);

fourieredAmplitudes=abs(fft(samples)/sampleLength);

%% 
half=floor(sampleLength/2+1);
fourieredAmplitudes=fourieredAmplitudes(1:half,:);
fourieredAmplitudes(2:end-1)=2*fourieredAmplitudes(2:end-1);
    
minF=40;
f = sampleRate*(0:(sampleLength/2))/sampleLength;
maxF=160;

for i=1:nSamples   
    strengths=[];
    location=[];
    [strengths,location]=findpeaks(fourieredAmplitudes(:,i),'SortStr','descend');
    
    strengths(f(location)<minF==1)=[];
    location(find(f(location)<minF==1))=[];
    
    strengths(f(location)>maxF==1)=[];
    location(find(f(location)>maxF==1))=[];

    
    currentFrequencies=f(location);
    if (length(strengths)<nFreq)
        len=length(strengths);
        strS(i,:)=zeros(1,nFreq);
        freqS(i,:)=zeros(1,nFreq);
        for j=1:len
            strS(i,j)=strengths(j);
            freqS(i,j)=currentFrequencies(j);
        end
    else
        strS(i,:)=strengths(1:nFreq);
        freqS(i,:)=currentFrequencies(1:nFreq);
    end
    
    %remove
    sampleStart=(i-1)*sampleLength+1;
    sampleEnd=i*sampleLength;
    iters=min(nFreq,length(strengths));
    for j=1:iters
        pureAudioAmplitude(sampleStart:sampleEnd)=pureAudioAmplitude(sampleStart:sampleEnd)+strengths(j)*sin(currentFrequencies(j)*2*pi/(sampleRate)*(sampleStart:sampleEnd))';
    end
    
end


%%
pureAudioAmplitude=pureAudioAmplitude/max(pureAudioAmplitude);
figure(3)
plot(pureAudioAmplitude)
player=audioplayer(pureAudioAmplitude,sampleRate);
%%
player.play();