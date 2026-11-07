## Defold Post processing Blur Example

Utilises a render object with a modified render script and custom materials.

HTML example:
[https://afowleer77776.itch.io/post-process-blur](https://afowleer77776.itch.io/post-process-blur)

It uses free assets by Craftpix.net 
## How it works
The modified render script sets up two render targets for a two-pass blur pipeline. When activated, it:

- Renders all world predicates (excluding the GUI) into the first render target.
- Executes a horizontal blur pass from the first render target to the second.
- Executes a vertical blur pass from the second render target to the default backbuffer.

---

## Integration

All required assets are contained within the blur folder:

- Render pipeline: The custom .render file and .render_script (referencing both blur materials).
- Materials: The two post-processing blur materials.
- Post-process object: blur_post_processing.go.

How to use:

1. Copy the blur folder into your root folder in your project.
2. In game.project, set the Render entry under Bootstrap to the .render file located in the blur folder.
3. Add blur_post_processing.go to any collection that requires blur, ensuring its position remains at (0, 0, 0).


in a script add the following locals

```
local MSG_BLUR = hash("msg_camera_blur")
local MSG_BLUR_LOW = hash("msg_camera_blur_low")
local MSG_BLUR_HIGH = hash("msg_camera_blur_high")
local MSG_BLUR_ENABLE = hash("msg_camera_blur_enable")
```
you can turn on blur effect processing using
```
msg.post("@render:", MSG_BLUR_ENABLE, {enable=true})
```
set the blur type using
```
msg.post("@render:", MSG_BLUR_HIGH,nil)
```
or 
```
msg.post("@render:", MSG_BLUR_LOW,nil)
```

then control the effect using
```
msg.post("@render:", MSG_BLUR, {value=8,duration=2})
```
where value is the blur size and duration is length of the effect in seconds
