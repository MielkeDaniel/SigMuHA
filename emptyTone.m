classdef EmptyTone < Tone 
    properties
    end

    methods
        function obj = EmptyTone(sampleRate)
           obj = obj@Tone([], [], [], 0, sampleRate);
      end
    end
end