-- @description Solo All Tracks
-- @author fuse
-- @version 1.0
-- @about 
-- Add fade-in and fade-out to selected items with User Interface 

-- Fuse Script  /  Tested only on windows.
--=======================================================================================
--SYSTEM REQUIREMENTS:                 |  
--(+) - required for installation      | (+) -
--(-) - not necessary for installation | (-) - 
-----------------------------------------------------------------------------------------
--(+) Reaper v.7.16 +             --| http://www.reaper.fm/download.php
--(-) SWS v.2.14.0.3 +            --| http://www.sws-extension.org/index.php
--(-) ReaPack v.1.4.6 +           --| http://reapack.com/repos
--=======================================================================================]]

--------------------------------
-- INTERFACE UTILISATEUR --
--------------------------------
local retval, inputs = reaper.GetUserInputs(
"Ajouter des fades",
2,
"Fade-in (secondes),Fade-out (secondes)",
"0.02,0.05"
)

if not retval then return end

local fade_in_len, fade_out_len = inputs:match("([^,]+),([^,]+)")
fade_in_len = tonumber(fade_in_len)
fade_out_len = tonumber(fade_out_len)

if not fade_in_len or not fade_out_len then
reaper.ShowMessageBox("Valeurs invalides", "Erreur", 0)
return
end
--------------------------------

reaper.Undo_BeginBlock()
reaper.PreventUIRefresh(1)

local item_count = reaper.CountSelectedMediaItems(0)

if item_count == 0 then
	reaper.ShowMessageBox("Aucun item sélectionné", "Erreur", 0)
else
	for i = 0, item_count - 1 do
		local item = reaper.GetSelectedMediaItem(0, i)
		if item then
		local length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")


		-- Sécurité : éviter un fade plus long que l'item
		local fi = math.min(fade_in_len, length / 2)
		local fo = math.min(fade_out_len, length / 2)


		reaper.SetMediaItemInfo_Value(item, "D_FADEINLEN", fi)
		reaper.SetMediaItemInfo_Value(item, "D_FADEOUTLEN", fo)
		end
	end
end


reaper.PreventUIRefresh(-1)
reaper.UpdateArrange()
reaper.Undo_EndBlock("Ajouter fade-in et fade-out aux items sélectionnés", -1)