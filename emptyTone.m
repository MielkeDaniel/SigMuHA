classdef EmptyTone < Tone 
    properties
    end

    methods
        function obj = EmptyTone(amplitudes, frequencies, phases, duration, sampleRate)
           obj = obj@Tone([], [], [], 0, 0);
      end
    end
end