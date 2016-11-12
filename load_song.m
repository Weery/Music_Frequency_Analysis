function [audioData, sampleRate] = load_song(songName)


[audioData, sampleRate] = audioread(songName);


end