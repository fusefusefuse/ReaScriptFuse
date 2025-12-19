-- @description Solo Selected Tracks
-- @author fuse
-- @version 1.1  
-- @about 
--   This is a small script for make group items realign, use for making soundbank.

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


-- Réaligner tous les items sélectionnés pour qu'ils soient collés les uns aux autres
reaper.Undo_BeginBlock() -- Début du bloc d'annulation

-- Récupère le nombre d'items sélectionnés
local itemCount = reaper.CountSelectedMediaItems(0)

if itemCount > 0 then
    -- Crée une table pour stocker les items sélectionnés
    local selectedItems = {}

    -- Ajoute les items sélectionnés dans une table
    for i = 0, itemCount - 1 do
        local item = reaper.GetSelectedMediaItem(0, i)
        if item then
            table.insert(selectedItems, item)
        end
    end

    -- Trie les items sélectionnés par leur position de départ sur la timeline
    table.sort(selectedItems, function(a, b)
        return reaper.GetMediaItemInfo_Value(a, "D_POSITION") < reaper.GetMediaItemInfo_Value(b, "D_POSITION")
    end)

    -- Réaligne les items (sans interférer avec la boucle)
    local previousItemEnd = nil

    -- Pré-calculer les nouvelles positions des items
    local newPositions = {}

    for _, item in ipairs(selectedItems) do
        local itemLength = reaper.GetMediaItemInfo_Value(item, "D_LENGTH")
        if previousItemEnd then
            table.insert(newPositions, previousItemEnd)
            previousItemEnd = previousItemEnd + itemLength
        else
            -- Premier item reste à sa position actuelle
            local currentPos = reaper.GetMediaItemInfo_Value(item, "D_POSITION")
            table.insert(newPositions, currentPos)
            previousItemEnd = currentPos + itemLength
        end
    end

    -- Appliquer les nouvelles positions
    for i, item in ipairs(selectedItems) do
        reaper.SetMediaItemInfo_Value(item, "D_POSITION", newPositions[i])
    end

    -- Actualiser l'affichage pour refléter les changements
    reaper.UpdateArrange()
else
    reaper.ShowMessageBox("Aucun item sélectionné.", "Erreur", 0)
end

reaper.Undo_EndBlock("Réaligner les items sélectionnés", -1) -- Fin du bloc d'annulation