function soundSignalGUI
    

  
    fig = figure('Name', 'Sound Signal GUI',  ...
                 'Position', [300, 100, 600, 500]);
    data.audioData = struct('noisyAudio', [], 'fs', []);
    guidata(fig, data);
          
    uicontrol('Style', 'pushbutton', 'Position', [50, 400, 200, 40], ...
              'String', 'Generate Beep Sound', 'Callback', @generateBeep);
          
    uicontrol('Style', 'pushbutton', 'Position', [350, 400, 200, 40], ...
              'String', 'Generate White Noise', 'Callback', @generateWhiteNoise);
          
    uicontrol('Style', 'pushbutton', 'Position', [50, 350, 200, 40], ...
              'String', 'Read and Play Audio', 'Callback', @readAndPlayAudio);
          
    uicontrol('Style', 'pushbutton', 'Position', [350, 350, 200, 40], ...
              'String', 'Add Noise to Audio', 'Callback', @(src, event)addNoise(fig));
          
    uicontrol('Style', 'pushbutton', 'Position', [50, 300, 200, 40], ...
              'String', 'Record and Save Audio', 'Callback', @recordAudio);
          
    uicontrol('Style', 'pushbutton', 'Position', [350, 300, 200, 40], ...
              'String', 'Increase Volume', 'Callback', @increaseVolume);

    uicontrol('Style', 'pushbutton', 'Position', [50, 250, 200, 40], ...
              'String', 'Decrease Volume', 'Callback', @decreaseVolume);
          
    uicontrol('Style', 'pushbutton', 'Position', [350, 250, 200, 40], ...
              'String', 'Increase Speed', 'Callback', @increaseSpeed);

    uicontrol('Style', 'pushbutton', 'Position', [50, 200, 200, 40], ...
              'String', 'Decrease Speed', 'Callback', @decreaseSpeed);
          
    uicontrol('Style', 'pushbutton', 'Position', [350, 200, 200, 40], ...
              'String', 'Echo Audio', 'Callback', @echoAudio);
          
    uicontrol('Style', 'pushbutton', 'Position', [50, 150, 200, 40], ...
              'String', 'Remove Noise', 'Callback', @(src, event)removeNoise(fig));
          
    uicontrol('Style', 'pushbutton', 'Position', [350, 150, 200, 40], ...
              'String', 'Subtract Signals', 'Callback', @signalsubstract);

    uicontrol('Style', 'pushbutton', 'Position', [50, 100, 200, 40], ...
              'String', 'Multiply Signals', 'Callback', @signalmultiply);
          
    uicontrol('Style', 'pushbutton', 'Position', [350, 100, 200, 40], ...
              'String', 'Plot Signal', 'Callback', @plotSignal);
    
    

    function generateBeep(~, ~)
        fs = 40000; 
        t = 0:1/fs:1; 
        f0 = 400; 
        beepSound = sin(2 * pi * f0 * t);
        sound(beepSound, fs);
    end

    function generateWhiteNoise(~, ~)
        A=0.05;
        fs = 40000; 
        time = 1;
        N=fs*time;
        noise =A*randn(1,N);
        sound(noise, fs);
    end

    function readAndPlayAudio(~, ~)
        [audio,fs] = audioread('/MATLAB Drive/calm.wav');
        sound(audio, fs);
       
    end


    function addNoise(fig)
            data = guidata(fig);
            [audio,fs] = audioread('/MATLAB Drive/calm.wav');
            noise = 0.05 * randn(size(audio));
            data.audioData.noisyAudio = audio + noise;
            data.audioData.fs = fs;
            guidata(fig, data);
            sound(data.audioData.noisyAudio, data.audioData. ...
                fs);
    end

    function recordAudio(~, ~)
        fs = 44100; 
        recObj = audiorecorder(fs, 16, 1); 
        disp('Recording for 5 seconds...');
        recordblocking(recObj, 5);
        disp('Recording complete.');
        y = getaudiodata(recObj);
        audiowrite('recorded_audio.wav', y, fs);
        disp('Audio saved as recorded_audio.wav');
        sound(y,fs)
    end

    function increaseVolume(~, ~)
            [audio, fs] = audioread('/MATLAB Drive/calm.wav');
            sound(3*audio, fs);
    end


    function decreaseVolume(~, ~)
            [audio, fs] = audioread('/MATLAB Drive/calm.wav');
            sound(0.5*audio, fs);
    end


    function increaseSpeed(~, ~)
       [audio, fs] = audioread('/MATLAB Drive/calm.wav');
       speed_factor=1.75;
       audiospeed=stretchAudio(audio,speed_factor);
       sound(audiospeed,fs);
    end

    function decreaseSpeed(~, ~)
       [audio, fs] = audioread('/MATLAB Drive/calm.wav');
       speed_factor=0.5;
       audiospeed=stretchAudio(audio,speed_factor);
       sound(audiospeed,fs);
    end

    function echoAudio(~, ~)
            [y, fs] = audioread('/MATLAB Drive/calm.wav');
            h=[1,zeros(1,0.4*fs),0.5,zeros(1,0.4*fs),0.25];
            echo=conv(y,h);
            sound(echo,fs)
    end


    function removeNoise(fig)
      data = guidata(fig);
      fc=1000;
      fs = data.audioData.fs;
      [b,a]=butter(6,fc/(fs/2),'low');
      filtered_audio=filter(b,a,data.audioData.noisyAudio);
      sound(filtered_audio,data.audioData.fs)
    end

    function signalsubstract(~, ~)
    [x, fs1] = audioread('/MATLAB Drive/calm.wav');
    [y, fs2] = audioread('/MATLAB Drive/Shrink-Ray.wav');
    
    if fs1 ~= fs2
        disp('Resampling audio files to match sample rates.');
        [y, fs1] = resample(y, fs1, fs2);
    end
    

    minLength = min(length(x), length(y));
    x = x(1:minLength); 
    y = y(1:minLength); 
    
   
    result_sub = x - y;
    
    audiowrite('result_sub.wav', result_sub, fs1);
    sound(result_sub, fs1);
    end


    function signalmultiply(~, ~)
    [x, fs1] = audioread('/MATLAB Drive/calm.wav');
    [y, fs2] = audioread('/MATLAB Drive/Shrink-Ray.wav');
    
    
    if fs1 ~= fs2
        disp('Resampling audio files to match sample rates.');
        [y, fs1] = resample(y, fs1, fs2);
    end
    
   
    minLength = min(length(x), length(y));
    x = x(1:minLength); 
    y = y(1:minLength);

   
    result_mult = x .* y;
    
  
    audiowrite('result_mult.wav', result_mult, fs1);
    sound(result_mult, fs1);
    end


    function plotSignal(~, ~)
        [audio1, fs1] = audioread('/MATLAB Drive/calm.wav');
        t = (0:length(audio1)-1) / fs1;
            figure;
            subplot(1, 2, 1);
            plot(t, audio1);
            title('Audio Signal 1');
            xlabel('Time (s)');
            ylabel('Amplitude');
            
        end
    
end
