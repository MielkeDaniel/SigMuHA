classdef Tone

    properties
        amplitudes (1,:)
        frequencies (1,:)
        phases (1,:)        
        sampleRate double
        duration double
        timeVector (1,:)
        ampVector (1,:)        
    end
    

    methods (Static)
        function tone = createFromData(timeVector, ampVector, sampleRate)
            % Description:
            %   Constructs a new signal based on a time vector and a data
            %   vector.
            % 
            % Syntax:
            %   signal = Signal.createFromData(t, y,
            %   fa)
            arguments
                timeVector (1,:)
                ampVector (1,:)
                sampleRate double
            end

            duration = length(timeVector) / sampleRate;

            % Execute the fourier transform to extract amplitudes,
            % frequencies and phases of the signal.
            Y = fft(ampVector, sampleRate) / (sampleRate / 2);
            frequencies = 0 : length(Y)-1;
            amplitudes = abs(Y);
            phases = angle(Y);

            % Half sample rate
            hsr = floor(sampleRate / 2);

            % Construct the signal until the elements up the the half
            % sample rate.
            tone = Tone( ...
                amplitudes(1:hsr), ...
                frequencies(1:hsr), ...
                phases(1:hsr), ...
                duration, ...
                sampleRate);
        end
    end
    
    methods (Access = public)
        function obj = Tone(amplitudes, frequencies, phases, duration, sampleRate)
            % Constructor
            arguments
                amplitudes (1,:)
                frequencies (1,:)
                phases (1,:)
                duration double
                sampleRate double = 11025
            end            
            % Sets given properties to object´s properties
            obj.amplitudes = amplitudes;
            obj.frequencies = frequencies;
            obj.phases = phases;
            obj.duration = duration;
            obj.sampleRate = sampleRate;
            % Generates the Signalvectors with given properties
            [timeVector, ampVector] = obj.generateSound(amplitudes, frequencies, phases, sampleRate, duration);
            obj.ampVector = ampVector;
            obj.timeVector = timeVector;
        end

        function [timeVector, ampVector] = generateSound(self, amplitudes, frequencies, phases, sampleRate, duration)
          % Description:
          %   This function generates a signal using the elements of the given
          %   amplitude, frequency and phase vectors.
          %   Syntax:
          %   [t, y] = generateSound(A, f, p, fa, t) returns a time vector t and
          %   the sum of wave functions y.
          num_amps = length(amplitudes);
          sample_period = 1 / double(sampleRate);
          
          timeVector = 0 : sample_period : duration - sample_period;
          ampVector = zeros(1, length(timeVector));
        
          for i = 1 : num_amps
              A = amplitudes(i);
              f = frequencies(i);
              p = phases(i);
        
              ampVector = ampVector + A * cos(2 * pi * f * timeVector + p);
          end
        end

        function newTone = interferSounds(self, tones, newDuration)
            % Interfers the sound it self, with given other tones as props
            % for any wanted Duration
            arguments
                self
                tones(1, :)
                newDuration int32
            end
            
            newFreqs = [self.frequencies];
            newAmps = [self.amplitudes];
            newPhases = [self.phases];
            % Collects each frequencies, amplitudes and phases from the
            % tonesvector, to create a new tone out of them afterwards
            for i = 1 : length(tones)
                if ~(self.sampleRate == tones(i).sampleRate)
                    return;
                end
                newFreqs = [newFreqs tones(i).frequencies];
                newAmps = [newAmps tones(i).amplitudes];
                newPhases = [newPhases tones(i).phases];
            end     
            % Generates the new Tone
            newTone = Tone(newAmps, newFreqs, newPhases, newDuration, self.sampleRate); 
        end

        function [concattedTimeVec, concattedAmpVec] = concatTone(self, tones)
            arguments
                self
                tones(1, :)
            end
            concattedAmpVec = [self.ampVector];
            concattedTimeVec = [self.timeVector];
            addingTimeVec = [];
            for i = 1 : length(tones)
                concattedAmpVec = [concattedAmpVec tones(i).ampVector];
                samplePeriod = 1 / tones(i).sampleRate;
                addingTimVec = concattedTimeVec(length(concattedTimeVec)) : samplePeriod : concattedTimeVec(length(concattedTimeVec)) + tones(i).duration - samplePeriod
                concattedTimeVec = [concattedTimeVec addingTimVec];
            end       
        end

        function tone = repeat(self, N)
            % Description:
            %   Returns a time vector and data vector containing information
            %   about this signal repeated N times using the FFT.
            %
            % Syntax:
            %  signal = obj.repeat(N) returns the repeated signal
            arguments
                self
                N int32
            end

            samplePeriod = 1 / double(self.sampleRate);
            newTimeVector = 0 : samplePeriod : double(N) * self.duration - samplePeriod;
            newAmpVector = repmat(self.ampVector, 1, N);

            tone = Tone.createFromData(newTimeVector, newAmpVector, self.sampleRate);
        end

        function play(self)
            % Sends the time discrete signal to the speakers
            sound(self.ampVector, double(self.sampleRate));
        end

    end
end