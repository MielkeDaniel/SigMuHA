classdef emptyTone < Tone 
    properties
    end

    methods
        function obj = emptyTone(amplitudes, frequencies, phases, duration, sampleRate)
           obj = obj@Tone([], [], [], 0, 0);
      end
    end
end