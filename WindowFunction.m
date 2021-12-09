classdef WindowFunction

    properties
        relAmpVec (1, :)
        relTimeVec (1, :)
    end

    methods
        function obj = WindowFunction(nRelAmpVec, nRelTimeVec)
            % Constructor
            arguments
                nRelAmpVec (1, :)
                nRelTimeVec (1, :)
            end
            obj.relAmpVec = nRelAmpVec;
            obj.relTimeVec = nRelTimeVec;  
        end

        function [xVec, yVec] = calcWindowFunction(self, count)
            arguments
                self
                count (1, :)
            end
            clc;
            nCount = floor(count);
            nTVec = floor(self.relTimeVec * nCount) + 1;       % Zeitvektor
            segmentCount = max(size(self.relTimeVec)); % size liefert Zeilen- und Spaltenzahl
            for k = 1 : segmentCount - 1  % bearbeiten der Abschnitte
                inc = (self.relAmpVec(k + 1) - self.relAmpVec(k)) / (nTVec(k + 1) - nTVec(k));
                indexVec = nTVec(k) : nTVec(k + 1) - 1;

                % Abfrage: Sind zwei aufeinder folgende Werte gleich, dann muss
                % ein Eingriff erfolgen, sonst gibt es in der Zeile
                % yVec(indexVec) = ampVec(k) : inc : ampVec(k+1) - inc; einen Fehler,
                % weil inc dann Null ist!!
                
                if ( inc == 0 )
                    yVec(indexVec) = self.relAmpVec(k);
                else
                    yVec(indexVec) = self.relAmpVec(k) : inc : self.relAmpVec(k + 1) - inc;
                end
                stepPeriod = 1 / count;
                xVec = 0 : stepPeriod : 1 - stepPeriod;
            end
        end
    end
end