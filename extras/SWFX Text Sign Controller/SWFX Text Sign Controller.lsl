// SWFX text sign controller v1.0.0

// This script display the Shergood METAR info on a [GenTek] InfoCenter Highway sign.
// Place it in the same object as the Shergood Weather FX script.

// The name of the notecard containing a list of sign keys
string signs_notecard = "SWFX Text Signs";

// GenTek sign API channel
integer sign_channel = -495310229;

// How long to show each panel
float interval = 10;

// Text for each type of cloud cover
list cloud_types = [
    "CLR", "CLEAR",
    "FEW", "FEW",
    "SCT", "SCATTERED",
    "BKN", "BROKEN",
    "OVC", "OVERCAST"
];

// Text for each type of precipitation
list precip = [
    "", "NONE",
    "-RA", "LIGHT RAIN",
    "RA", "RAIN",
    "+RA", "HEAVY RAIN",
    "-SN", "LIGHT SNOW",
    "SN", "SNOW",
    "+SN", "HEAVY SNOW"
];

// Panel to start from
integer panel = 0;

// List of keys of signs to send messages to
list signs;

string align(string in, string dir, integer length, string pad)
{
    if (pad == "") pad = " ";
    if (llToUpper(dir) == "L")
    {
        while (llStringLength(in) < length)
        {
            in = in + pad;
        }
    }
    else if (llToUpper(dir) == "R")
    {
        while (llStringLength(in) < length)
        {
            in = pad + in;
        }
    }
    else // assume center
    {
        integer osc = 0; // we have to be a little smarter here
        while (llStringLength(in) < length)
        {
            if (osc) in = pad + in; // this will align left, then right,
            else in = in + pad;     // then left, then right...
            osc = !osc;             // ... effectively centering the text
        }
    }
    return llGetSubString(in, 0, length - 1); // cut off any excess if we added it on accident
}

string makeContent(list slide_data, list slide_times)
{
    return llDumpList2String(slide_data, "|") + "#$" + llDumpList2String(slide_times, "|");
}

string get_wind_dir(integer deg)
{
    if (deg > 340 || deg < 20) return "N";
    if (deg >= 20 && deg < 70) return "NE";
    if (deg >= 70 && deg < 110) return "E";
    if (deg >= 110 && deg < 160) return "SE";
    if (deg >= 160 && deg < 200) return "S";
    if (deg >= 200 && deg < 250) return "SW";
    if (deg >= 250 && deg < 290) return "W";
    return "NW";
}

broadcast(list content)
{
    integer n = llGetListLength(signs);
    for (--n; n >= 0; --n)
    {
        llRegionSayTo(llList2Key(signs, n), sign_channel, makeContent(content, []));
    }
}

string metar;

next()
{
    if (panel == 0)
    {
        broadcast([
            align("WELCOME  TO", "", 16, "") +
            align("HYENA HELIPORT", "", 16, "") +
            align("<<< SLYN >>>", "", 16, "") +
            align("", "", 16, "W") +
            align("", "", 16, "O") +
            "WWWWWWBBBBWWWWWW"
        ]);
    }
    else if (panel == 1)
    {
        broadcast([
            align("*WEATHER REPORT*", "", 16, "") +
            align("BY SHERGOOD", "", 16, "") +
            align("  AVIATION", "", 16, "") +
            align("", "", 16, "O") +
            "AAAAWWWWWWWWWWWW" +
            align("", "", 16, "W")
        ]);
    }
    else if (panel == 2)
    {
        integer tempc = (integer) llJsonGetValue(metar, ["temperature"]);
        integer tempf = llRound(tempc * 1.8 + 32);
        broadcast([
            align("* TEMPERATURE *", "", 16, "") +
            align((string) tempc + " C / " + (string) tempf + " F", "", 16, "") +
            align("", "", 16, "") +
            align("", "", 16, "O") +
            align("", "", 32, "W")
        ]);
    }
    else if (panel == 3)
    {
        integer windspeed = (integer) llJsonGetValue(metar, ["windSpeed"]);
        string dir;
        if (windspeed > 0)
        {
            dir = " " + get_wind_dir((integer) llJsonGetValue(metar, ["windDirection"]));
        }
        broadcast([
            align("* WIND *", "", 16, "") +
            align((string) windspeed + " KTS" + dir, "", 16, "") +
            align("", "", 16, "") +
            align("", "", 16, "O") +
            align("", "", 32, "W")
        ]);
    }
    else if (panel == 4)
    {
        string alt = llJsonGetValue(metar, ["altimeter"]);
        float inhg = (float) alt;
        integer hpa = (integer) (inhg * 33.863889532611);
        broadcast([
            align("* PRESSURE *", "", 16, "") +
            align(alt +" inHg", "", 16, "") +
            align((string) hpa + " hPa", "", 16, "") +
            align("", "", 16, "O") +
            align("", "", 32, "W")
        ]);
    }
    else if (panel == 5)
    {
        string vis = llJsonGetValue(metar, ["visibility"]);
        integer mi = (integer) vis;
        integer km = (integer) (mi * 1.60934);
        broadcast([
            align("* VISIBILITY *", "", 16, "") +
            align(vis + " MI / " + (string) km + " KM", "", 16, "") +
            align("", "", 16, "") +
            align("", "", 16, "O") +
            align("", "", 32, "W")
        ]);
    }
    else if (panel == 6)
    {
        string cloud_type = llJsonGetValue(metar, ["cloudType"]);
        integer index = llListFindStrided(cloud_types, [cloud_type], 0, -1, 2);
        if (index != -1)
        {
            cloud_type = llList2String(cloud_types, index + 1);
        }
        broadcast([
            align("* CLOUDS *", "", 16, "") +
            align(llJsonGetValue(metar, ["cloudHeight"]) + " FT", "", 16, "") +
            align(cloud_type, "", 16, "") +
            align("", "", 16, "O") +
            align("", "", 32, "W")
        ]);
    }
    else if (panel == 7)
    {
        string weather = llJsonGetValue(metar, ["weather"]);
        integer index = llListFindStrided(precip, [weather], 0, -1, 2);
        if (index != -1)
        {
            weather = llList2String(precip, index + 1);
        }
        broadcast([
            align("*PRECIPITATION*", "", 16, "") +
            align(weather, "", 16, "") +
            align("", "", 16, "") +
            align("", "", 16, "O") +
            align("", "", 32, "W")
        ]);
    }
    else if (panel == 8)
    {
        broadcast([
            align("THANK YOU", "", 16, "") +
            align("AND HAVE", "", 16, "") +
            align("A PLEASANT TRIP!", "", 16, "") +
            //align("AND", "", 16, "") +
            //align("HAPPY HOLIDAYS!", "", 16, "") +
            align("", "", 16, "P") +
            align("", "", 32, "A")
            //align("", "", 16, "A") +
            //align("", "", 5, "R") + align("", "", 11, "G")
        ]);
    }
    
    panel = (panel + 1) % 9;
}

// Begin sending messages to the signs
start()
{
    next();
    llSetTimerEvent(interval);
}

// For reading the signs notecard
key notecard_query;
integer notecard_line;

default
{
    state_entry()
    {
        if (llGetInventoryType(signs_notecard) == INVENTORY_NOTECARD)
        {
            notecard_query = llGetNotecardLine(signs_notecard, notecard_line = 0);
        }
        else
        {
            start();
        }
    }
    
    dataserver(key query_id, string data)
    {
        if (query_id != notecard_query)
        {
            return;
        }
        
        while (data != EOF && data != NAK)
        {
            if (data != "" && llGetSubString(data, 0, 0) != "#")
            {
                signs += (key) data;
            }
            
            data = llGetNotecardLineSync(signs_notecard, ++notecard_line);
        }
        
        if (data == NAK)
        {
            notecard_query = llGetNotecardLine(signs_notecard, notecard_line);
        }
        
        if (data == EOF)
        {
            start();
        }
    }
    
    link_message(integer sender, integer num, string str, key id)
    {
        if (num == -77737412)
        {
            metar = str;
        }
    }
    
    timer()
    {
        if (metar == "")
        {
            return;
        }
        
        next();
    }
}
