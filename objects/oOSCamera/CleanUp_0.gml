/// oOSCamera — Clean Up

// ====================================================
// CAMERA CLEANUP
// ====================================================

// Only destroy cameras created by this object.
// Cameras created by the Room Editor are managed
// by GameMaker.

if (owns_camera)
{
    if (cam != -1)
    {
        if (view_camera[0] == cam)
        {
            view_camera[0] = -1;
        }

        camera_destroy(cam);
        cam = -1;
    }
}