-- On crée le menu une seule fois au chargement du script pour de meilleures performances.
-- On s'assure que le framework ESX est prêt avant de lancer le script
-- Si vous n'utilisez pas ESX, vous pouvez retirer ce bloc et remplacer les ESX.ShowNotification
ESX = nil
Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(100)
    end
end)

-- Création des menus
-- On les crée une seule fois pour optimiser les performances.
local menuf5       = RageUI.CreateMenu("Kira City", "Menu Personnel")
local menuActions  = RageUI.CreateSubMenu(menuf5, "Actions", "Actions du personnage")
local menuVehicles = RageUI.CreateSubMenu(menuf5, "Véhicule", "Options du véhicule")

-- On cache le menu principal au démarrage
RageUI.Visible(menuf5, false)

-- Fonction pour trouver le joueur le plus proche (utile pour les interactions)
function GetClosestPlayer()
    local players         = GetActivePlayers()
    local closestDistance = -1
    local closestPlayer   = -1
    local playerPed       = PlayerPedId()
    local playerCoords    = GetEntityCoords(playerPed, false)

    for i = 1, #players do
        local target = GetPlayerFromServerId(players[i])
        if target ~= PlayerId() then
            local targetPed = GetPlayerPed(target)
            local distance  = GetDistanceBetweenCoords(playerCoords, GetEntityCoords(targetPed, false), true)
            if closestDistance == -1 or closestDistance > distance then
                closestDistance = distance
                closestPlayer   = target
            end
        end
    end
    return closestPlayer, closestDistance
end

-- Boucle principale qui gère l'affichage de tous les menus
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0) -- Important pour ne pas surcharger le CPU

        -- Gestion de l'ouverture/fermeture avec la touche F5
        if IsControlJustPressed(1, 166) then
            if RageUI.Visible(menuf5) or RageUI.Visible(menuActions) or RageUI.Visible(menuVehicles) then
                RageUI.CloseAll() -- Ferme le menu principal et tous les sous-menus ouverts
            else
                RageUI.Visible(menuf5, true)
            end
        end

        -- DESSIN DU MENU PRINCIPAL
        RageUI.IsVisible(menuf5, true, true, true, function()

            -- Bouton pour ouvrir le sous-menu des actions
            RageUI.ButtonWithStyle("Actions Personnage", "Ouvrir le menu des actions roleplay.", { RightLabel = "→→→" }, true, function()
            end, menuActions) -- Le dernier argument lie ce bouton au sous-menu 'menuActions'

            -- Bouton pour ouvrir le sous-menu du véhicule (conditionnel)
            local playerPed = PlayerPedId()
            local inVehicle = IsPedInAnyVehicle(playerPed, false)
            RageUI.ButtonWithStyle("Options du Véhicule", "Gérer votre véhicule actuel.", { RightLabel = "→→→" }, inVehicle, function()
            end, menuVehicles) -- Le bouton est activé seulement si le joueur est dans un véhicule

            RageUI.Separator("~y~Interactions RP")

            -- Bouton pour présenter sa carte d'identité
            RageUI.ButtonWithStyle("Présenter sa carte d'identité", "Montre votre identité au joueur le plus proche.", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    local closestPlayer, closestDistance = GetClosestPlayer()
                    if closestPlayer ~= -1 and closestDistance < 3.0 then
                        -- Déclenche un événement côté serveur pour montrer l'identité
                        -- NOTE: Vous devrez créer l'événement 'votre_prefix:showIdentity' sur votre serveur.
                        TriggerServerEvent('votre_prefix:showIdentity', GetPlayerServerId(closestPlayer))
                        ESX.ShowNotification("Vous montrez votre carte d'identité.")
                    else
                        ESX.ShowNotification("Personne n'est assez proche.")
                    end
                end
            end)

            -- Bouton pour voir son propre ID serveur
            RageUI.ButtonWithStyle("Mon ID", "Affiche votre identifiant de joueur sur le serveur.", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    local playerId = GetPlayerServerId(PlayerId())
                    ESX.ShowNotification("Votre ID en jeu est : " .. playerId)
                end
            end)

        end, function() -- Panel d'information
        end)

        -- DESSIN DU SOUS-MENU ACTIONS
        RageUI.IsVisible(menuActions, true, true, true, function()

            RageUI.ButtonWithStyle("Lever les mains", "Lève les mains en l'air ou les baisse.", { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    local playerPed = PlayerPedId()
                    -- On vérifie si l'animation n'est pas déjà en cours pour pouvoir l'arrêter
                    if not IsEntityPlayingAnim(playerPed, "random@mugging3", "handsup_standing_base", 3) then
                        ESX.Streaming.RequestAnimDict("random@mugging3", function()
                            TaskPlayAnim(playerPed, "random@mugging3", "handsup_standing_base", 8.0, -8, -1, 49, 0, 0, 0, 0)
                        end)
                        ESX.ShowNotification("Vous levez les mains.")
                    else
                        ClearPedTasks(playerPed) -- Arrête l'animation
                        ESX.ShowNotification("Vous baissez les mains.")
                    end
                    RageUI.CloseAll() -- Ferme le menu après l'action
                end
            end)

        end, function()
        end)

        -- DESSIN DU SOUS-MENU VÉHICULE
        RageUI.IsVisible(menuVehicles, true, true, true, function()
            local playerPed = PlayerPedId()
            local vehicle   = GetVehiclePedIsIn(playerPed, false)

            -- On vérifie si le joueur est bien dans un véhicule (double sécurité)
            if not vehicle or vehicle == 0 then return end

            local isDriver = GetPedInVehicleSeat(vehicle, -1) == playerPed

            -- Actions réservées au conducteur
            if isDriver then
                RageUI.ButtonWithStyle("Démarrer / Couper le moteur", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                    if Selected then
                        local isEngineRunning = GetIsVehicleEngineRunning(vehicle)
                        SetVehicleEngineOn(vehicle, not isEngineRunning, false, true)
                        ESX.ShowNotification(isEngineRunning and "Moteur coupé." or "Moteur démarré.")
                    end
                end)
            else
                RageUI.Separator("~r~Actions réservées au conducteur")
            end

            RageUI.Separator("Portières")

            -- Actions pour tous les passagers
            RageUI.ButtonWithStyle("Ouvrir / Fermer les portes", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)
                if Selected then
                    -- Logique simple : si une porte est ouverte, on ferme tout. Sinon, on ouvre tout.
                    if GetVehicleDoorAngleRatio(vehicle, 0) > 0.0 then
                        for i = 0, 5 do SetVehicleDoorShut(vehicle, i, false) end
                        ESX.ShowNotification("Toutes les portes sont fermées.")
                    else
                        for i = 0, 5 do SetVehicleDoorOpen(vehicle, i, false, false) end
                        ESX.ShowNotification("Toutes les portes sont ouvertes.")
                    end
                end
            end)

        end, function()
        end)

    end
end)
