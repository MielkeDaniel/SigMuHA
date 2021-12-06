classdef Tone

    properties
        amplitudes (1,:)
        frequencies (1,:)
        phases (1,:)
        sampleRate int32
        duration double
        timeVector (1,:)
        dataVector (1,:)
    end

    methods (Static)
        function tone = createFromData(timeVector, dataVector, sampleRate)
            % Description:
            %   Constructs a new signal based on a time vector and a data
            %   vector.
            % 
            % Syntax:
            %   signal = Signal.createFromData(t, y,
            %   fa)
            arguments
                timeVector (1,:)
                dataVector (1,:)
                sampleRate double
            end

            duration = length(timeVector) / sampleRate;

            % Execute the fourier transform to extract amplitudes,
            % frequencies and phases of the signal.
            Y = fft(dataVector, sampleRate) / (sampleRate / 2);
            frequencies = 0 : length(Y)-1;
            amplitudes = abs(Y);
            phases = angle(Y);

            % Half sample rate
            hsr = floor(sampleRate / 2);

            % Construct the signal until the elements up the the half
            % sample rate.
            tone = Signal( ...
                amplitudes(1:hsr), ...
                frequencies(1:hsr), ...
                phases(1:hsr), ...
                duration, ...
                sampleRate);
        end
    end

    methods (Access = public)

        function obj = Signal(amplitudes, frequencies, phases, duration, sampleRate)
            % Constructor
            arguments
                amplitudes (1,:)
                frequencies (1,:)
                phases (1,:)
                duration double
                sampleRate int32 = 11025
            end

            obj.amplitudes = amplitudes;
            obj.frequencies = frequencies;
            obj.phases = phases;
            obj.duration = duration;
            obj.sampleRate = sampleRate;

            [timeVector, dataVector] = obj.generateSound(amplitudes, frequencies, phases, sampleRate, duration);
            obj.dataVector = dataVector;
            obj.timeVector = timeVector;
        end

        function play(self)
            % Sends the time discrete signal to the speakers
            sound(self.dataVector, double(self.sampleRate));
        end

        function plot(self, plotTitle)
            % This method plots the signal. Can be used with figure.
            arguments
                self
                plotTitle string = ""
            end

            plot(self.timeVector, self.dataVector);
            title(plotTitle);
            xlabel("Time [s]");
            ylabel("Amplitude");
        end

        function signal = repeat(self, N)
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

            dt = 1 / double(self.sampleRate);
            newTimeVector = 0 : dt : double(N) * self.duration - dt;
            newDataVector = repmat(self.dataVector, 1, N);

            signal = Signal.createFromData(newTimeVector, newDataVector, self.sampleRate);
        end
    end

    methods (Access = private)
        function [t, y] = generateSound(~, amplitudes, frequencies, phases, sampleRate, duration)
            % Description:
            %   This function generates a signal using the elements of the given
            %   amplitude, frequency and phase vectors. Cosine waves are used for
            %   synthesis.
            %
            % Syntax:
            %   [t, y] = generateSound(A, f, p, fa, t) returns a time vector t and
            %   the sum of wave functions y.
            num_amps = length(amplitudes);
            sample_period = 1 / double(sampleRate);
            
            t = 0 : sample_period : duration - sample_period;
            y = zeros(1, length(t));
        
            for i = 1:num_amps
                A = amplitudes(i);
                f = frequencies(i);
                p = phases(i);
        
                y = y + A * cos(2*pi*f*t + p);
            end
        end
    end
end
