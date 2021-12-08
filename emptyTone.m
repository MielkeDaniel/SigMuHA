classdef EmptyTone < Tone 
    properties
    end

    methods
        function obj = EmptyTone(sampleRate)
           obj = obj@Tone([], [], [], 0, smapleRate);
      end
    end
end