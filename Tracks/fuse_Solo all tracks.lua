-- @description Solo All Tracks
-- @author fuse
-- @version 1.0
-- @about 
--   This is a small script for soloing/unsoloing in toggle mode all tracks.

-- Fuse Script  /  Tested only on windows.
--=======================================================================================
--SYSTEM REQUIREMENTS:                 |  
--(+) - required for installation      | (+) -
--(-) - not necessary for installation | (-) - 
-----------------------------------------------------------------------------------------
--(+) Reaper v.7.16 +             --| http://www.reaper.fm/download.php
--(-) SWS v.2.14.0.3 +              --| http://www.sws-extension.org/index.php
--(-) ReaPack v.1.4.6 +           --| http://reapack.com/repos
--=======================================================================================]]

-- Solo toutes les pistes
function SoloAllTracks()
    
    track_count = reaper.CountTracks(0)
    
    for i = 0, track_count - 1 do
        
        track = reaper.GetTrack(0, i)
        reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 1)
    
    end

end


function UnSoloAllTracks()
	-- Unmute All Solo Tracks
	reaper.Main_OnCommand(40340, 0) -- interpreter une commande Reaper à l'intérieur du script

	track_solo_count = reaper.CountTracks(0)

	for j = 0, track_solo_count -1 do

		track_unsolo = reaper
end

reaper.Undo_BeginBlock()
SoloAllTracks()
reaper.Undo_EndBlock("Solo toutes les pistes", -1)

reaper.UpdateArrange()