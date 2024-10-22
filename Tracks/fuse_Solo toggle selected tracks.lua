-- @description Solo Selected Tracks
-- @author fuse
-- @version 1.1  
-- @about 
--   This is a small script for soloing/unsoloing in toggle mode applied only to a selected group of tracks (rather than to all tracks).

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


-- Fonction pour vérifier si au moins une piste sélectionnée est solo
function AnySelectedTrackIsSoloed()
    selected_track_count = reaper.CountSelectedTracks(0)
    
    for i = 0, selected_track_count - 1 do
       
        track = reaper.GetSelectedTrack(0, i)
        solo_state = reaper.GetMediaTrackInfo_Value(track, "I_SOLO")
        
        if solo_state > 0 then
            return true
        
        end
    end

    return false
end

-- Fonction pour solo ou unsolo toutes les pistes sélectionnées
function ToggleSoloSelectedTracks()
    selected_track_count = reaper.CountSelectedTracks(0)
    unsolo = AnySelectedTrackIsSoloed()  -- Vérifie si une piste sélectionnée est solo
    
    for i = 0, selected_track_count - 1 do
        
        track = reaper.GetSelectedTrack(0, i)
        if unsolo then
            reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 0) 
        else
            reaper.SetMediaTrackInfo_Value(track, "I_SOLO", 1) 
        end
    end
end

-- Démarrer l'action
reaper.Undo_BeginBlock()
ToggleSoloSelectedTracks()
reaper.Undo_EndBlock("Basculer Solo / Unsolo des pistes sélectionnées", -1)

reaper.UpdateArrange()