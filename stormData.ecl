import $, std;
IMPORT $.^.Visualizer;

Layout := RECORD
	UNSIGNED6 BeginYearMonth;
	UNSIGNED2 BeginDay;
	UNSIGNED4 BeginTime;
	UNSIGNED6 EndYearMonth;
	UNSIGNED2 EndDay;
	UNSIGNED4 EndTime;
	UNSIGNED EpisodeID;
	UNSIGNED EventID;
	STRING20 State;
	UNSIGNED4 StateFips;
	UNSIGNED4 Year;
	STRING20 MonthName;
	STRING EventType;
	STRING1 CZType;
	UNSIGNED4 CZFips;
	STRING CZName;
	STRING10 WFO;
	STRING BeginDateTime;
	STRING CZTimezone;
	STRING EndDateTime;
	UNSIGNED InjuriesDirect;
	UNSIGNED InjuriesIndirect;
	UNSIGNED DeathDirect;
	UNSIGNED DeathIndirect;
	STRING DamageProperty;
	STRING DamageCrops;
	STRING Source;
	UNSIGNED Magnitude;       //check size
	STRING2 MagnitudeType;
	STRING FloodCause;
	STRING Category;
	STRING3 TorFScale;
	REAL4 TorLength;
	UNSIGNED TorWidth;
	STRING TorOtherWFO;
	STRING TorOtherCZState;
	STRING TorOtherCZFips;
	STRING TorOtherCZName;
	REAL BeginRange;
	REAL BeginAzimuth;
	STRING BeginLoaction;
	REAL EndRange;
	REAL EndAzimuth;
	STRING EndLocation;
	REAL4 BeginLat;
	REAL4 BeginLon;
	REAL4 EndLat;
	REAL4 EndLon;
	STRING EpisodeNarrative;
	STRING EventNarrative;
	STRING LastModDate;
	STRING LastModTime;
	STRING LastCertDate;
	STRING LastCertTime;
	STRING LastMod;
	STRING LastCert;
	STRING AddcorrFlg;
	STRING AddcorrDate;
END;

torFile := DATASET('~online::project::tornado::alldata__p454606156', Layout, THOR);
OUTPUT(COUNT(torFile), NAMED('ALLTornadoesCount'));
OUTPUT(torFile, NAMED('ALLTornadoes'));

locationEmptyFile := torFile(beginloaction <> '');
OUTPUT(count(locationEmptyFile), NAMED('HaveLocation'));

												
//Visualization 1
testCount := TABLE(locationEmptyFile, {beginloaction, state, c := COUNT(GROUP)}, beginloaction);
OUTPUT(SORT(testCount, -c), NAMED('Tornadoes_In_City'));
mappings :=  DATASET([  {'Location', 'beginloaction'}/*x*/, 
                        {'Tornadoes', 'c'}/*Y*/], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('Tornadoes_In_City_Chart', /*datasource*/, 'Tornadoes_In_City', mappings, /*filteredBy*/, /*dermatologyProperties*/ );

//Visualization 2
testCount2 := TABLE(locationEmptyFile, {state, c := COUNT(GROUP)}, state);
OUTPUT(SORT(testCount2, -c), NAMED('Tornadoes_In_State'));
mappings2 :=  DATASET([  {'Location', 'state'}/*x*/, 
                        {'Tornadoes', 'c'}/*Y*/], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('Tornadoes_In_State_Chart', /*datasource*/, 'Tornadoes_In_State', mappings2, /*filteredBy*/, /*dermatologyProperties*/ );

//Visualization 3
testCount3 := TABLE(locationEmptyFile, {a := IF(ROUND(begintime/100)=0,24,ROUND(begintime/100)), c := COUNT(GROUP)}, IF(ROUND(begintime/100)=0,24,ROUND(begintime/100)));
OUTPUT(SORT(testCount3, a), NAMED('Tornadoes_Per_Hour'));
mappings3 :=  DATASET([  {'Hour', 'a'}/*x*/, 
                        {'Tornadoes', 'c'}/*Y*/], 
												Visualizer.KeyValueDef);												
Visualizer.MultiD.column('Tornadoes_Per_Hour_Chart', /*datasource*/, 'Tornadoes_Per_Hour', mappings3, /*filteredBy*/, /*properties*/ );








