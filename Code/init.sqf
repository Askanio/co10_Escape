private ["_useRevive"];
private ["_volume", "_dynamicWeather", "_isJipPlayer"];
private ["_showIntro", "_showPlayerMapAndCompass", "_fog", "_playerIsImmortal", "_playersEnteredWorld"];

diag_log format["init run for %1", name player];

_isJipPlayer = false;
if (!isServer && isNull player) then
{
    _isJipPlayer = true;
};

call compile preprocessFileLineNumbers "config.sqf";
call compile preprocessFileLineNumbers ("Island\WorldConfig.sqf");

_debug = a3e_debug;

// Initialization

a3e_var_Escape_firstPreloadDone = false;

if(isNil("a3e_var_commonLibInitialized")) then {
	call compile preprocessFileLineNumbers "Scripts\DRN\CommonLib\CommonLib.sqf";
};

a3e_var_Escape_playerEnteredWorld = false;


onPreloadFinished {
	if (!a3e_var_Escape_firstPreloadDone) then {
		a3e_var_Escape_firstPreloadDone = true;

		if (!isNull player) then {
            a3e_var_Escape_playerEnteredWorld = true;
            removeAllWeapons player;
            removeAllItems player;
            removeBackpack player;
		};
	};
};


//enableSaving [true, true];
enableSaving [ false, false ]; // Saving disabled without autosave.

// Initialization
a3e_arr_JipSpawnPos = [];
//call compile preprocessFileLineNumbers "Scripts\DRN\CommonLib\CommonLib.sqf";
//call drn_fnc_CL_InitParams;

//Wait until server has parsed the parameters
waituntil {!isNil("A3E_ParamsParsed")};

call compile preprocessFileLineNumbers "Scripts\Escape\Functions.sqf";
call compile preprocessFileLineNumbers "Scripts\Escape\AIskills.sqf";

//[_isJipPlayer] call compile preprocessFileLineNumbers "Briefing.sqf";

//[] call a3e_fnc_briefing;

setTerrainGrid (Param_Grass);


//ACE Revive
if ((isServer) && (isClass(configFile >> "CfgPatches" >> "ACE_Medical"))) then {
	countStarted = false;
	ACE_allUnconscious = false;
	ACE_UnconsciousPlayers = [];
	addMissionEventHandler ["HandleDisconnect", ACE_fnc_HandleDisconnect];
	["ace_unconscious", ACE_fnc_HandleUnconscious] call CBA_fnc_addEventHandler;
};
