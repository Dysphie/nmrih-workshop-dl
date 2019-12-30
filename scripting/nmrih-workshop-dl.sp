#pragma semicolon 1
#pragma newdecls required

#include <sourcemod>

ConVar cvWorkshopMapID;
char configPath[PLATFORM_MAX_PATH];

public Plugin myinfo =
{
	name = "[NMRiH] WorkshopDL",
	author = "Dysphie",
	description = "Make clients able to download maps through the workshop servers.",
	version = "1.0.1",
	url = ""
};

public void OnPluginStart()
{
	cvWorkshopMapID = FindConVar("sv_workshop_map_id");
	BuildPath(Path_SM, configPath, sizeof(configPath), "configs/workshop-dl.cfg");

	if(!FileExists(configPath))
		SetFailState("File not found: %s", configPath);
}

public void OnMapStart()
{
	char mapName[PLATFORM_MAX_PATH];
	GetCurrentMap(mapName, sizeof(mapName));

	int workshopID = GetWorkshopIdForMapName(mapName);
	if(workshopID)
		cvWorkshopMapID.SetInt(workshopID);
}

public int GetWorkshopIdForMapName(const char[] mapName)
{
	KeyValues kv = new KeyValues("WorkshopMaps");
	kv.ImportFromFile(configPath);

	int workshopID;
	if(kv.JumpToKey(mapName))
		workshopID = kv.GetNum("workshop_id");

	delete kv;
	return workshopID;
}