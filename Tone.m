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
    

    methods 
        function obj = Tone(amplitudes, frequencies, phases, duration, sampleRate)
            % Constructor
            arguments
                amplitudes (1,:)
                frequencies (1,:)
                phases (1,:)
                duration double
                sampleRate double = 11025
            end            

            obj.amplitudes = amplitudes;
            obj.frequencies = frequencies;
            obj.phases = phases;
            obj.duration = duration;
            obj.sampleRate = sampleRate;

            [timeVector, ampVector] = obj.generateSound(amplitudes, frequencies, phases, sampleRate, duration);
            obj.ampVector = ampVector;
            obj.timeVector = timeVector;
        end

        function [timeVector, ampVector] = generateSound(self, amplitudes, frequencies, phases, sampleRate, duration)
          % Description:
          %   This function generates a signal using the elements of the given
          %   amplitude, frequency and phase vectors. Cosine waves are used for
          %   synthesis.
          %           % Syntax:
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

        function [timeVector, ampVector] = interferSounds(self, tones)

            for i = 1 : length(tones)
                if ~(self.sampleRate == tones(i).sampleRate)
                    return;
                end
                disp("passt");
            end
            timeVector = 1;
            ampVector = 1;
        end

    end
end