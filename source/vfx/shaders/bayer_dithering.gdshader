// Based on: https://www.shadertoy.com/view/WstXR8
// https://godotshaders.com/shader/bayer-dithering/

shader_type canvas_item;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;
const float maximum = 128.0;

const mat4 bayerIndex = mat4(
    vec4(00.0/maximum, 12.0/maximum, 03.0/maximum, 15.0/maximum),
    vec4(08.0/maximum, 04.0/maximum, 11.0/maximum, 07.0/maximum),
    vec4(02.0/maximum, 14.0/maximum, 01.0/maximum, 13.0/maximum),
    vec4(10.0/maximum, 06.0/maximum, 09.0/maximum, 05.0/maximum));
	
void fragment() {
	 // sample the texture
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
    vec2 uv = FRAGCOORD.xy/iResolution.xy;
    vec4 col = texture(SCREEN_TEXTURE,uv);
    
    // gamma correction
    col = vec4(pow(col.rgb,vec3(2.2)) - 0.004,col.a);
    
    // find bayer matrix entry based on fragment position
    float bayerValue = bayerIndex[int(FRAGCOORD.x) % 4][int(FRAGCOORD.y) % 4];
    
    
        // output
     COLOR = vec4(
            step(bayerValue,col.r),
            step(bayerValue,col.g),
            step(bayerValue,col.b),
            col.a);
}