-- This information tells other players more about the mod
name = "Whimsy the Goth (DST)"
description = "Whimsy, the Goth. Creature of darkness. Keep out of direct sunlight."
author = "VoidPointer2005"
version = "2.0.1"

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
-- Example:
-- http://forums.kleientertainment.com/showthread.php?19505-Modders-Your-new-friend-at-Klei!
-- becomes
-- 19505-Modders-Your-new-friend-at-Klei!
forumthread = "38766-character-mod-whimsy-the-goth"

-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 6
api_version_dst = 10

dst_compatible = true
dont_starve_compatible = true
reign_of_giants_compatible = false

--This lets clients know if they need to get the mod from the Steam Workshop to join the game
all_clients_require_mod = true
 
--This is basically the opposite; it specifies that this mod doesn't affect other players at all, and if set, won't mark your server as modded
client_only_mod = false

server_filter_tags = {"character", "whimsy"}

-- Can specify a custom icon for this mod!
icon_atlas = "modicon.xml"
icon = "modicon.tex"

configuration_options =
{
    {
        name = "magicAffinity",
        label = "Magic Affinity",
		options =
        {
            {description = "None", data = 0},
            {description = "Prestihatitator", data = 2},
            {description = "Shadow Manipulator", data = 3}
        },
        default = 2
    },
	{
        name = "ancientAffinity",
        label = "Ancient Affinity",
		options =
        {
            {description = "None", data = 0},
            {description = "Broken", data = 2},
            {description = "Fixed", data = 4}
        },
        default = 0
    },
	{
        name = "umbrellaLevel",
        label = "Starter Umbrella",
        options =
        {
            {description = "None", data = ""},
            {description = "Normal", data = "umbrella"},
            {description = "Lace", data = "whimsy_umbrella"},
            {description = "Night", data = "whimsy_night_umbrella"}
        },
        default = "whimsy_umbrella"
    },
	{
        name = "daySanityDrain",
        label = "Daytime Sanity Drain",
        options =
        {
            {description = "Low", data = 5},
            {description = "Medium", data = 10},
            {description = "High", data = 20},
            {description = "Brutal", data = 100}
        },
        default = 10
    },
	{
        name = "nightSanityGain",
        label = "Night Sanity Gain",
        options =
        {
            {description = "None", data = 0},
            {description = "Low", data = 5},
            {description = "Medium", data = 10},
            {description = "High", data = 20}
        },
        default = 5
    },
	{
        name = "magicRegenFactor",
        label = "Magic Regeneration Time",
		options =
        {
            {description = "Instant", data = 0.00001},
            {description = "10 Seconds", data = 10},
            {description = "30 Seconds", data = 30},
            {description = "60 Seconds", data = 60},
            {description = "None", data = 0}
        },
        default = 10
    },
	{
        name = "magicCostFactor",
        label = "Magic Sanity Costs",
		options =
        {
            {description = "No Cost", data = 0},
            {description = "1/8 Cost", data = 1.0/8.0},
            {description = "1/4 Cost", data = 1.0/4.0},
            {description = "1/2 Cost", data = 1.0/2.0},
            {description = "Normal Cost", data = 1}
        },
        default = 1.0/4.0
    },
	{
        name = "easyResurrect",
        label = "Easier Resurrection",
		options =
        {
            {description = "No", data = 0},
            {description = "Yes", data = 1}
        },
        default = 0
    },
	{
        name = "complainRate",
        label = "Grossness Complaints",
		options =
        {
            {description = "Never", data = 0},
            {description = "5 Percent", data = 0.05},
            {description = "10 Percent", data = 0.1},
            {description = "25 Percent", data = 0.25},
            {description = "50 Percent", data = 0.5},
            {description = "Always", data = 1}
        },
        default = 0.1
    },
	{
        name = "ghostResist",
        label = "Ghost Resistance (DST/RoG)",
		options =
        {
            {description = "None", data = 0},
            {description = "1/4", data = 1.0/4.0},
            {description = "1/2", data = 1.0/2.0},
            {description = "3/4", data = 3.0/4.0},
            {description = "Immune", data = 1}
        },
        default = 1.0/2.0
    },
	{
        name = "heatSanLoss",
        label = "Maximum Heat Sanity Loss (DST/RoG)",
        options =
        {
            {description = "None", data = 0},
            {description = "Low", data = 2},
            {description = "Medium", data = 4},
            {description = "High", data = 8}
        },
        default = 4
    },
	{
        name = "wetSanLoss",
        label = "Max Wetness Sanity Loss (DST/RoG)",
        options =
        {
            {description = "Very Low", data = 10},
            {description = "Low", data = 50},
            {description = "Medium", data = 100},
            {description = "High", data = 200}
        },
        default = 100
    },
}