// Shergood Weather FX v0.8.0
// Environment control based on Shergood METAR weather data

// CONFIGURATION

// The names of the settings notecards
string settings_notecard = "Shergood Weather FX settings";
string cloud_cover_notecard = "Shergood Weather FX cloud cover";
string sounds_notecard = "Shergood Weather FX sounds";
string ground_textures_notecard = "Shergood Weather FX ground textures";
string airports_notecard = "Shergood Weather FX airports";

// The sequence in which to read the settings notecards
list settings_notecards = [
    settings_notecard,
    cloud_cover_notecard,
    sounds_notecard,
    ground_textures_notecard,
    airports_notecard
];

// The ICAO of the nearest airport
string icao;

// Enable Christmas mode
integer christmas_mode = FALSE;

// Channel for METAR weather emitter and ground layer messages
integer swfx_emitter_channel = -77737413;

// Channel for METAR relay messages
integer metar_relay_channel = -77737412;

// The Shergood API URL
string api = "https://shergoodaviation.com/ajax/ajax-misc.php";

// How often to request an update from the Shergood server
float request_interval = 60;

// Whether to change environment settings
integer set_environment = TRUE;

// Mapping of METAR cloud types to SKY_CLOUDS cover values (min and max)
list cloud_cover = [
    "CLR", 0.0, 0.05,
    "FEW", 0.1, 0.15,
    "SCT", 0.2, 0.3,
    "BKN", 0.3, 0.35,
    "OVC", 0.4, 0.5
];

// The maximum visibility value that will have an effect
float max_visibility = 5;

// When visibility = 0, adjust it to this instead
float min_visibility = 0.7;

// Particle effect data to send to METAR emitter nodes

// -RA
string particle_light_rain()
{
    return llList2Json(JSON_ARRAY, [
        PSYS_PART_FLAGS,(0
        | PSYS_PART_EMISSIVE_MASK
        | PSYS_PART_INTERP_COLOR_MASK
        | PSYS_PART_INTERP_SCALE_MASK
        ),
        PSYS_PART_START_COLOR,<1.0,1.0,1.0>,
        PSYS_PART_END_COLOR,<1.0,1.0,1.0>,
        PSYS_PART_START_ALPHA,0.05,
        PSYS_PART_END_ALPHA,0.01,
        PSYS_PART_START_SCALE,<0.05000, 0.50000, 0.00000>,
        PSYS_PART_END_SCALE,<0.07500, 0.40000, 0.00000>,
        PSYS_PART_MAX_AGE,1.200000,
        PSYS_SRC_ACCEL,<0.00000, 0.00000, -10.50000>,
        PSYS_SRC_PATTERN,8,
        PSYS_SRC_TEXTURE,"861d60f5-aa8c-327e-c315-9ddff8063a26",
        PSYS_SRC_BURST_RATE,0.050000,
        PSYS_SRC_BURST_PART_COUNT,30,
        PSYS_SRC_BURST_RADIUS,10.000000,
        PSYS_SRC_BURST_SPEED_MIN,0.000000,
        PSYS_SRC_BURST_SPEED_MAX,0.000000,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_ANGLE_BEGIN,0.400000*PI,
        PSYS_SRC_ANGLE_END,1.000000*PI
    ]);
}

// RA
string particle_rain()
{
    return llList2Json(JSON_ARRAY, [
        PSYS_PART_FLAGS,(0
        | PSYS_PART_EMISSIVE_MASK 
        | PSYS_PART_INTERP_COLOR_MASK 
        | PSYS_PART_INTERP_SCALE_MASK 
        ),
        PSYS_PART_START_COLOR,<1.0,1.0,1.0>,
        PSYS_PART_END_COLOR,<1.0,1.0,1.0>,
        PSYS_PART_START_ALPHA,0.100000,
        PSYS_PART_END_ALPHA,0.05,
        PSYS_PART_START_SCALE,<0.05000, 0.50000, 0.00000>,
        PSYS_PART_END_SCALE,<0.07500, 0.40000, 0.00000>,
        PSYS_PART_MAX_AGE,1.200000,
        PSYS_SRC_ACCEL,<0.00000, 0.00000, -10.50000>,
        PSYS_SRC_PATTERN,8,
        PSYS_SRC_TEXTURE,"861d60f5-aa8c-327e-c315-9ddff8063a26",
        PSYS_SRC_BURST_RATE,0.050000,
        PSYS_SRC_BURST_PART_COUNT,30,
        PSYS_SRC_BURST_RADIUS,10.000000,
        PSYS_SRC_BURST_SPEED_MIN,0.000000,
        PSYS_SRC_BURST_SPEED_MAX,0.000000,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_ANGLE_BEGIN,0.400000*PI,
        PSYS_SRC_ANGLE_END,1.000000*PI
    ]);
}

// +RA
string particle_heavy_rain()
{
    return llList2Json(JSON_ARRAY, [
        PSYS_PART_FLAGS,(0
        | PSYS_PART_EMISSIVE_MASK 
        | PSYS_PART_INTERP_COLOR_MASK 
        | PSYS_PART_INTERP_SCALE_MASK 
        ),
        PSYS_PART_START_COLOR,<1.0,1.0,1.0>,
        PSYS_PART_END_COLOR,<1.0,1.0,1.0>,
        PSYS_PART_START_ALPHA,0.200000,
        PSYS_PART_END_ALPHA,0.100000,
        PSYS_PART_START_SCALE,<0.05000, 0.50000, 0.00000>,
        PSYS_PART_END_SCALE,<0.07500, 0.40000, 0.00000>,
        PSYS_PART_MAX_AGE,1.200000,
        PSYS_SRC_ACCEL,<0.00000, 0.00000, -10.50000>,
        PSYS_SRC_PATTERN,8,
        PSYS_SRC_TEXTURE,"861d60f5-aa8c-327e-c315-9ddff8063a26",
        PSYS_SRC_BURST_RATE,0.050000,
        PSYS_SRC_BURST_PART_COUNT,30,
        PSYS_SRC_BURST_RADIUS,10.000000,
        PSYS_SRC_BURST_SPEED_MIN,0.000000,
        PSYS_SRC_BURST_SPEED_MAX,0.000000,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_ANGLE_BEGIN,0.400000*PI,
        PSYS_SRC_ANGLE_END,1.000000*PI
    ]);
}

// -SN
string particle_light_snow()
{
    return llList2Json(JSON_ARRAY, [
        PSYS_PART_FLAGS,(0
        | PSYS_PART_EMISSIVE_MASK 
        | PSYS_PART_INTERP_COLOR_MASK 
        | PSYS_PART_INTERP_SCALE_MASK 
        ),
        PSYS_PART_START_COLOR,<1.00000, 1.00000, 1.00000>,
        PSYS_PART_END_COLOR,<1.00000, 1.00000, 1.00000>,
        PSYS_PART_START_ALPHA,0.700000,
        PSYS_PART_END_ALPHA,0.300000,
        PSYS_PART_START_SCALE,<0.20000, 0.20000, 0.00000>,
        PSYS_PART_END_SCALE,<0.22000, 0.22000, 0.00000>,
        PSYS_PART_MAX_AGE,32.000000,
        PSYS_SRC_ACCEL,<0.00000, 0.00000, -0.25000>,
        PSYS_SRC_PATTERN,8,
        PSYS_SRC_BURST_RATE,0.100000,
        PSYS_SRC_BURST_PART_COUNT,1,
        PSYS_SRC_BURST_RADIUS,8.000000,
        PSYS_SRC_BURST_SPEED_MIN,0.180000,
        PSYS_SRC_BURST_SPEED_MAX,0.000000,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_ANGLE_BEGIN,0.000000*PI,
        PSYS_SRC_ANGLE_END,0.330000*PI
    ]);
}

// SN
string particle_snow()
{
    return llList2Json(JSON_ARRAY, [
        PSYS_PART_FLAGS,(0
        | PSYS_PART_EMISSIVE_MASK 
        | PSYS_PART_INTERP_COLOR_MASK 
        | PSYS_PART_INTERP_SCALE_MASK 
        ),
        PSYS_PART_START_COLOR,<1.00000, 1.00000, 1.00000>,
        PSYS_PART_END_COLOR,<1.00000, 1.00000, 1.00000>,
        PSYS_PART_START_ALPHA,0.700000,
        PSYS_PART_END_ALPHA,0.300000,
        PSYS_PART_START_SCALE,<0.20000, 0.20000, 0.00000>,
        PSYS_PART_END_SCALE,<0.22000, 0.22000, 0.00000>,
        PSYS_PART_MAX_AGE,32.000000,
        PSYS_SRC_ACCEL,<0.00000, 0.00000, -0.35000>,
        PSYS_SRC_PATTERN,8,
        PSYS_SRC_BURST_RATE,0.070000,
        PSYS_SRC_BURST_PART_COUNT,2,
        PSYS_SRC_BURST_RADIUS,8.000000,
        PSYS_SRC_BURST_SPEED_MIN,0.180000,
        PSYS_SRC_BURST_SPEED_MAX,0.000000,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_ANGLE_BEGIN,0.000000*PI,
        PSYS_SRC_ANGLE_END,0.330000*PI
    ]);
}

// +SN
string particle_heavy_snow()
{
    return llList2Json(JSON_ARRAY, [
        PSYS_PART_FLAGS,(0
        | PSYS_PART_EMISSIVE_MASK 
        | PSYS_PART_INTERP_COLOR_MASK 
        | PSYS_PART_INTERP_SCALE_MASK
        ),
        PSYS_PART_START_COLOR,<1.00000, 1.00000, 1.00000>,
        PSYS_PART_END_COLOR,<1.00000, 1.00000, 1.00000>,
        PSYS_PART_START_ALPHA,0.700000,
        PSYS_PART_END_ALPHA,0.300000,
        PSYS_PART_START_SCALE,<0.20000, 0.20000, 0.00000>,
        PSYS_PART_END_SCALE,<0.22000, 0.22000, 0.00000>,
        PSYS_PART_MAX_AGE,32.000000,
        PSYS_SRC_ACCEL,<0.00000, 0.00000, -0.35000>,
        PSYS_SRC_PATTERN,8,
        PSYS_SRC_BURST_RATE,0.050000,
        PSYS_SRC_BURST_PART_COUNT,5,
        PSYS_SRC_BURST_RADIUS,8.000000,
        PSYS_SRC_BURST_SPEED_MIN,0.180000,
        PSYS_SRC_BURST_SPEED_MAX,0.000000,
        PSYS_SRC_MAX_AGE,0.000000,
        PSYS_SRC_OMEGA,<0.00000, 0.00000, 0.00000>,
        PSYS_SRC_ANGLE_BEGIN,0.000000*PI,
        PSYS_SRC_ANGLE_END,0.330000*PI
    ]);
}

// Ambient sounds for weather
list sounds = [
    "-RA", "0a9e0db8-25ef-14e0-9e57-b4fc43343028", 0.3,
    "RA", "0a9e0db8-25ef-14e0-9e57-b4fc43343028", 0.5,
    "+RA", "0e7793f5-2244-e0e8-080f-15bf742f99e9", 0.7
];

// Textures and alphas for the ground layer
list ground_textures = [
    "-RA", "af8c86bd-c377-c331-7476-58abeb7af8fc", 0.1,
    "RA", "af8c86bd-c377-c331-7476-58abeb7af8fc", 0.15,
    "+RA", "af8c86bd-c377-c331-7476-58abeb7af8fc", 0.2,
    "-SN", "d3cb47a3-595b-d2bb-599a-66bb1116674a", 0.3,
    "SN", "d3cb47a3-595b-d2bb-599a-66bb1116674a", 0.4,
    "+SN", "d3cb47a3-595b-d2bb-599a-66bb1116674a", 0.5
];

// END OF CONFIGURATION

// The previously set weather
string last_weather = "x";

// The previously set cloud type
string last_cloud_type = "x";

// The previously set visibility
integer last_visibility = -1;

// The ID of the HTTP request to the API
key http_request_id;

// Index of the current settings notecard being read
integer settings_notecards_index = -1;

// Used for reading notecards
string notecard_name;
key notecard_query;
integer notecard_line;

// The distance of the closest airport found so far
float closest_airport_distance;

// Read the next settings notecard, return true if there is one or false if there is not
integer read_next_settings_notecard()
{
    integer n = llGetListLength(settings_notecards);
    
    for (++settings_notecards_index; settings_notecards_index < n; ++settings_notecards_index)
    {
        string notecard = llList2String(settings_notecards, settings_notecards_index);
        
        if (notecard == airports_notecard && icao != "")
        {
            return FALSE;
        }
        
        if (llGetInventoryType(notecard) == INVENTORY_NOTECARD)
        {   
            notecard_query = llGetNotecardLine(notecard_name = notecard, notecard_line = 0);
            return TRUE;
        }
    }
    
    return FALSE;
}

// Make a request to the Shergood METAR API
request_metar()
{
    http_request_id = llHTTPRequest(api, [HTTP_METHOD, "POST", HTTP_MIMETYPE, "application/x-www-form-urlencoded"], "action=getMetar&icao=" + icao);
}

// Parse a METAR string into a list
// [string icao, integer day, integer hour, integer minute, string method, integer wind_direction, integer wind_speed, integer visibility, string weather, string cloud_type, integer cloud_height, integer temperature, integer dewpoint, string altimeter]
list parse_metar(string metar)
{
    // Break up the METAR string into individual values
    list metar_parts = llParseString2List(metar, [" "], []);
    integer num_parts = llGetListLength(metar_parts);
    integer i;
    
    // ICAO
    string icao = llList2String(metar_parts, i++);
    
    // Time
    string time = llList2String(metar_parts, i++);
    integer day = (integer) llGetSubString(time, 0, 1);
    integer hour = (integer) llGetSubString(time, 2, 3);
    integer minute = (integer) llGetSubString(time, 4, 5);
    
    // Method
    string method = llList2String(metar_parts, i++);
            
    // Wind
    string wind = llList2String(metar_parts, i++);
    integer wind_direction = (integer) llGetSubString(wind, 0, 2);
    integer wind_speed = (integer) llGetSubString(wind, 3, 4);
    
    // Visibility
    string vis = llList2String(metar_parts, i++);
    integer visibility = (integer) llGetSubString(vis, 0, -3);
    
    // Weather (optional)
    string weather;
    if (num_parts == 11)
    {
        weather = llList2String(metar_parts, i++);
    }
    
    // Clouds
    string clouds = llList2String(metar_parts, i++);
    string cloud_type = llGetSubString(clouds, 0, -4);
    integer cloud_height = ((integer) llGetSubString(clouds, -3, -1)) * 100;
    
    // Temperature and Dew Point
    string tempdew = llList2String(metar_parts, i++);
    list tempdew_parts = llParseString2List(tempdew, ["/"], []);
    string temp = llList2String(tempdew_parts, 0);
    integer temperature;
    if (llGetSubString(temp, 0, 0) == "M")
    {
        temperature = ((integer) llGetSubString(temp, 1, -1)) * -1;
    }
    else
    {
        temperature = (integer) temp;
    }
    string dew = llList2String(tempdew_parts, 1);
    integer dewpoint;
    if (llGetSubString(dew, 0, 0) == "M")
    {
        dewpoint = ((integer) llGetSubString(dew, 1, -1)) * -1;
    }
    else
    {
        dewpoint = (integer) dew;
    }
    
    // Altimeter
    string alt = llList2String(metar_parts, i++);
    string altimeter = llGetSubString(alt, 1, 2) + "." + llGetSubString(alt, 3, 4);
    
    return [
        /*  0 */ icao,
        /*  1 */ day,
        /*  2 */ hour,
        /*  3 */ minute,
        /*  4 */ method,
        /*  5 */ wind_direction,
        /*  6 */ wind_speed,
        /*  7 */ visibility,
        /*  8 */ weather,
        /*  9 */ cloud_type,
        /* 10 */ cloud_height,
        /* 11 */ temperature,
        /* 12 */ dewpoint,
        /* 13 */ altimeter
    ];
}

// Get the SKY_CLOUDS cover value from the METAR cloud type
float get_cloud_cover(string cloud_type)
{
    integer index = llListFindStrided(cloud_cover, [cloud_type], 0, -1, 3);
    
    if (index == -1)
    {
        return 0;
    }
    
    float min = llList2Float(cloud_cover, index + 1);
    float max = llList2Float(cloud_cover, index + 2);
    
    return llFrand(max - min) + min;
}

// Get the SKY_HAZE values from the METAR visibility
list get_haze(float visibility)
{
    if (visibility > max_visibility)
    {
        visibility = max_visibility;
    }
    
    if (visibility < 1)
    {
        visibility = min_visibility;
    }
    
    return [
        (max_visibility * 0.07) / visibility, // density
        (max_visibility * 0.18249) / visibility, // horizon
        (max_visibility * 0.250091) / visibility, // density_multipler
        (max_visibility * 0.850065) / visibility // distance_multiplier
    ];
}

start()
{    
    // Perform the initial request then set up a timer to do periodic updates
    request_metar();
    llSetTimerEvent(request_interval);
}

default
{
    state_entry()
    {
        // Show the free script memory in chat
        llOwnerSay("Free memory: " + (string) llGetFreeMemory());
        
        if (!read_next_settings_notecard())
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
                if (notecard_name == settings_notecard)
                {
                    list parts = llParseStringKeepNulls(data, [" = "], []);
                    
                    string setting_name = llList2String(parts, 0);
                    string setting_value = llList2String(parts, 1);
                    
                    if (setting_name == "icao")
                    {
                        icao = setting_value;
                    }
                    else if (setting_name == "swfx_emitter_channel")
                    {
                        swfx_emitter_channel = (integer) setting_value;
                    }
                    else if (setting_name == "metar_relay_channel")
                    {
                        metar_relay_channel = (integer) metar_relay_channel;
                    }
                    else if (setting_name == "api")
                    {
                        api = setting_value;
                    }
                    else if (setting_name == "request_interval")
                    {
                        request_interval = (integer) setting_value;
                    }
                    else if (setting_name == "max_visibility")
                    {
                        max_visibility = (float) setting_value;
                    }
                    else if (setting_name == "min_visibility")
                    {
                        min_visibility = (float) setting_value;
                    }
                    else if (setting_name == "set_environment")
                    {
                        set_environment = (integer) setting_value;
                    }
                    else if (setting_name == "christmas_mode")
                    {
                        christmas_mode = (integer) setting_value;
                    }
                }
                else if (notecard_name == cloud_cover_notecard)
                {
                    list parts = llParseStringKeepNulls(data, [" "], []);
                    
                    string clouds = llList2String(parts, 0);
                    float min = (float) llList2String(parts, 1);
                    float max = (float) llList2String(parts, 2);
                    
                    cloud_cover += [clouds, min, max];
                }
                else if (notecard_name == sounds_notecard)
                {
                    list parts = llParseStringKeepNulls(data, [" "], []);
                    
                    string weather = llList2String(parts, 0);
                    key uuid = (key) llList2String(parts, 1);
                    float vol = (float) llList2String(parts, 2);
                    
                    sounds += [weather, uuid, vol];
                }
                else if (notecard_name == ground_textures_notecard)
                {
                    list parts = llParseStringKeepNulls(data, [" "], []);
                    
                    string weather = llList2String(parts, 0);
                    key uuid = (key) llList2String(parts, 1);
                    float alpha = (float) llList2String(parts, 2);
                    
                    ground_textures += [weather, uuid, alpha];
                }
                else if (notecard_name == airports_notecard)
                {
                    list parts = llParseStringKeepNulls(data, [" "], []);
                    
                    float x1 = (float) llList2String(parts, 0);
                    float y1 = (float) llList2String(parts, 1);
                    string code = llList2String(parts, 2);
                    
                    vector pos = llGetRegionCorner() + llGetPos();
                    float x2 = pos.x / 256;
                    float y2 = pos.y / 256;
                    
                    float dist = llVecDist(<x1, y1, 0>, <x2, y2, 0>);
                                    
                    if (icao == "" || dist < closest_airport_distance)
                    {
                        icao = code;
                        closest_airport_distance = dist;
                    }
                }
            }
            
            data = llGetNotecardLineSync(notecard_name, ++notecard_line);
        }
        
        if (data == NAK)
        {
            notecard_query = llGetNotecardLine(notecard_name, notecard_line);
        }
        
        if (data == EOF)
        {
            if (!read_next_settings_notecard())
            {
                start();
            }
        }
    }
    
    timer()
    {
        request_metar();
    }

    http_response(key request_id, integer status, list metadata, string body)
    {
        // Ignore responses to any other requests
        if (request_id != http_request_id)
        {
            return;
        }
        
        // If the request failed, skip it
        if (status != 200)
        {
            return;
        }
        
        // Read the raw METAR string from the XML
        string metar = llGetSubString(body, 25, -5);
        
        // Parse the METAR data
        list parsed_metar = parse_metar(metar);
        
        // Extract pieces of METAR info
        string icao = llList2String(parsed_metar, 0);
        integer day = llList2Integer(parsed_metar, 1);
        integer hour = llList2Integer(parsed_metar, 2);
        integer minute = llList2Integer(parsed_metar, 3);
        integer wind_direction = llList2Integer(parsed_metar, 5);
        integer wind_speed = llList2Integer(parsed_metar, 6);
        integer visibility = llList2Integer(parsed_metar, 7);
        string weather = llList2String(parsed_metar, 8);
        string cloud_type = llList2String(parsed_metar, 9);
        integer cloud_height = llList2Integer(parsed_metar, 10);
        integer temperature = llList2Integer(parsed_metar, 11);
        integer dewpoint = llList2Integer(parsed_metar, 12);
        string altimeter = llList2String(parsed_metar, 13);
        
        if (christmas_mode)
        {
            if (weather == "RN")
            {
                weather = "SN";
            }
            else if (weather == "+RN")
            {
                weather = "+SN";
            }
            else
            {
                weather = "-SN";
            }
        }
        
        // DEBUG: override METAR data for testing
        //cloud_type = "FEW";
        //weather = "-RA";
        //christmas_mode = 0;
        //visibility = 0;
        
        // Relay parsed METAR data to links and other objects in the region
        string data = llList2Json(JSON_OBJECT, [
            "raw", metar,
            "icao", icao,
            "day", day,
            "hour", hour,
            "minute", minute,
            "windDirection", wind_direction,
            "windSpeed", wind_speed,
            "visibility", visibility,
            "weather", weather,
            "cloudType", cloud_type,
            "cloudHeight", cloud_height,
            "temperature", temperature,
            "dewPoint", dewpoint,
            "altimeter", altimeter
        ]);
        llMessageLinked(LINK_SET, metar_relay_channel, data, NULL_KEY);
        llRegionSay(metar_relay_channel, data);
        
        // Alter the environment settings based on the Shergood METAR data
        if (set_environment)
        {
            // Check if any relevant data changed and thus an environment adjustment is needed
            if (cloud_type != last_cloud_type || visibility != last_visibility)
            {
                // Get the current environment settings
                list environment = llGetEnvironment(llGetPos(), [SKY_CLOUDS, SKY_HAZE]);
                
                // Remove values not used in llSetEnvironment
                // SKY_CLOUDS is_default
                environment = llDeleteSubList(environment, 7, 7);
                
                // Add llSetEnvironment constants
                environment = [SKY_CLOUDS] + environment;
                environment = llListInsertList(environment, [SKY_HAZE], 8);
                
                // Modify the parameters based on the Shergood METAR data
                // SKY_CLOUDS cover
                environment = llListReplaceList(environment, [get_cloud_cover(cloud_type)], 2, 2);
                // SKY_HAZE horizon
                environment = llListReplaceList(environment, get_haze(visibility), 9, 12);
                
                // Apply the environment parameters
                integer err = llSetEnvironment(llGetPos(), environment);
                if (err != 1)
                {
                    llOwnerSay("llSetEnvironment failed: " + (string) err);
                }
                
                // Record relevant data to compare next update
                last_cloud_type = cloud_type;
                last_visibility = visibility;
            }
        }
        
        // Relay particle data and sounds to METAR weather nodes
        
        // Only relay if the weather has changed since last update
        if (weather != last_weather)
        {
            string particle;
            string sound;
            float volume;
            string texture;
            float alpha;
            
            // Choose the appropriate particle data
            if (weather == "-RA")
            {
                particle = particle_light_rain();
            }
            else if (weather == "RA")
            {
                particle = particle_rain();
            }
            else if (weather == "+RA")
            {
                particle = particle_heavy_rain();
            }
            else if (weather == "-SN")
            {
                particle = particle_light_snow();
            }
            else if (weather == "SN")
            {
                particle = particle_snow();
            }
            else if (weather == "+SN")
            {
                particle = particle_heavy_snow();
            }
            else
            {
                particle = "[]";
            }
            
            // Choose the appropriate sound
            integer sound_index = llListFindStrided(sounds, [weather], 0, -1, 3);
            if (sound_index != -1)
            {
                sound = llList2String(sounds, sound_index + 1);
                volume = llList2Float(sounds, sound_index + 2);
            }
            
            integer texture_index;
            if (christmas_mode)
            {
                texture_index = llListFindStrided(ground_textures, ["+SN"], 0, -1, 3);
            }
            else
            {
                texture_index = llListFindStrided(ground_textures, [weather], 0, -1, 3);
            }
            if (texture_index != -1)
            {
                texture = llList2String(ground_textures, texture_index + 1);
                alpha = llList2Float(ground_textures, texture_index + 2);
            }
            
            // Send the particle data and sound to any METAR weather nodes
            llRegionSay(swfx_emitter_channel, llList2Json(JSON_OBJECT, [
                "particle", particle,
                "sound", sound,
                "volume", volume,
                "texture", texture,
                "alpha", alpha
            ]));
            
            // Record the weather to check if it changed next update
            last_weather = weather;
        }
    }
}
