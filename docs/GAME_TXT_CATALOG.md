# GAME.TXT message-template catalog

Parsed from `COLONIZE/GAME.TXT` 2026-05-05.
Total sections: **510**

## Substitution variables

- `%STRING0` .. `%STRING4` — text substitutions (often nation/colony/unit names)
- `%NUMBER0` .. `%NUMBER3` — numeric substitutions
- `%YEAR` — current game year
- `%COUNTRY` — current player nation
- `{...}` braces in source = **yellow highlight** in rendered popup
- Unbraced text = **green body text**
- `$` suffix on number = format with currency symbol
- `%%` literal percent sign

## Format directives

- `@width=N` — popup width in pixels
- `@x=N` / `@y=N` — popup top-left position
- `@smallfont` — use FONTSMAL instead of default
- `@checkbox` — render as checkbox dialog
- `@options` — render as multiple-choice (with "default=N" highlighting which option is default)

## Sections by category

### TUTORIAL* (19 sections)

- **@TUTORIAL1** width=190 x=10 y=40: Our {%STRING0} carrying a pioneer and a soldier is on the high seas, Your Excell...
- **@TUTORIAL10** width=220: This looks like a good place to {plow} or {clear}.  Our {pioneers} will plow the...
- **@TUTORIAL11** width=220: Our ship, a {%STRING0}, is one of our most valuable units.  We can use it to exp...
- **@TUTORIAL12** width=220 y=5: Our ship has arrived in %STRING0, Your Excellency, and is waiting for cargo!  Th...
- **@TUTORIAL13** width=220: Our {pioneers} have arrived in the New World, Excellency!  They are ready to loo...
- **@TUTORIAL14** width=220: Our {soldiers} have two uses.  They can be used to attack our enemies, if we run...
- **@TUTORIAL15** width=220: New colonists have arrived in {%STRING0}, Your Excellency!  You can make them ci...
- **@TUTORIAL16** width=220 y=10 x=5 smallfont: It is important for every colony to grow enough {food} to feed its colonists.  E...
- **@TUTORIAL17** width=300 y=10 smallfont: The European Status Screen shows your home port in %STRING0, %STRING1. As new im...
- **@TUTORIAL18** width=300 y=10 smallfont: Cargo is normally purchased in units of 100; when you drag a cargo from the ware...
- **@TUTORIAL19** width=190: {Converts} are natives who for one reason or another have decided to join you an...
- **@TUTORIAL2** width=190: We've found uncharted land, Excellency.  To put the colonists ashore, move the s...
- **@TUTORIAL3** width=190: The abundance of {%STRING0} in this area makes this a good place to start our fi...
- **@TUTORIAL4** width=190 x=10: On the {Colony Screen}, you can decide what the colonists in this colony should ...
- **@TUTORIAL5** width=220: Excellency, there are {%STRING1} ready to join our colony on the docks in {%STRI...
- **@TUTORIAL6** width=220: Sire, there are {%NUMBER0} {%STRING0} in {%STRING1}.  If we move a ship into %ST...
- **@TUTORIAL7** width=220: %STRING0 is growing rapidly, Your Excellency, and we may want to consider buildi...
- **@TUTORIAL8** width=190: This %STRING0 has no specialty profession.  If we move him into a friendly nativ...
- **@TUTORIAL9** width=220: This looks like a good place for a {road}.  Our {pioneers} will build roads in a...

### LOSTCITY* (10 sections)

- **@LOSTCITY0** width=190: Which of the following individuals shall we recruit?
- **@LOSTCITY1** width=190: You have discovered a {Fountain of Youth}!  Rumors fly in Europe! Immigrants lin...
- **@LOSTCITY2** width=190: You have found one of the {Seven Cities of Cibola}!  Treasure worth {%NUMBER1$} ...
- **@LOSTCITY3** width=190: You find the ruins of a lost civilization. Within are gold and artifacts worth {...
- **@LOSTCITY4** width=190: Your expedition happens upon strange burial mounds.  "Let us search for treasure...
- **@LOSTCITY5** width=190: Your expedition has vanished without a trace!
- **@LOSTCITY6** width=190: You find nothing but rumors.
- **@LOSTCITY7** width=190: Your expedition enters the village of a small, friendly tribe.  The chief offers...
- **@LOSTCITY8** width=190: "You are trespassing near our holy {%STRING0} shrines!  The %STRING0 tribe is mo...
- **@LOSTCITY9** width=190: You happen upon the desperate survivors of a former colony.  In exchange for bad...

### BUILD* (10 sections)

- **@BUILD1** width=310 y=30: ^^In the Year of Our Lord One Thousand Four Hundred Ninety-Two,
- **@BUILD10** width=310 y=30: ^^A New World!
- **@BUILD2** width=310 y=30: ^^an Expedition led by the Great %STRING0, ^^%STRING1,
- **@BUILD3** width=310 y=30: ^^left %STRING0 on a Voyage of Discovery.
- **@BUILD4** width=310 y=30: ^^Commissioned and Blessed by the %STRING1 of %STRING0,
- **@BUILD5** width=310 y=30: ^^to Explore the Ocean Sea,
- **@BUILD6** width=310 y=30: ^^to find Uncharted Lands,
- **@BUILD7** width=310 y=30: ^^and to Establish Colonies for the Greater Glory of %STRING0.
- **@BUILD8** width=310 y=30: ^^A Ship loaded with Pioneers and Soldiers
- **@BUILD9** width=310 y=30: ^^Set Sail to find a New Life, a New Beginning, . . .

### NATION* (8 sections)

- **@NATION0A** width=300: ^^ENGLAND ^^_ __The Age of Expansion coincided with a period of {religious strif...
- **@NATION0B** width=300: ^^ENGLAND ^^_ To reflect the great flow of religious immigrants into English col...
- **@NATION1A** width=300: ^^FRANCE ^^_ __Latecomers to the New World, France established her first secure ...
- **@NATION1B** width=300: ^^FRANCE ^^_ To reflect the superior ability of the French to cooperate with the...
- **@NATION2A** width=300: ^^SPAIN ^^_ __In 1492, the same year that Columbus discovered America, the Spani...
- **@NATION2B** width=300: ^^SPAIN ^^_ To reflect the strategic surprise which Spain achieved over pre-Colu...
- **@NATION3A** width=300: ^^NETHERLANDS ^^_ __The Protestant Dutch provinces gained their independence fro...
- **@NATION3B** width=300: ^^NETHERLANDS ^^_ __To represent the strength of the Dutch economy, as well as D...

### PISS* (6 sections)

- **@PISS0** width=190: The {%STRING1} tribe is now %STRING2 {%STRING3}.
- **@PISS1** width=190: Because of your incessant roadbuilding, the {%STRING1} tribe is now %STRING2 {%S...
- **@PISS2** width=190: Because you persist in destroying the forest, the {%STRING1} tribe is now %STRIN...
- **@PISS3** width=190: Because of the continued work of %STRING0 missionaries, the {%STRING1} tribe is ...
- **@PISS4** width=190: Because of this umprovoked attack, the {%STRING1} tribe is now %STRING2 {%STRING...
- **@PISS5** width=190: Because of increasing population pressure from %STRING0 colonies, the {%STRING1}...

### HOWMUCH* (5 sections)

- **@HOWMUCH1** width=190: How much {%STRING0} should be loaded onto %STRING1 (0-%NUMBER0).  Amount:
- **@HOWMUCH2** width=190: How much {%STRING0} should be unloaded from %STRING1 to %STRING2 (0-%NUMBER0).  ...
- **@HOWMUCH3** width=190: How much {%STRING0} should be moved from %STRING1 to %STRING2 (0-%NUMBER0).  Amo...
- **@HOWMUCH4** width=190: How much {%STRING0} (at {%NUMBER1$}) should be purchased and loaded onto %STRING...
- **@HOWMUCH5** width=190: How much {%STRING0} should be sold (at {%NUMBER1$}) to %STRING2 (0-%NUMBER0).  A...

### SPOIL* (4 sections)

- **@SPOIL1** width=190: The colony of {%STRING0} has exceeded its warehouse capacity. {%NUMBER0} tons of...
- **@SPOIL2** width=190: The colony of {%STRING0} has exceeded its warehouse capacity. Some of our cargo ...
- **@SPOIL3** width=190: The colony of {%STRING0} has exceeded its warehouse capacity. {%NUMBER0} tons of...
- **@SPOIL4** width=190: The colony of {%STRING0} has exceeded its warehouse capacity. Some of our cargo ...

### MISSION* (4 sections)

- **@MISSION0** width=190: %STRING0 %STRING1 mission founded in %STRING2, %NUMBER0. {%STRING3} approach new...
- **@MISSION1** width=190: %STRING0 %STRING1 mission founded in %STRING2, %NUMBER0. {%STRING3} are {cautiou...
- **@MISSION2** width=190: %STRING0 %STRING1 mission founded in %STRING2, %NUMBER0. {%STRING3} are {offende...
- **@MISSION3** width=190: %STRING0 %STRING1 mission founded in %STRING2, %NUMBER0. {%STRING3} react with {...

### BADHAGGLE* (4 sections)

- **@BADHAGGLE0** width=190: "Our patience with your haggling is exhausted. We no longer want your worthless ...
- **@BADHAGGLE1** width=190: "We have already told you that we no longer want your {%STRING0}.  Come back whe...
- **@BADHAGGLE2** width=190: "Our patience with your haggling is exhausted. We will sell you nothing further ...
- **@BADHAGGLE3** width=190: "As we said before, we will sell you nothing further until you bring us somethin...

### ^_and * (3 sections)

- **@^_and bring wealth and glory to yourself** : 
- **@^_and explore this new land. Settle it** : 
- **@^_and our nation."** : 

### CARGOREADY* (3 sections)

- **@CARGOREADY0** width=190: A new cargo of {%STRING1} is ready at {%STRING0}, Your Excellency.
- **@CARGOREADY1** width=190: A new cargo of {%STRING1} is ready at {%STRING0}, Your Excellency. %STRING0 has ...
- **@CARGOREADY2** width=190: A new cargo of {%STRING1} is ready at {%STRING0}, Your Excellency. %STRING0 has ...

### BURIAL* (3 sections)

- **@BURIAL1** width=190: The mounds are cold and empty.
- **@BURIAL2** width=190: Within, you find trinkets worth {%NUMBER0$}.
- **@BURIAL3** width=190: Within, you find incredible treasure worth {%NUMBER1$}! It will take a {Galleon}...

### INDIANWIN* (3 sections)

- **@INDIANWIN0** width=190: {%STRING0} ambush {%STRING1 %STRING2} near %STRING3!
- **@INDIANWIN1** width=190: {%STRING0} ambush {%STRING1 %STRING2} near %STRING3! {Muskets} seized by %STRING...
- **@INDIANWIN2** width=190: {%STRING0} ambush {%STRING1 %STRING2} near %STRING3! {Horses} seized by %STRING4...

### CAPTURED* (3 sections)

- **@CAPTURED** width=190: {%STRING0} march into {%STRING2}!  {%NUMBER0$} plundered!
- **@CAPTURED2** width=190: Spies report: {%STRING0} march into {%STRING2}.
- **@CAPTURED3** width=190: {%STRING0} march into {%STRING2}!

### BURNED* (3 sections)

- **@BURNED** width=190: {%STRING0} burn {%STRING3} to the ground! Colonists flee in panic!  King demands...
- **@BURNED2** width=190: Colony at {%STRING3} burned to the ground. {%STRING1} governor vows reprisals.
- **@BURNED3** width=190: Spies report: {%STRING0} burn {%STRING1} colony at {%STRING3}. %STRING1 governor...

### LOSING* (3 sections)

- **@LOSING1** width=220: King's Forces control all ports in %STRING0! Continental Congress capitulates to...
- **@LOSING2** width=220: King's Forces control all colonies in %STRING0! Continental Congress capitulates...
- **@LOSING3** width=190: King's Forces control over 90%% of %STRING0 population! Continental Congress cap...

### WARN* (3 sections)

- **@WARN1** width=220: Your Excellency, the King's forces control all but %NUMBER0 of the ports in %STR...
- **@WARN2** width=220: Your Excellency, the King's forces control all but %NUMBER1 of our colonies!  We...
- **@WARN3** width=220: Your Excellency, the King's forces control %NUMBER2%% of the %STRING0 population...

### VICEROY* (2 sections)

- **@VICEROY** width=78 x=232 y=21: ^ ^^Year of Our Lord ^^1492 ^ ^^An Audience With ^^The King of %COUNTRY ^ "For t...
- **@VICEROY2** width=78 x=232 y=21: ^ ^^Year of Our Lord ^^1492 ^ ^^An Audience With ^^The Stadtholder ^ "For the gr...

### LANDFALL* (2 sections)

- **@LANDFALL** default=1 width=190: Shall we make landfall, Your Excellency, and leave the ships behind?  Stay With ...
- **@LANDFALL2** default=1 width=190: Our ships cannot navigate up this river, Excellency.  Shall we make landfall and...

### ABANDON* (2 sections)

- **@ABANDON** width=190 default=2: Shall we indeed {abandon} our %STRING0 colony, Your Excellency, forfeiting all o...
- **@ABANDON2** width=190 default=2: Shall we indeed {abandon} our %STRING0 colony, Your Excellency, forfeiting all o...

### RECRUIT* (2 sections)

- **@RECRUIT** width=190: The following individuals will accompany us to the New World if we will pay thei...
- **@RECRUIT2** width=190: The following specialty professions are available among the %STRING0. Which shal...

### FOOD* (2 sections)

- **@FOOD1** width=190: Food stores have been depleted in {%STRING0}, Your Excellency!
- **@FOOD2** width=190: Food stores have been depleted in {%STRING0}, Your Excellency!  {Winter} is comi...

### STARVE* (2 sections)

- **@STARVE1** width=190: {%STRING0} colony has run out of food, Your Excellency! In this harsh winter wea...
- **@STARVE2** width=190: {%STRING0} colony has run out of food, Your Excellency! Colonists are {starving}...

### BUYME* (2 sections)

- **@BUYME0** width=160: Cost to complete %STRING0: %NUMBER0$. ^Treasury: %NUMBER1$.
- **@BUYME1** width=160 default=1: Cost to complete %STRING0: %NUMBER0$. ^Treasury: %NUMBER1$.  Never mind. Complet...

### INDIANHELLO* (2 sections)

- **@INDIANHELLO1** width=190: "The {%STRING0} tribe welcomes the most worthy {%STRING1} of the {%STRING2}."
- **@INDIANHELLO2** width=190: "The {%STRING0} tribe greets the most ruthless {%STRING1} of the {%STRING2}."

### INDIANFOREST* (2 sections)

- **@INDIANFOREST** width=190: "This forest and the creatures it supports are necessary to sustain the {%STRING...
- **@INDIANFOREST2** width=190: "This forest and the creatures it supports are necessary to sustain the {%STRING...

### LOOT* (2 sections)

- **@LOOT** width=190: {%STRING0} loot and burn {%STRING1 %STRING2}!  Natives flee in panic! {%NUMBER0$...
- **@LOOT2** width=190: {%STRING0} burn {%STRING1 %STRING2}!  Natives flee in panic!

### COLONISTCAPTURE* (2 sections)

- **@COLONISTCAPTURE** width=190: {%STRING0} colonists CAPTURED by the {%STRING1}!
- **@COLONISTCAPTURE2** width=190: {%STRING0} colonists CAPTURED by the {%STRING1}!  Soldiers lose Veteran status.

### HERESY* (2 sections)

- **@HERESY0** width=190: {%STRING0 missionaries} denounce heresy of {%STRING1}. {%STRING2} converts burn ...
- **@HERESY1** width=190: {%STRING0 missionaries} denounce heresy of {%STRING1}. Loyal {%STRING2} worshipe...

### INDIANWINCOLONY* (2 sections)

- **@INDIANWINCOLONY** width=190: {%STRING0} massacre {%STRING1} colonists at {%STRING3}! {%STRING2} dies fending ...
- **@INDIANWINCOLONY2** width=190: Spies report: {%STRING0} massacre {%STRING1} colonists at {%STRING3}. %STRING1 g...

### INDIANBURNCOLONY* (2 sections)

- **@INDIANBURNCOLONY** width=190: {%STRING0} massacre {%STRING1} colonists at {%STRING3}! Colony burned to the gro...
- **@INDIANBURNCOLONY2** width=190: Spies report: {%STRING0} burn {%STRING1} colony at {%STRING3}. %STRING1 governor...

### TRADE* (2 sections)

- **@TRADE0** width=190: "We see that you have brought some %STRING0 {%STRING1} to trade with us.  We off...
- **@TRADE1** width=190: "Your haggling is trying our patience, but we shall raise our offer to {%NUMBER0...

### BUY* (2 sections)

- **@BUY0** width=190: "We shall fill up your {%STRING1} with {%NUMBER2 %STRING0} in exchange for {%NUM...
- **@BUY1** width=190: "We grow tired of your constant haggling.  We shall fill up your {%STRING1} with...

### TRADENONE* (2 sections)

- **@TRADENONE** width=190: You have not yet defined any trade routes.
- **@TRADENONE2** width=190: You have not yet defined any {%STRING0} trade routes.

### KINGGALLEON* (2 sections)

- **@KINGGALLEON2** width=220: "%STRING0 %STRING1.  We are most pleased at the amount of plunder and booty your...
- **@KINGGALLEON3** width=220: "%STRING0 %STRING1.  We are most pleased at the amount of plunder and booty your...

### NEEDTOOLS* (2 sections)

- **@NEEDTOOLS** width=190: {%STRING1} under construction in {%STRING0} requires {%NUMBER0 tools} for comple...
- **@NEEDTOOLS0** width=190: {%STRING1} under construction in {%STRING0} requires {%NUMBER0 tools} for comple...

### GREATLEADER* (2 sections)

- **@GREATLEADER** : Our Queen Our King The Pope Our Stadtholder
- **@GREATLEADER2** : the Queen the King the Pope the Stadtholder

### REBELUP* (2 sections)

- **@REBELUP** width=190: {Rebel} sentiment is rising in the colonies, Your Excellency! {%NUMBER0%%} of th...
- **@REBELUP50** width=190: {Rebel} sentiment is rising in the colonies, Your Excellency! {%NUMBER0%%} of th...

### MOBILIZE* (2 sections)

- **@MOBILIZE** width=190: Continental Army mobilizes at {%STRING0}! Our Veteran %STRING1 have been promote...
- **@MOBILIZE2** width=190: Continental Army mobilizes at {%STRING0}! {%NUMBER0} Veteran units have been pro...

### INDIANWARPATH* (2 sections)

- **@INDIANWARPATH** width=190: "The {%STRING0} tribe is ready to go on the warpath. Whom would you like us to a...
- **@INDIANWARPATH2** width=190: "We will gladly drive the {%STRING0} from our ancestral lands in exchange for {%...

### SOONRETIRING* (2 sections)

- **@SOONRETIRING0** width=190: %STRING0 %STRING1 plans to retire in 1800!  A rumor circulates that he would pos...
- **@SOONRETIRING1** width=190: "General %STRING1, the people are weary of this long war.  If we cannot force a ...

### RETIRING* (2 sections)

- **@RETIRING** width=220: %STRING0 %STRING1 steps down after over 300 years of loyal service to the Crown....
- **@RETIRING2** width=220: War-weary Continental Congress sues for peace!  King accepts surrender from %STR...

### ARTILLERY* (2 sections)

- **@ARTILLERY** width=190: %STRING0 %STRING1 {damaged}.  Further damage will destroy it.
- **@ARTILLERY2** width=190: Damaged %STRING0 %STRING1 {destroyed}.

### DOS* (1 sections)

- **@DOS** default=2: Exit to DOS?  Yes No

### DOSYES* (1 sections)

- **@DOSYES** : Exit to DOS?  Yes No

### RETIRE* (1 sections)

- **@RETIRE** default=2: Do you really want to quit?  Yes No

### BEGINMENU* (1 sections)

- **@BEGINMENU** width=160 y=91 smallfont options: {COLONIZATION} Version %STRING0 -- %STRING1 Start a Game in NEW WORLD Start a Ga...

### AMERICA* (1 sections)

- **@AMERICA** width=160: Would you like to use the original Americas map, or a map prepared with the map ...

### MAPTOLOAD* (1 sections)

- **@MAPTOLOAD** width=220: ^^Select Map File to Load

### MULTI* (1 sections)

- **@MULTI** width=220: ^^Multiplayer Start Selected ^ Select powers to be controlled by human players.

### MULTINEXT* (1 sections)

- **@MULTINEXT** width=220: ^^{%STRING0} Player Turn ^ ^^Press any key for {%STRING0} player's turn.

### MULTIREV* (1 sections)

- **@MULTIREV** width=220: ^^Warning! ^ The Revolution does not function in multi-player mode.  If you decl...

### GAMEOPTIONS* (1 sections)

- **@GAMEOPTIONS** width=190 checkbox options: Set Game Options Show ~Indian Moves Show ~Foreign Moves Fast Piece ~Slide ~End o...

### COLONYOPTIONS* (1 sections)

- **@COLONYOPTIONS** width=220 checkbox options: Set Colony Report Options Labels on {buildings} Labels on {cargo} and {terrain} ...

### SOUNDOPTIONS* (1 sections)

- **@SOUNDOPTIONS** width=190 checkbox options: Set Sound Options ~Background Music ~Event Music ~Sound Effects

### SAVEGAME* (1 sections)

- **@SAVEGAME** width=190: Select Save Slot

### SAVEGOOD* (1 sections)

- **@SAVEGOOD** width=190: %STRING1 saved as %STRING0.

### SAVEERROR* (1 sections)

- **@SAVEERROR** width=190: Error saving game %STRING0.

### LOADGAME* (1 sections)

- **@LOADGAME** width=190: Select Game To Load

### LOADGOOD* (1 sections)

- **@LOADGOOD** width=190: Loaded %STRING0 successfully.

### LOADNOT* (1 sections)

- **@LOADNOT** width=190: %STRING0 is not a valid save file.

### LOADOLD* (1 sections)

- **@LOADOLD** width=190: %STRING0 is an obsolete save file.

### LOADSIZE* (1 sections)

- **@LOADSIZE** width=190: %STRING0 does not match the current map size.  It cannot be loaded at this time.

### LOADERROR* (1 sections)

- **@LOADERROR** width=190: Error loading game %STRING0.

### PICKNATION* (1 sections)

- **@PICKNATION** default=1: Select a European Power  England France Spain Netherlands

### DIFFICULTY* (1 sections)

- **@DIFFICULTY** width=190: Select a Difficulty Level  Discoverer Explorer Conquistador Governor Viceroy

### LEADERNAME* (1 sections)

- **@LEADERNAME** width=300 options: ^^Please Enter Your Name. _ _ ______________________

### FINDCITY* (1 sections)

- **@FINDCITY** width=190: Where the heck is . . .  Colony:

### NOCITY* (1 sections)

- **@NOCITY** width=190: "%STRING0" not found.

### @small* (1 sections)

- **@@smallfont** : 

### @VICER* (1 sections)

- **@@VICEROY** : 

### @width* (1 sections)

- **@@width=200** : 

### ^^Year* (1 sections)

- **@^^Year of Our Lord %YEAR** : 

### ^^Audi* (1 sections)

- **@^^Audience With The King of %COUNTRY** : 

### ^^_* (1 sections)

- **@^^_** : 

### "For t* (1 sections)

- **@"For the greater glory of %COUNTRY, we** : 

### ^_dub * (1 sections)

- **@^_dub thee {Viceroy of the New World}. Go** : 

### LANDHO* (1 sections)

- **@LANDHO** width=190 default=America: Land Ho!  What shall we call this new land, Your Excellency?  Name:

### COLONY* (1 sections)

- **@COLONY** : What shall we name this colony?  Name:

### RENAMECOLONY* (1 sections)

- **@RENAMECOLONY** : What shall we rename this colony?  Name:

### ONLYPIO* (1 sections)

- **@ONLYPIO** width=120: That function can be performed only by {pioneers}.

### ONLYCOL* (1 sections)

- **@ONLYCOL** width=120: That function can be performed only by {colonists}.

### SHIPCOMBAT* (1 sections)

- **@SHIPCOMBAT** width=190: Only {Privateers} and {Frigates} can attack enemy ships.

### SHIPLAKE* (1 sections)

- **@SHIPLAKE** width=190: Ship units cannot enter inland {lake} squares.

### LANDFIRST* (1 sections)

- **@LANDFIRST** width=190: Land units cannot enter an enemy occupied square from on board a ship.  You must...

### SEACOLONY* (1 sections)

- **@SEACOLONY** width=140: It may surprise you to learn that colonies cannot be built at sea.

### NOPORT* (1 sections)

- **@NOPORT** width=190: This square does not have access to the {ocean}, Your Excellency.  If we build a...

### BUILT* (1 sections)

- **@BUILT** width=140: %STRING0 colony produces {%STRING1}.

### FULL* (1 sections)

- **@FULL** width=190: The colony of {%STRING0} is {far too crowded}, Excellency. We had best find anot...

### NOTEACHER* (1 sections)

- **@NOTEACHER** width=190: Only colonists who have mastered a profession may teach.

### NEEDCOLLEGE* (1 sections)

- **@NEEDCOLLEGE** width=190: We must build a {college} to teach that profession ({%STRING0}) in our colony.

### NEEDUNIVERSITY* (1 sections)

- **@NEEDUNIVERSITY** width=190: We must build a {university} to teach that profession ({%STRING0}) in our colony...

### TRAINFAIL* (1 sections)

- **@TRAINFAIL** width=190: We have a {teacher} in {%STRING0}, but all the colonists there already have spec...

### TRAINCRIMINAL* (1 sections)

- **@TRAINCRIMINAL** width=190: A {criminal} in {%STRING0} has become an {indentured servant} through education.

### TRAININDENTURED* (1 sections)

- **@TRAININDENTURED** width=190: An {indentured servant} in {%STRING0} has become a {free colonist} through educa...

### TRAINPROFESSION* (1 sections)

- **@TRAINPROFESSION** width=190: A {colonist} in {%STRING0} has learned the specialty profession {%STRING1}.

### SIEGE* (1 sections)

- **@SIEGE** width=190: This colony is under {siege}, since enemy combat units outnumber friendly combat...

### SAILHOME* (1 sections)

- **@SAILHOME** width=190 default=1: We have reached the {high seas}, Your Excellency.  Shall we sail for Europe?  Ye...

### SAILAWAY* (1 sections)

- **@SAILAWAY** width=190 default=1: Shall we set sail for the {New World}, Your Excellency?  Yes, steady as she goes...

### SAILPORT* (1 sections)

- **@SAILPORT** width=190 default=1: Select a port to sail to:

### TRAVELPLACE* (1 sections)

- **@TRAVELPLACE** width=190 default=1: Select a colony to travel to:

### UNREST* (1 sections)

- **@UNREST** width=190 default=1: Religious unrest in %COUNTRY causes increased emigration.  Colonists ({%STRING1}...

### RECRUITCHOOSE* (1 sections)

- **@RECRUITCHOOSE** width=220: Religious unrest in %COUNTRY causes increased emigration.  Colonists now availab...

### KINGRECRUIT* (1 sections)

- **@KINGRECRUIT** width=190 smallfont: The {Royal University} can provide us with specialists if we grease the right pa...

### PURCHASE* (1 sections)

- **@PURCHASE** width=190: The following items are available.  Which shall we purchase?

### SCHOOL* (1 sections)

- **@SCHOOL1** width=190: The {Schoolhouse} can support a faculty of only {one} teacher at a time, Your Ex...

### COLLEGE* (1 sections)

- **@COLLEGE2** width=190: The {College} can support a faculty of only {two} teachers at a time, Your Excel...

### UNIV* (1 sections)

- **@UNIV3** width=190: The {University} can support a faculty of only {three} teachers at a time, Your ...

### NODOCKS* (1 sections)

- **@NODOCKS** width=190: We cannot operate fishing boats at this colony until we build {Docks}, Your Exce...

### LUMBER* (1 sections)

- **@LUMBER** width=190: {%STRING0} has run out of {lumber}, Your Excellency.  Our carpenters cannot cont...

### COTTON* (1 sections)

- **@COTTON** width=190: {%STRING0} has run out of {cotton}, Your Excellency.  Our weavers cannot continu...

### TOBACCO* (1 sections)

- **@TOBACCO** width=190: {%STRING0} has run out of {tobacco}, Your Excellency.  Our tobacconists cannot c...

### CANESUGAR* (1 sections)

- **@CANESUGAR** width=190: {%STRING0} has run out of {sugar}, Your Excellency.  Our distillers cannot conti...

### FURS* (1 sections)

- **@FURS** width=190: {%STRING0} has run out of {furs}, Your Excellency.  Our fur traders cannot conti...

### ORE* (1 sections)

- **@ORE** width=190: {%STRING0} has run out of {ore}, Your Excellency.  Our blacksmiths cannot contin...

### TOOLS* (1 sections)

- **@TOOLS** width=190: {%STRING0} has run out of {tools}, Your Excellency.  Our gunsmiths cannot contin...

### VANISH* (1 sections)

- **@VANISH** width=190: Your Excellency!  Our colony at {%STRING0} has vanished!  The colonists appear t...

### FOODLOW* (1 sections)

- **@FOODLOW** width=190: The colony of {%STRING0} is rapidly depleting its food supply, Your Excellency. ...

### DEFOREST* (1 sections)

- **@DEFOREST** width=160: Deforestation near %STRING0.

### DEPLETION* (1 sections)

- **@DEPLETION** width=160: Mine depleted near %STRING0.

### UNITFLAG* (1 sections)

- **@UNITFLAG** width=160: Unit Flags Error (%NUMBER0, %NUMBER1) (%STRING0).

### COLONYFLAG* (1 sections)

- **@COLONYFLAG** width=160: Colony Flags Error.

### SCREWED* (1 sections)

- **@SCREWED** width=190: "These are the burial grounds of our ancient {%STRING0} fathers!  You have tresp...

### SNEAK* (1 sections)

- **@SNEAK** width=190: Sneak attack by the treacherous {%STRING0}!

### CANCELPEACE* (1 sections)

- **@CANCELPEACE** width=190: {%STRING0} cancel peace treaty with {%STRING1}.

### SIGNTREATY* (1 sections)

- **@SIGNTREATY** width=190: The {%STRING0} and {%STRING1} have signed a peace treaty.

### DECLAREWAR* (1 sections)

- **@DECLAREWAR** width=190: The {%STRING0} and {%STRING1} are now at war.

### HAVETREATY* (1 sections)

- **@HAVETREATY** width=190: "We have signed a peace treaty with the {%STRING0}, Your Excellency."  Cancel Ac...

### WHACKINDIANS* (1 sections)

- **@WHACKINDIANS** width=190: Shall we attack the {%STRING0}, Your Excellency?  Yes No

### VILLAGEHAPPY* (1 sections)

- **@VILLAGEHAPPY** width=190: Your expedition has reached a %STRING0 of {%STRING1}.  The inhabitants are peace...

### VILLAGESAVAGE* (1 sections)

- **@VILLAGESAVAGE** width=190: Your expedition has reached a %STRING0 of {%STRING1}.  The inhabitants are busy ...

### VILLAGEMEDIUM* (1 sections)

- **@VILLAGEMEDIUM** width=190: Your expedition has reached a %STRING0 of {%STRING1}.  The inhabitants are busy ...

### VILLAGEBAD* (1 sections)

- **@VILLAGEBAD** width=190: Your expedition has reached a %STRING0 of {%STRING1}.  A band of {warriors} eyes...

### VILLAGEWAR* (1 sections)

- **@VILLAGEWAR** width=190: Your expedition has reached a %STRING0 of {%STRING1}.  A collection of scalps ha...

### INDIANWELCOME* (1 sections)

- **@INDIANWELCOME** width=190: "The {%STRING0} tribe welcomes you. We are a glorious nation of {%NUMBER0 %STRIN...

### INDIANBOW* (1 sections)

- **@INDIANBOW** width=190: "The {%STRING0} tribe bows before the might of the {%STRING1}. In tribute to you...

### INDIANTREATY* (1 sections)

- **@INDIANTREATY** width=190: "The {%STRING0} tribe bows before the might of the {%STRING1}.  In tribute to yo...

### INDIANPEACE* (1 sections)

- **@INDIANPEACE** width=190: "The {%STRING0} welcome peace with our brothers the {%STRING1}.  Let us smoke a ...

### INDIANCOME* (1 sections)

- **@INDIANCOME** width=190: "We hope you will soon {visit} %STRING0 villages to share knowledge with us, and...

### INDIANSHUN* (1 sections)

- **@INDIANSHUN** width=190: "Then the mighty {%STRING0} shall mercilessly drive you from our shores.  Prepar...

### INDIANWAGONS* (1 sections)

- **@INDIANWAGONS** width=190: "The {%STRING0} settlers have committed intolerable acts of destruction against ...

### INDIANCITY* (1 sections)

- **@INDIANCITY** width=190: The {%STRING0} settlers in {%STRING3} have committed intolerable acts of destruc...

### INDIANGOLD* (1 sections)

- **@INDIANGOLD** width=190: "The {%STRING0} people cry out for justice. We demand {%NUMBER0$} in reparations...

### INDIANSLAVES* (1 sections)

- **@INDIANSLAVES** width=190: Frightened {%STRING0} flock to %STRING1 mission as {converts}.

### INDIANSCONVERT* (1 sections)

- **@INDIANSCONVERT** width=190: "The wisdom of your missionaries has convinced some of us to join your colony at...

### INDIANGIVEFOOD* (1 sections)

- **@INDIANGIVEFOOD** width=190: "The {%STRING0} see that your food stores are low this season.  Our own harvest ...

### INDIANGIVESTUFF* (1 sections)

- **@INDIANGIVESTUFF** width=190: "The {%STRING0} tribe is pleased to see the progress of our neighbors at {%STRIN...

### INDIANCOMMENT* (1 sections)

- **@INDIANCOMMENT** width=190: The {%STRING0} are pleased to see the prosperity of our neighbors the {%STRING1}...

### INDIANBEGFOOD* (1 sections)

- **@INDIANBEGFOOD** width=190: "The {%STRING0} tribe has fallen upon hard times and does not have enough food t...

### INDIANWAR* (1 sections)

- **@INDIANWAR** width=190: "We {%STRING0} have tried to live in peace with you, but these provocations are ...

### INDIANGRUDGE* (1 sections)

- **@INDIANGRUDGE** width=190: {%STRING0} nation holds War Council! %STRING1 enter the War of Independence on t...

### INDIANLAND* (1 sections)

- **@INDIANLAND** width=190: "You are trespassing on {%STRING0 land}. We patiently ask that you leave immedia...

### INDIANROAD* (1 sections)

- **@INDIANROAD** width=190: "We are worried that building a {road} here might disrupt the {%STRING0} way of ...

### INDIANBRIBE* (1 sections)

- **@INDIANBRIBE** width=190: "Very well, we withdraw our objection."

### NOPLOW* (1 sections)

- **@NOPLOW** width=190: That land has already been {plowed}.

### NOROAD* (1 sections)

- **@NOROAD** width=190: There is already a {road} here, Your Excellency.

### VIOLATE* (1 sections)

- **@VIOLATE** width=190: {%STRING0} violate {%STRING1} territory near {%STRING2}! Colonists are outraged!

### HALF* (1 sections)

- **@HALF** width=190: Your Excellency, these men are tired.  If we force them to attack this turn, the...

### NOLOOT* (1 sections)

- **@NOLOOT** width=190: {%STRING0} burn {%STRING1 %STRING2}!  Natives flee in panic!

### LOOTCASH* (1 sections)

- **@LOOTCASH** width=190: {%STRING0} treasure fleet laden with {%NUMBER0$} arrives safely in %STRING1! Cro...

### LOOTFOREIGN* (1 sections)

- **@LOOTFOREIGN** width=190: Spies report: {%STRING0} treasure fleet laden with {%NUMBER0$} arrives in %STRIN...

### LOOTCAPTURE* (1 sections)

- **@LOOTCAPTURE** width=190: {%STRING0} treasure worth {%NUMBER0$} CAPTURED by the {%STRING1}!

### WAGONCAPTURE* (1 sections)

- **@WAGONCAPTURE** width=190: {%STRING0} wagon train CAPTURED by the {%STRING1}!

### CARGOCAPTURE* (1 sections)

- **@CARGOCAPTURE** width=190: {%STRING0} cargo of {%NUMBER0 %STRING1} captured by {%STRING2 %STRING3}!

### DEMOTE* (1 sections)

- **@DEMOTE** width=190: {%STRING0 %STRING1} routed!  Unit demoted to {%STRING2} status.

### SHIPDAMAGE* (1 sections)

- **@SHIPDAMAGE** width=190: {%STRING0 %STRING1} damaged!  Ship returns to {%STRING2} for repairs.

### SHIPSUNK* (1 sections)

- **@SHIPSUNK** width=190: {%STRING0 %STRING1 sunk} by %STRING2 %STRING3!

### RAIDNOTHING* (1 sections)

- **@RAIDNOTHING** width=190: {%STRING0} raiding party wiped out in {%STRING1}! Colonists jubilant!

### RAIDWREAK* (1 sections)

- **@RAIDWREAK** width=190: Spies report: {%STRING0} raiding party wreaks havoc in the {%STRING3} colony of ...

### RAIDSTORES* (1 sections)

- **@RAIDSTORES** width=190: {%STRING0} raiding party attacks stores in {%STRING1}! Large quantities of {%STR...

### RAIDBURN* (1 sections)

- **@RAIDBURN** width=190: {%STRING0} raiding party burns buildings in {%STRING1}! {%STRING2} destroyed.  C...

### RAIDSCALP* (1 sections)

- **@RAIDSCALP** width=190: {%STRING0} raiding party takes scalps in {%STRING1}! Colonists scream for reveng...

### RAIDSHIP* (1 sections)

- **@RAIDSHIP** width=190: {%STRING0} raiding party attacks harbor in {%STRING1}! {%STRING2} damaged.  Colo...

### RAIDGOLD* (1 sections)

- **@RAIDGOLD** width=190: {%STRING0} raiding party seizes strongboxes in {%STRING1}! Merchants report {%NU...

### INDIANBURN* (1 sections)

- **@INDIANBURN** width=190: {%STRING0} burn {%STRING1} missions!  Church authorities are outraged!

### INDIANLOSE* (1 sections)

- **@INDIANLOSE** width=190: {%STRING1 %STRING2} %STRING4 {%STRING0} near %STRING3!

### INDIANSURPRISE* (1 sections)

- **@INDIANSURPRISE** width=190: {%STRING0} make surprise raid near {%STRING1}!  Colonists frightened.  %STRING2 ...

### EUROPEWIN* (1 sections)

- **@EUROPEWIN** width=190: {%STRING0} %STRING4 {%STRING1 %STRING2} near %STRING3!

### EUROPELOSE* (1 sections)

- **@EUROPELOSE** width=190: {%STRING1 %STRING2} %STRING4 {%STRING0} near %STRING3!

### WAREHOUSEFULL* (1 sections)

- **@WAREHOUSEFULL** width=190: Your Excellency, the warehouse at {%STRING0} already contains {%NUMBER0} units o...

### EXTORTSTUFF* (1 sections)

- **@EXTORTSTUFF** width=190: "Great %STRING0, we bow before the might of your strange weapons. The humble and...

### EXTORTPOOR* (1 sections)

- **@EXTORTPOOR** width=190: "Mighty %STRING0, we tremble before you.  Alas, the humble and peaceloving {%STR...

### EXTORTLAUGH* (1 sections)

- **@EXTORTLAUGH** width=190: "We laugh at your puny threats.  Do not try our patience, for {%STRING0} warrior...

### EXTORTNO* (1 sections)

- **@EXTORTNO** width=190: "You must think us very foolish indeed, %STRING0 %STRING1.  The {%STRING2} will ...

### TOONEAR* (1 sections)

- **@TOONEAR** width=190: This land is too near to {%STRING0} for a new colony, Your Excellency.

### TOONEARBUILD* (1 sections)

- **@TOONEARBUILD** width=190: A colony building project is already under way in an adjacent square, Your Excel...

### TOOMOUNTAIN* (1 sections)

- **@TOOMOUNTAIN** width=190: Colonies cannot be built in the {mountains}, Your Excellency.

### DONTKNOWSHIPS* (1 sections)

- **@DONTKNOWSHIPS** width=190: We must contact the Indians on land first, Excellency."

### MADATSHIPS* (1 sections)

- **@MADATSHIPS** width=190: "The {%STRING0} people do not trust the men in your ships.  Therefore, we do not...

### MADATWAGONS* (1 sections)

- **@MADATWAGONS** width=190: "Because of the atrocities you have committed against the {%STRING0} people, we ...

### GRUDGEWAGONS* (1 sections)

- **@GRUDGEWAGONS** width=190: "We grudgingly receive your wagons in spite of the atrocities you have committed...

### CONFISCATE* (1 sections)

- **@CONFISCATE** width=190: "Because of the atrocities you have committed against the {%STRING0} people, we ...

### CHIEFHOWDY* (1 sections)

- **@CHIEFHOWDY** width=190: "Greetings, travelers.  We are a peaceful village known for our {%STRING0}.  We ...

### CHIEFGUIDES* (1 sections)

- **@CHIEFGUIDES** width=190: "We gladly welcome you to our %STRING1. In honor of the strange tales you have s...

### CHIEFAREA* (1 sections)

- **@CHIEFAREA** width=190: "The {%STRING0} are pleased to welcome travelers from afar.  Come sit by the fir...

### CHIEFGIFT* (1 sections)

- **@CHIEFGIFT** width=190: "The {%STRING0} welcome the emissaries of the {%STRING1} tribe.  Please take the...

### CHIEFBORED* (1 sections)

- **@CHIEFBORED** width=190: "The {%STRING0} are always pleased to welcome {%STRING1} travelers."

### CHIEFKILL* (1 sections)

- **@CHIEFKILL** width=190: "You have broken sacred taboos of the {%STRING0} tribe! We shall tie you up for ...

### KILLWAGONS* (1 sections)

- **@KILLWAGONS** width=190: Your Excellency! Our {wagon train} has disappeared without a trace in {%STRING0}...

### BADCARGO* (1 sections)

- **@BADCARGO** width=190: "We have enough {%STRING0} and don't need any more right now. Come back when you...

### BRING* (1 sections)

- **@BRING** width=190: "We are in need of {%STRING0} and {%STRING1}.  Perhaps you will bring some next ...

### DEFICIT* (1 sections)

- **@DEFICIT** width=190: "Since you have brought no trade goods, we will not trade with you."

### BUYWHICH* (1 sections)

- **@BUYWHICH** width=190: "We have {%STRING0}, {%STRING1}, and {%STRING2} available to trade with you.  Wh...

### TRADEWHICH* (1 sections)

- **@TRADEWHICH** width=190: Which cargo shall we offer to trade, Your Excellency?

### NOTENOUGH* (1 sections)

- **@NOTENOUGH** width=190: "Sadly, your treasury ({%NUMBER0$}) is not large enough to back your promise."

### LEARNMASTER* (1 sections)

- **@LEARNMASTER** width=190: "We are glad to have a master {%STRING1} living among us, Old One.  However, we ...

### LEARNCRIMINAL* (1 sections)

- **@LEARNCRIMINAL** width=190: "Your ill manners offend us, Young One, and we doubt that you will ever be more ...

### LEARNALREADY* (1 sections)

- **@LEARNALREADY** width=190: "The {%STRING0} of this village have already shared their skills with young Euro...

### LEARNMAD* (1 sections)

- **@LEARNMAD** width=190: "Your ill manners infuriate us, Young One.  You fail to understand our ways, so ...

### LEARNSLOW* (1 sections)

- **@LEARNSLOW** width=190: "You are unskilled and uncouth, Young One, and have difficulty understanding our...

### LEARNSTAY* (1 sections)

- **@LEARNSTAY** width=190: "You are unskilled, Young One, and your ways are strange.  If you wish, however,...

### LEARNLATER* (1 sections)

- **@LEARNLATER** width=190: "Very well.  Perhaps another time."

### LEARNDONE* (1 sections)

- **@LEARNDONE** width=190: "Congratulations, Young One.  You have learned the ways of the {%STRING0} and be...

### TRADEMANY* (1 sections)

- **@TRADEMANY** width=190: Only {%NUMBER0} trade routes can be defined, Your Excellency. To create a new tr...

### TRADESTART* (1 sections)

- **@TRADESTART** width=190: Select destination number %NUMBER0 for route

### TRADETYPE* (1 sections)

- **@TRADETYPE** width=190: Is this a {sea} trade route or a {land} trade route?  Sea route Land route

### TRADENAMES* (1 sections)

- **@TRADENAMES** : 5 Run Ferry Cargo Transport Triangle

### TRADENAME* (1 sections)

- **@TRADENAME** width=190: Enter the name for this trade route.  Name:

### TRADESELECT* (1 sections)

- **@TRADESELECT** width=190: Select a trade route:

### TRADEDELETE* (1 sections)

- **@TRADEDELETE** width=190: Which trade route should we {delete}:

### SUREDELETE* (1 sections)

- **@SUREDELETE** width=190: Are you sure you want to delete the {%STRING0}?  Yes No

### CARGOLOAD* (1 sections)

- **@CARGOLOAD** width=120: Select a cargo to load at {%STRING0}.

### CARGOUNLOAD* (1 sections)

- **@CARGOUNLOAD** width=120: Select a cargo to unload at {%STRING0}.

### ROUTELOOP* (1 sections)

- **@ROUTELOOP** width=190: Your Excellency, our "{%STRING0}" trade route has only one port on its itinerary...

### KINGNO* (1 sections)

- **@KINGNO** width=190: "We are most dissatisfied with your efforts in the New World.  Therefore we do n...

### KINGFUND* (1 sections)

- **@KINGFUND** width=190: "Our royal treasury is stretched to the limit.  At this time we can offer you a ...

### KINGLOWER* (1 sections)

- **@KINGLOWER** width=190: "After careful consideration, we have graciously decided to lower your tax rate ...

### KINGNOTHING* (1 sections)

- **@KINGNOTHING** width=190: "In spite of your impudence, we shall not change your tax rate at this time.  Yo...

### KINGRAISE* (1 sections)

- **@KINGRAISE** width=190: "Your DARE to demand lower taxes!  After the kindness the crown has shown?  For ...

### KINGTAX* (1 sections)

- **@KINGTAX** width=190: "It is essential that the Crown receive proper recompense for its efforts on you...

### KINGBLESS* (1 sections)

- **@KINGBLESS** width=190: "You have our royal blessing.  If you wish, you may kiss our royal pinky ring."

### KINGLAUGH* (1 sections)

- **@KINGLAUGH** width=190: "Ha ha ha ha ha ha ha!  You make a funny joke! Ho ho ho ho ho!  Independence!  H...

### KINGWELCOME* (1 sections)

- **@KINGWELCOME0** width=190: "Welcome, %STRING0 %STRING1.  Your exploits in the New World please us greatly."

### MERCANTILISM* (1 sections)

- **@MERCANTILISM** width=190: "We are concerned that this {%STRING0} you have built will take profits away fro...

### PURCHASETAX* (1 sections)

- **@PURCHASETAX** width=190: "We have graciously decided to raise your tax rate by {%NUMBER0%%} in recognitio...

### TAXOPTIONS* (1 sections)

- **@TAXOPTIONS** : Kiss pinky ring. Hold '{%STRING3 Party}.'

### TEAPARTY* (1 sections)

- **@TEAPARTY** width=220: {%STRING3 Party}!  Sons of Liberty throw {%NUMBER0} tons of %STRING0 into the se...

### KISSUP* (1 sections)

- **@KISSUP** width=220: {%STRING0} is currently under Parliamentary {boycott}, Your Excellency. We canno...

### KISSSORRY* (1 sections)

- **@KISSSORRY** width=220: Unfortunately, we only have {%NUMBER0$} available.

### PRICEUP* (1 sections)

- **@PRICEUP** width=190: The price of {%STRING0} in %STRING1 has risen to {%NUMBER0$}.

### PRICEDOWN* (1 sections)

- **@PRICEDOWN** width=190: The price of {%STRING0} in %STRING1 has fallen to {%NUMBER0$}.

### WHICHFREEDOM* (1 sections)

- **@WHICHFREEDOM** width=190: The Continental Congress will expand during its next session, Your Excellency.  ...

### FREEDOM* (1 sections)

- **@FREEDOM** width=190: %STRING1 Founding Fathers announce that {%STRING0} has joined the Continental Co...

### CLAND* (1 sections)

- **@CLAND** width=190: LAND MASS  Small Normal Large

### CCONT* (1 sections)

- **@CCONT** width=190: LAND FORM  Archipelago Normal Large Continents

### CTEMP* (1 sections)

- **@CTEMP** width=190: TEMPERATURE  Cool Temperate Warm

### CCLIM* (1 sections)

- **@CCLIM** width=190: CLIMATE  Arid Normal Wet

### SHIPSLOW* (1 sections)

- **@SHIPSLOW** width=190: {%STRING0}'s progress slowed by presence of {%STRING1 %STRING2}.

### SHIPRUN* (1 sections)

- **@SHIPRUN** width=190: {%STRING2 %STRING0} slips past {%STRING1 %STRING3}!

### FORTFIRE* (1 sections)

- **@FORTFIRE** width=190: {%STRING0} at {%STRING1} opens fire on {%STRING2 %STRING3}!

### EUROPEARM* (1 sections)

- **@EUROPEARM** width=190: European dock options:

### EUROPESHIPCLICK* (1 sections)

- **@EUROPESHIPCLICK** width=190: European harbor options for {%STRING0}:

### ARMOPTIONS* (1 sections)

- **@ARMOPTIONS** : Don't get on next ship. Board next ship. Move to front of dock. Arm with {Musket...

### COLONYUNIT* (1 sections)

- **@COLONYUNIT** width=190: Options for {%STRING0%STRING1}:

### UNITOPTIONS* (1 sections)

- **@UNITOPTIONS** : Move to front. Clear orders. Sentry / Board ship. Fortify. No changes.

### SHIPOPTIONS* (1 sections)

- **@SHIPOPTIONS** : Move to front. Clear orders. Sentry. Anchor in harbor ("Fortify"). Unload all ca...

### EUROPESHIPOPTIONS* (1 sections)

- **@EUROPESHIPOPTIONS** : Move to front. Set sail for the New World. Unload all cargo. No changes.

### KINGFRIGATE* (1 sections)

- **@KINGFRIGATE** width=190: "%STRING0 %STRING1.  We note that enemy warships are preying on your undefended ...

### CASHTREASURE* (1 sections)

- **@CASHTREASURE** width=220: Treasure sold to foreign agents for {%NUMBER0$}.

### USEDUPTOOLS* (1 sections)

- **@USEDUPTOOLS** width=190: Our {pioneer} has reverted to {colonist} status after using all its {tools}.

### EVASIVE* (1 sections)

- **@EVASIVE** width=190: {%STRING0 %STRING1} evades {%STRING2 %STRING3}.

### KINGMERCY* (1 sections)

- **@KINGMERCY** width=190: "%STRING0 %STRING1.  In light of the unfortunate loss of a Royal {%STRING2} unit...

### KINGNEWWAR* (1 sections)

- **@KINGNEWWAR** width=190: "%STRING0 %STRING1.  The arrogant attitude of the {%STRING2} has forced us to {d...

### KINGVICTORY* (1 sections)

- **@KINGVICTORY** width=190: "%STRING0 %STRING1.  To celebrate our recent victory over %STRING2, we have magn...

### KINGWIFE* (1 sections)

- **@KINGWIFE** width=190: "%STRING0 %STRING1.  In honor of our recent wedding to our %STRING2 wife, we hav...

### KINGWAR* (1 sections)

- **@KINGWAR** width=190: "%STRING0 %STRING1.  Because of recent developments in our ongoing war with %STR...

### KINGNAVACT* (1 sections)

- **@KINGNAVACT** width=190: "%STRING0 %STRING1.  We are concerned that the Crown is not receiving its due sh...

### KINGSTAMPACT* (1 sections)

- **@KINGSTAMPACT** width=190: "%STRING0 %STRING1.  The ungrateful attitude of the colonists in {%STRING2} make...

### COUNTRIES* (1 sections)

- **@COUNTRIES** : the Holy Roman Empire the Portuguese the Ottoman Turks the Barbary Pirates Russi...

### ORDINAL* (1 sections)

- **@ORDINAL** : first second third fourth fifth sixth seventh eighth ninth tenth eleventh twelft...

### ALREADYHAVE* (1 sections)

- **@ALREADYHAVE** width=190: {%STRING0} is set to produce a {%STRING1}, but it has already built one!

### LOBOTOMIZE* (1 sections)

- **@LOBOTOMIZE** width=190: Do you wish to {clear} this colonist's specialty ({%STRING0}) and make him an or...

### PICKACARGO* (1 sections)

- **@PICKACARGO** width=190: Which cargo shall we capture?

### CUSTOM* (1 sections)

- **@CUSTOM** width=190 checkbox smallfont: Which cargos shall our {Custom House} export?

### CONTINENTAL* (1 sections)

- **@CONTINENTAL** width=190: Our {Veteran %STRING0} have hardened to {Continental Army} status, Your Excellen...

### VETERAN* (1 sections)

- **@VETERAN** width=190: Our {%STRING0} have hardened to {Veteran} status, Your Excellency!

### VALOR* (1 sections)

- **@VALOR** width=190: Because of their valor in battle, our {%STRING0} soldiers have been promoted fro...

### SCOUTCOLONY* (1 sections)

- **@SCOUTCOLONY** width=190: Our {scouts} have reached the outskirts of {%STRING0}, Your Excellency.  What sh...

### LOSTOURSCOUTS* (1 sections)

- **@LOSTOURSCOUTS** width=190: Our {scouts} near {%STRING1} have been captured by the {%STRING0}, Your Excellen...

### LOSTTHEIRSCOUTS* (1 sections)

- **@LOSTTHEIRSCOUTS** width=190: We have captured a party of {%STRING0 scouts} attempting to infiltrate {%STRING1...

### HELLOFIRST* (1 sections)

- **@HELLOFIRST** width=220: "Greetings, %STRING0, and welcome to {%STRING1}. We have justly claimed all of t...

### HELLOUSA* (1 sections)

- **@HELLOUSA** width=220: "Greetings, %STRING0, from the newly elected government of the {%STRING1}."

### HELLOAHOY* (1 sections)

- **@HELLOAHOY** width=220: "Ahoy there, %STRING0, and welcome to {%STRING1}. We have justly claimed all the...

### HELLOMEEK* (1 sections)

- **@HELLOMEEK** width=220: "{Mighty} %STRING0, we again welcome you to {%STRING1}. Please remember that we ...

### HELLOMANLY* (1 sections)

- **@HELLOMANLY** width=220: "%STRING0.  We note with {displeasure} that your presence continues to befoul {%...

### GREATKINGS* (1 sections)

- **@GREATKINGS** : our Queen and the Church of England His Most Christian Majesty, King Louis the P...

### GREATDEEDS* (1 sections)

- **@GREATDEEDS** : seek a life of {religious freedom} and service to the Crown promote the greater ...

### MYLEADER* (1 sections)

- **@MYLEADER** : King King King Stadtholder

### PIRACY* (1 sections)

- **@PIRACY** width=220: "%STRING0 is most displeased with the {%STRING1 pirates} lying in wait off the c...

### PIRACYUSA* (1 sections)

- **@PIRACYUSA** width=220: "The {%STRING0} will not suffer foreign pirates to prey upon its commercial inte...

### SIEGES* (1 sections)

- **@SIEGES** width=220: "%STRING0 is disturbed by the large %STRING1 forces lurking outside our %STRING2...

### SIEGESUSA* (1 sections)

- **@SIEGESUSA** width=220: "The %STRING0 has never recognized the right of foreign powers to station large ...

### MEEKNESS* (1 sections)

- **@MEEKNESS** : request demand

### HEATHEN* (1 sections)

- **@HEATHEN** width=220: "We are currently busy subduing the notorious heathen {%STRING1} tribe. Will you...

### HEATHENUSA* (1 sections)

- **@HEATHENUSA** width=220: "The %STRING0 is currently in the process of relocating members of the dangerous...

### APOSTATES* (1 sections)

- **@APOSTATES** width=220: "We note that you have signed a treaty with those unrepentant heretics, the {%ST...

### APOSTATESUSA* (1 sections)

- **@APOSTATESUSA** width=220: "We note that you have signed a treaty with those imperialist pigs, the {%STRING...

### TRIBUTE* (1 sections)

- **@TRIBUTE** width=220: "%STRING0 has told us that we must drive all {%STRING1} from the shores of {%STR...

### TRIBUTEUSA* (1 sections)

- **@TRIBUTEUSA** width=220: "The {%STRING0} does not recognize the right of european powers to establish col...

### WANTSTUFF* (1 sections)

- **@WANTSTUFF** width=260: "We are displeased that you continue to befoul lands that are rightfully ours by...

### WANTSTUFFUSA* (1 sections)

- **@WANTSTUFFUSA** width=220: "The {%STRING0} does not recognize the right of european powers to establish col...

### RID* (1 sections)

- **@RID** width=220: "In the name of {%STRING0}, we order you to leave {%STRING1} immediately. If you...

### RIDUSA* (1 sections)

- **@RIDUSA** width=220: "The {%STRING1} orders you to leave this hemisphere immediately. If you do not, ...

### WORTHY* (1 sections)

- **@WORTHY** width=220: "Although all of this land is rightfully ours by order of %STRING0, we propose a...

### GIVECASH* (1 sections)

- **@GIVECASH** width=220: "Please spare our meek and helpless settlement from destruction. We will give yo...

### PEACEMANLY* (1 sections)

- **@PEACEMANLY** width=220: "Very well.  However, {only} the land you now occupy shall constitute the {%STRI...

### PEACEMEEK* (1 sections)

- **@PEACEMEEK** width=220: "Excellent. All of the land which you now occupy shall constitute the {%STRING0}...

### OLDPEACEMEEK* (1 sections)

- **@OLDPEACEMEEK** width=220: "We welcome the friendship of our brothers the {%STRING0} and their wise leader ...

### OLDPEACEMANLY* (1 sections)

- **@OLDPEACEMANLY** width=220: "Although the {%STRING0} do not properly belong in this hemisphere, we elect not...

### PEACEUSA* (1 sections)

- **@PEACEUSA** width=220: "The {%STRING0} welcomes peace with our politically backward neighbors, the {%ST...

### NOTWITHDRAW* (1 sections)

- **@NOTWITHDRAW** width=220: "Our forces protect valid %STRING0 interests and shall not be moved."

### WITHDRAW* (1 sections)

- **@WITHDRAW** width=220: "In the interest of peace, we shall withdraw our forces."

### NOTHINGWITHDRAW* (1 sections)

- **@NOTHINGWITHDRAW** width=220: "We have no forces adjacent to your colonies."

### MAYBEWITHDRAW* (1 sections)

- **@MAYBEWITHDRAW** width=220: "Our forces protect valid %STRING0 interests.  We are, however, willing to move ...

### PROVOKE* (1 sections)

- **@PROVOKE** width=220: "We can no longer tolerate your foul provocations.  Prepare for WAR!"

### WARMEEK* (1 sections)

- **@WARMEEK** width=220: "Very well, then in the name of %STRING0 we shall drive you from the shores of {...

### WARMANLY* (1 sections)

- **@WARMANLY** width=220: "You reject our generous offer?  Then in the name of %STRING0 we shall wipe you ...

### THREATS* (1 sections)

- **@THREATS** width=220: "We laugh at your feeble threats."

### GIFTS* (1 sections)

- **@GIFTS** width=220: "We present you with a gift of {%NUMBER0$} in exchange for your continued forbea...

### MILITARY* (1 sections)

- **@MILITARY** width=220: "You must attack the infidel . . ."

### NOCONTACT* (1 sections)

- **@NOCONTACT** width=220: "We have no contact with the {%STRING0}."

### ALREADYSMITE* (1 sections)

- **@ALREADYSMITE** width=220: "We are already at war with the worthless {%STRING0}."

### SMITEINDIANS* (1 sections)

- **@SMITEINDIANS** width=220: "We shall ruthlessly smite the heathen {%STRING0} in exchange for {%NUMBER0$} to...

### SMITEEUROPE* (1 sections)

- **@SMITEEUROPE** width=220: "We shall ruthlessly drive the heretic {%STRING0} from the New World in exchange...

### UNFORTUNATE* (1 sections)

- **@UNFORTUNATE** width=220: "Unfortunately, your treasury is insufficient to match your extravagant promises...

### MERCENARY* (1 sections)

- **@MERCENARY** width=220: The {%STRING0} declare war on the {%STRING1}.

### SUCCESSION* (1 sections)

- **@SUCCESSION** width=220: War of the Spanish Succession ends in Europe! {%STRING0}, ravaged by war, agrees...

### REBELMAJORITY* (1 sections)

- **@REBELMAJORITY** width=220: Sons of Liberty membership in {%STRING0} is up to %NUMBER0%%, Your Excellency.  ...

### REBELUNANIMOUS* (1 sections)

- **@REBELUNANIMOUS** width=220: Sons of Liberty membership in {%STRING0} is up to 100%%, Your Excellency. All of...

### TORYMINORITY* (1 sections)

- **@TORYMINORITY** width=220: Sons of Liberty membership in {%STRING0} is down from 100%% to %NUMBER0%%, Your ...

### TORYMAJORITY* (1 sections)

- **@TORYMAJORITY** width=220: Sons of Liberty membership in {%STRING0} is down to %NUMBER0%%, Your Excellency....

### SONSUP* (1 sections)

- **@SONSUP** width=220: Sons of Liberty membership in {%STRING0} is up to %NUMBER0%%, Your Excellency.  ...

### SONSDOWN* (1 sections)

- **@SONSDOWN** width=220: Sons of Liberty membership in {%STRING0} is down to %NUMBER0%%, Your Excellency....

### REBELDOWN* (1 sections)

- **@REBELDOWN** width=190: {Tory} sentiment is once again on the rise in the colonies, Your Excellency.  On...

### REFIT* (1 sections)

- **@REFIT** width=190: {%STRING0} has completed its repairs in {%STRING1}.

### WELLSEASONED* (1 sections)

- **@WELLSEASONED** width=190: Our {Scouts} have improved to {Seasoned} status, Your Excellency.

### KINGBUY* (1 sections)

- **@KINGBUY** width=190: King increases military spending.  {%STRING0} added to royal expeditionary force...

### SEIZURE* (1 sections)

- **@SEIZURE** width=190: {%STRING0} seized on the high seas by the Royal Navy!

### SEIZURESEA* (1 sections)

- **@SEIZURESEA** width=190: {%STRING0} captured at sea by the Royal Navy!

### SEIZURELAND* (1 sections)

- **@SEIZURELAND** width=190: {%STRING0} captured by the Royal Army!

### INDEPENDENCE* (1 sections)

- **@INDEPENDENCE** width=220: Continental Congress signs {Declaration of Independence}! Abuses and usurpations...

### INVASION* (1 sections)

- **@INVASION** width=190: Royal Expeditionary Force lands near {%STRING0}!

### TOOTORY* (1 sections)

- **@TOOTORY** width=190: Only {%NUMBER0%%} of the colonists support the independence movement, Your Excel...

### DECLARE* (1 sections)

- **@DECLARE** width=190: Shall we declare our independence from {%STRING0}, Your Excellency? This will en...

### DEADCONVERTS* (1 sections)

- **@DEADCONVERTS** width=190: Indian {converts} lose faith and return to tribe.  Converts who do not join colo...

### TOOMANYUNITS* (1 sections)

- **@TOOMANYUNITS** width=190: A {unit} cannot be created because the maximum number of units for the game has ...

### TOOMANYCOLONIES* (1 sections)

- **@TOOMANYCOLONIES** width=190: A {colony} cannot be created because the maximum number of colonies for the game...

### PICKMUSIC* (1 sections)

- **@PICKMUSIC** smallfont width=220: Select a piece of music:  "Bird Song" "Smoky Tune" "Cornwall" "Shady Grove" "Fid...

### PICKINDEPENDENCE* (1 sections)

- **@PICKINDEPENDENCE** smallfont width=220: Select an independence tune:  "Love Forever" "York Fusiliers" "Washington Artill...

### PICKMILITARY* (1 sections)

- **@PICKMILITARY** smallfont width=220: Select a military tune:  "The Reveille" "Successful Campaign" "Morelli's Lesson"...

### PICKINDIAN* (1 sections)

- **@PICKINDIAN** smallfont width=220: Select an Indian tune:  "Indian Victory" "Natives" "Tenochtitlan" "Pizarro at Cu...

### UPKEEP* (1 sections)

- **@UPKEEP** width=190: Your Excellency, we cannot afford to pay the upkeep ({%NUMBER0$}) on all our bui...

### CANTMOBILIZE* (1 sections)

- **@CANTMOBILIZE** width=190: Continental Army can mobilize in colonies which contain at least {%NUMBER0 muske...

### KINGMOBILIZE* (1 sections)

- **@KINGMOBILIZE** width=190: Parliament votes additional funds to suppress revolution in %STRING0.  {%STRING1...

### EUROPENOTAVAIL* (1 sections)

- **@EUROPENOTAVAIL** width=190: The European Status Screen is no longer available once the {War of Independence}...

### FOREIGNNOTAVAIL* (1 sections)

- **@FOREIGNNOTAVAIL** width=190: The Foreign Affairs Adviser's report is no longer available once the {War of Ind...

### EUROPENOTLEAVE* (1 sections)

- **@EUROPENOTLEAVE** width=190: Ships cannot sail to and from Europe for the duration of the {War of Independenc...

### NOWARSDURINGREV* (1 sections)

- **@NOWARSDURINGREV** width=190: Foreign colonies cannot be attacked during the {War of Independence}.

### NOCOLONIESEITHER* (1 sections)

- **@NOCOLONIESEITHER** width=190: New colonies cannot be founded during the {War of Independence}.

### NOMAYORSDURINGREV* (1 sections)

- **@NOMAYORSDURINGREV** width=190: Scouts cannot meet with mayors during the {War of Independence}.

### AMBUSHHINT* (1 sections)

- **@AMBUSHHINT** width=220: Your Excellency, the King's armies have little experience with the kind of tacti...

### CONSIDER* (1 sections)

- **@CONSIDER** width=220: %STRING0 is considering intervention on our behalf against the King, Your Excell...

### INTERVENTION* (1 sections)

- **@INTERVENTION** width=220: {%STRING0} declares war on %STRING1 and joins the War of Independence on the Reb...

### FRIEND* (1 sections)

- **@FRIEND** : British General Cornwallis French General Lafayette Spanish Generals Dutch Admir...

### INTERVENE* (1 sections)

- **@INTERVENE** width=190: %STRING1 Intervention Force arrives in {%STRING0}!  Local Rebel Army commander r...

### EXPLOITS* (1 sections)

- **@EXPLOITS** : COLONIZATION RATING: %NUMBER0%% In memory of your deeds, the citizens of %STRING...

### SCORE* (1 sections)

- **@SCORE** : An Infectious Disease, %STRING0 Fever A Stinging Insect,     %STRING0 Fly A Pois...

### WINNING* (1 sections)

- **@WINNING** width=220: Royal Expeditionary Force annihilated! General %STRING0 accepts {surrender} of a...

### OTHERGRANTED* (1 sections)

- **@OTHERGRANTED** width=220: The King of {%STRING0} grants {independence} to %STRING1!  %STRING2 elected firs...

### OTHERMIGHT* (1 sections)

- **@OTHERMIGHT** width=220: Your Excellency, the King of {%STRING0} is considering granting independence to ...

### OTHERLESS* (1 sections)

- **@OTHERLESS** width=220: Spies Report:  Only {%NUMBER0} {%STRING1} now support independence from %STRING0...

### SCORED* (1 sections)

- **@SCORED** width=220: Scoring for this game is now complete.  That's all. Keep playing anyway.

### TORYUPRISING* (1 sections)

- **@TORYUPRISING** width=220: Tory uprising near %STRING0!  Parliament arms Tory Militia!

### CANNOTATTACK* (1 sections)

- **@CANNOTATTACK** width=190: That unit type cannot attack.

### TRADEMERCANTILISM* (1 sections)

- **@TRADEMERCANTILISM** width=190: "In the interests of {Mercantilism}, %STRING0 has ordered us not to trade with f...

### TRADEATWAR* (1 sections)

- **@TRADEATWAR** width=190: Ships and wagon trains cannot enter the colonies of foreign powers with whom you...

### TRADENOCARGO* (1 sections)

- **@TRADENOCARGO** width=190: "You have brought nothing with you to trade with us.  Please come back when you ...

### TRADENOWANT* (1 sections)

- **@TRADENOWANT** width=190: "We are not interested in your {%NUMBER0 %STRING0}.  Come back when you have som...

### TRADEWITH* (1 sections)

- **@TRADEWITH** width=190: "We will give you {%NUMBER0 %STRING0} in exchange for your %NUMBER1 %STRING1. Or...

### EXTINCT* (1 sections)

- **@EXTINCT** width=190: The %STRING0 tribe has been wiped out.

### MERCENARIES* (1 sections)

- **@MERCENARIES** width=190: The King of %STRING0 has offered to send us a force of trained {mercenaries} (%S...

### MERCS* (1 sections)

- **@MERCS** width=190: %STRING1 mercenaries arrive in %STRING0.

### OVERBOARD* (1 sections)

- **@OVERBOARD** width=190: What cargo shall we throw overboard, Your Excellency?

### ALREADYREVOLUTION* (1 sections)

- **@ALREADYREVOLUTION** width=190: We are already fighting a War of Independence, Excellency.

### SUREDISBAND* (1 sections)

- **@SUREDISBAND** width=190: Really {disband} %STRING0?  Yes No

### NEWCOLONIST* (1 sections)

- **@NEWCOLONIST** width=190: Population increase in %STRING0.  New colonist now available.

### INEFFICIENT* (1 sections)

- **@INEFFICIENT** width=220: {%STRING0} has an inefficient government, Your Excellency! Any colony which has ...

### EFFICIENT* (1 sections)

- **@EFFICIENT** width=190: {%STRING0} has improved the efficiency of its government, Your Excellency. Produ...

### CLEARCUT* (1 sections)

- **@CLEARCUT** width=190: Pioneers clear forest near {%STRING0}.  {%NUMBER0 lumber} added to stockpile.

### REALLYBUY* (1 sections)

- **@REALLYBUY** width=190: Purchase %STRING0 for %NUMBER0$?  Yes No

### INDIANWARFARE* (1 sections)

- **@INDIANWARFARE** width=190: {%STRING0} nation holds War Council! {%STRING1} missionaries incite %STRING2 to ...

### LOSENOCOLONIES* (1 sections)

- **@LOSENOCOLONIES** width=190: "%STRING0 %STRING1.  Our efforts in the New World have proven fruitless and we h...

### HOWTOWIN* (1 sections)

- **@HOWTOWIN** width=220: We have just won a glorious victory on the road to freedom, Your Excellency. In ...

### TIMECHANGE* (1 sections)

- **@TIMECHANGE** width=190: ^^Colonization Help: Time Scale ^ In 1600, the {time scale} changes from one tur...

### TEACHCONVERT* (1 sections)

- **@TEACHCONVERT** width=190: Indian converts already know the Indian ways.

### SOMEBOYCOTT* (1 sections)

- **@SOMEBOYCOTT** width=190: Some of the cargo could not be unloaded because of a parliamentary boycott.  If ...

### KEEPSTOCKADE* (1 sections)

- **@KEEPSTOCKADE** width=220: We cannot voluntarily reduce below {three} the population of a colony that has a...

### MORETHANTHREE* (1 sections)

- **@MORETHANTHREE** width=220: We cannot put more than {three} colonists in any one building, Your Excellency.

### LOOTWAGONS* (1 sections)

- **@LOOTWAGONS** width=220: %STRING0 loot wagon trains near %STRING3!

### TUTNOLUMBER* (1 sections)

- **@TUTNOLUMBER** width=220: None of the spaces surrounding this square are forested, Your Excellency. A colo...

### TUTNOSPACES* (1 sections)

- **@TUTNOSPACES** width=220: There are only a few productive squares adjacent to this square, Your Excellency...

### KINGLOSE* (1 sections)

- **@KINGLOSE** width=68 x=232 y=31: "In our wisdom, we have decided to let you go your own way. We have far more imp...

### KINGWIN* (1 sections)

- **@KINGWIN** width=90 x=202 y=125: "As expected, your attempt to separate from mother %STRING0 has proven futile. Y...

### DISBANDSHIP* (1 sections)

- **@DISBANDSHIP** width=190: We cannot disband a ship at sea while it is carrying units.

### NOMOREWAREHOUSE* (1 sections)

- **@NOMOREWAREHOUSE** width=190: {%STRING0} is set to produce a {Warehouse Expansion}, Your Excellency, but only ...

### NOMOREWAGONS* (1 sections)

- **@NOMOREWAGONS** width=190: {%STRING0} is set to produce a {Wagon Train}, Your Excellency, but we are not al...

### END* (1 sections)

- **@END** : 
