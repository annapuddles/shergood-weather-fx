// Shergood Weather FX Emitter v1.2.0
// Emits particles and sounds based on commands from the Shergood Weather FX controller.

// CONFIGURATION

// Channel for METAR relay messages
integer swfx_emitter_channel = -77737413;

// How often to repeat the sensor scan for HD fires.
float hd_fire_scan_interval = 5;

// Don't attempt to put out fires this many meters or more below the emitter.
float hd_fire_max_height = 40;

// END OF CONFIGURATION

string current_sound;

default
{
    state_entry()
    {
        llLinkParticleSystem(LINK_SET, []);
        llLinkStopSound(LINK_SET);
        llListen(swfx_emitter_channel, "", "", "");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        // Ignore messages from non-owner avatars/objects
        if (llGetOwnerKey(id) != llGetOwner())
        {
            return;
        }
        
        // If an HD fire check is triggered, scan for any HD fires.
        if (message == "hd_fire_check")
        {
            // Ensure the water bullet object has been added to inventory before scanning and rezzing.
            if (llGetInventoryNumber(INVENTORY_OBJECT) > 0)
            {
                llSensorRepeat("SMOKE", "", SCRIPTED, 96, PI, hd_fire_scan_interval);
            }
            
            return;
        }
        
        list particle = llJson2List(llJsonGetValue(message, ["particle"]));
        string sound = llJsonGetValue(message, ["sound"]);
        float volume = (float) llJsonGetValue(message, ["volume"]);
        
        // Cast all vectors in the params list
        integer n;
        for (n = llGetListLength(particle) - 1; n >= 0; --n)
        {
            string item = llList2String(particle, n);
            if (llGetSubString(item, 0, 0) == "<")
            {
                particle = llListReplaceList(particle, [(vector) item], n, n);
            }
        }
        
        llLinkParticleSystem(LINK_SET, particle);
        
        if (sound == NULL_KEY)
        {
            llLinkStopSound(LINK_SET);
        }
        else if (current_sound != sound)
        {
            llLinkStopSound(LINK_SET);
            
            integer n;
            for (n = llGetNumberOfPrims(); n > 0; --n)
            {
                if (sound != "")
                {
                    llLinkPlaySound(n, sound, volume + (llFrand(0.2) - 0.1), SOUND_LOOP);
                }
                llSleep(llFrand(0.5) + 0.5);
            }
        }
        
        current_sound = sound;
    }
    
    // If any HD fires are detected, rez a water bullet on them.
    sensor(integer detected)
    {
        for (--detected; detected >= 0; --detected)
        {
            // Get the position of the fire
            vector fire_pos = llDetectedPos(detected);
            
            // Get the current position of the emitter.
            vector emtr_pos = llGetPos();
            
            // Calculate the height difference between the fire and emitter.
            float dz = emtr_pos.z - fire_pos.z;
            
            // If the height diff is >= 0 (fire is below the emitter) and < hd_fire_max_height (not too far below), rez a water bullet on it.
            if (dz >= 0 && dz < hd_fire_max_height)
            {
                // Move the emitter to the fire to rez the bullet.
                llSetRegionPos(fire_pos);
                
                // Rez the bullet as a temporary, physical object.
                llRezObjectWithParams(llGetInventoryName(INVENTORY_OBJECT, 0), [
                    REZ_FLAGS, REZ_FLAG_TEMP | REZ_FLAG_PHYSICAL | REZ_FLAG_DIE_ON_COLLIDE | REZ_FLAG_BLOCK_GRAB_OBJECT
                ]);
                                
                // Return the emitter to its original position.
                llSetRegionPos(emtr_pos);
            }
        }
    }
    
    // If no HD fires are found, stop the sensor until the next check.
    no_sensor()
    {
        llSensorRemove();
    }
}
