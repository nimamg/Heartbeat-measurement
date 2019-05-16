videoFile = VideoReader("A.mp4");
k = 1;
frameCount = videoFile.NumberOfFrames;
m = zeros(1,frameCount);
videoFile = VideoReader("A.mp4");
while hasFrame(videoFile)
    videoFrame = readFrame(videoFile);
    r = videoFrame(:,:,1);
    m(k) = sum(sum(r)) / (size(videoFrame, 1) * size(videoFrame, 2));
    k = k+1;
end
t = zeros(1,frameCount);
for i = 1:frameCount
    t(i) = i;
end
t = t/30;
figure(1)
plot(t,m)
ylabel('Red Brightness')
xlabel('Time')
title('RB/Time Plot')

%%

fourier = abs(fft(m));
Fs = ceil(videoFile.FrameRate);
n = size(fourier);
n = n(2);

step = Fs/n;
startIndex = ceil((50 / step) / 60) + 1;
endIndex = floor((220 / step) / 60) + 1;
indexes = zeros(1,endIndex - startIndex + 1);
for i = startIndex:endIndex
    indexes(i - startIndex + 1) = step * 60 * (i-1);
    desiredRange(i - startIndex + 1) = fourier(i);
end

maximum = max(desiredRange);
maximumIndex = find(desiredRange == maximum);
heartRate = indexes(maximumIndex);

figure(2);
plot (indexes,desiredRange);
title('BPM Plot');
xlabel('BPM');
ylabel('Magnitude');
txt = strcat(" <- Your BPM = ", string(heartRate));
text(indexes(maximumIndex),desiredRange(maximumIndex), txt);
%%

fourier = fft(m)
trimmedFourier = zeros (1,frameCount);
for i = startIndex:endIndex
    trimmedFourier(i) = fourier(i);
    trimmedFourier(frameCount - i + 1) = fourier(frameCount - i + 1);
end

ppg = real(ifft(trimmedFourier));
figure(3)
plot(ppg);
title('PPG Signal');