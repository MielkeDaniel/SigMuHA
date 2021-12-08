classdef Instruments

    properties
        scale (1, :)
        baseTone Tone
        toneNames (1 , :)
    end

    methods
        function obj = Instruments(instrument)
            arguments
                instrument string
            end
            if(instrument == "guitar")
                obj.baseTone = Tone(1, 82 * nthroot(2,12)^0, -pi/2, 1, 11025);
                obj.scale = [];
                for i = 1 : 6
                    newTone = Tone(1, 82 * nthroot(2,12)^(i - 1), -pi/2, 1, 11025);
                    obj.scale = [obj.scale newTone];
                end
                obj.toneNames = ["E", "A", "D", "G", "H", "E"];
            else if(instrument == "piano")
                    obj.baseTone = Tone(1, 82 * nthroot(2,12)^0, -pi/2, 1, 11025);
                    obj.scale = [];
                    for i = 1 : 88
                        newTone = Tone(1, 27.5 * nthroot(2,12)^(i - 1), -pi/2, 1, 11025);
                        obj.scale = [obj.scale newTone];
                    end
                    allTones = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"];
                    for i = 1 : 7
                        for j = 1 : 12
                        obj.toneNames = [obj.toneNames allTones(j)];
                        end
                    end
                    obj.toneNames = [obj.toneNames "A", 'A#', "B", "C"];
            else
                ME = MException('MyComponent:noSuchInstrument', ...
                    'Instrument %s not found', instrument);
                throw(ME)
            end
            end
        end
    end
end