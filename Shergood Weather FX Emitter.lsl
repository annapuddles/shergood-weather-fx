// Shergood Weather FX Emitter v1.1.0
// Emits particles and sounds based on commands from the Shergood Weather FX controller.

// CONFIGURATION

// Channel for METAR relay messages
integer swfx_emitter_channel = -77737413;

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
}
