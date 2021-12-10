classdef Tone

    properties     
        sampleRate double
        samplePeriod double
        duration double
        timeVector (1,:)
        ampVector (1,:)        
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
            obj.duration = duration;
            obj.sampleRate = sampleRate;
            obj.samplePeriod = 1 / sampleRate;
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

        function self = interferSounds(self, others)
            % Interfers the sound it self, with given other tones as props
            % for any wanted Duration
            arguments
                self
                others(1, :)
            end

            for i = 1 : length(others)
                if ~(self.sampleRate == others(i).sampleRate)
                    return;
                end
                self.ampVector = self.ampVector(1:self.sampleRate) + others(i).ampVector(1:self.sampleRate);
            end     
        end

        function self = concatTone(self, others)
            arguments
                self
                others(1, :)
            end
            totalDuration = self.duration;
            for i = 1 : length(others)
                if ~(self.sampleRate == others(i).sampleRate)
                    return;
                end
                totalDuration = totalDuration + others(i).duration;
                self.ampVector = [self.ampVector others(i).ampVector];
            end  
            self.duration = totalDuration;
            self.timeVector = 0 : self.samplePeriod : totalDuration - self.samplePeriod;
        end

        function self = repeat(self, N)
            arguments
                self
                N int32
            end
            self.timeVector = 0 : self.samplePeriod : double(N) * self.duration - self.samplePeriod;
            self.ampVector = repmat(self.ampVector, 1, N);
        end

        function play(self)
            % Sends the time discrete signal to the speakers
            sound(self.ampVector, double(self.sampleRate));
        end

    end
end