// Shergood Weather FX Ground Layer v0.2.0

// Channel for METAR weather emitter messages
integer swfx_emitter_channel = -77737413;

default
{
    state_entry()
    {
        llSetLinkTexture(LINK_SET, TEXTURE_BLANK, ALL_SIDES);
        llListen(swfx_emitter_channel, "", "", "");
    }
    
    listen(integer channel, string name, key id, string message)
    {
        // Ignore messages from non-owner avatars/objects
        if (llGetOwnerKey(id) != llGetOwner())
        {
            return;
        }
        
        string texture = llJsonGetValue(message, ["texture"]);
        float alpha = (float) llJsonGetValue(message, ["alpha"]);
        
        if (texture == "")
        {
            llSetLinkAlpha(LINK_SET, 0, 0);
            llSetLinkTexture(LINK_SET, TEXTURE_BLANK, 0);
        }
        else
        {
            llSetLinkAlpha(LINK_SET, alpha, 0);
            llSetLinkTexture(LINK_SET, texture, 0);
        }
    }
}
