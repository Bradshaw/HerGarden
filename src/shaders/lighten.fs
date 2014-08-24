extern vec4 colors[16];
extern float ditherAmt;
extern float time;
extern float rseed;
extern Image pal;
extern float lightmult = 1;
extern float lightX = 0;
extern float lightY = 0;


highp float M_PI = 3.14159265;

float hue2rgb(float p, float q, float t){
    if(t < 0) t += 1.0;
    if(t > 1) t -= 1.0;
    if(t < 1.0/6.0) return p + (q - p) * 6.0 * t;
    if(t < 1.0/2.0) return q;
    if(t < 2.0/3.0) return p + (q - p) * (2.0/3.0 - t) * 6.0;
    return p;
}

vec4 hslToRgb(vec4 col){
    float r, g, b;
    float h, s, l;
    h = col.r;
    s = col.g;
    l = col.b;


    if(s == 0){
        r = g = b = l; // achromatic
    }else{

        float q = (l < 0.5 ? l * (1.0 + s) : l + s - l * s);
        float p = 2.0 * l - q;
        r = hue2rgb(p, q, h + 1.0/3.0);
        g = hue2rgb(p, q, h);
        b = hue2rgb(p, q, h - 1.0/3.0);
    }

    return vec4(r,g,b,1);
}

vec4 rgbToHsl(vec4 col){
    float r,g,b;
    r = col.r;
    g = col.g;
    b = col.b;
    float max = max(r, max(g, b));
    float min = min(r, min(g, b));
    float h, s, l = (max + min) / 2;

    if(max == min){
        h = s = 0.0; // achromatic
    }else{
        float d = max - min;
        s = l > 0.5 ? d / (2.0 - max - min) : d / (max + min);
        
        if (max==r)
            h = (g - b) / d + (g < b ? 6.0 : 0.0);
        if (max==g)
            h = (b - r) / d + 2.0;
        if (max==b)
            h = (r - g) / d + 4.0;
        h /= 6.0;
    }

    return vec4(h,s,l,1);
}

vec4 inv(vec4 c)
{

    vec4 hsl = rgbToHsl(vec4(c));
    hsl.g *=1.2;
    hsl.b = 1-hsl.b;

    return hslToRgb(hsl);
}


// Magic number function
// Returns a value between 0 and 1
float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// Returns the square of the rgb distance
float dist32(vec4 a, vec4 b)
{
    vec4 d = b-a;
    return (d.r*d.r + d.g*d.g + d.b*d.b);
}

// Returns the rgb distance
//! sqrt is a hungry baby, do not over-use
float dist3(vec4 a, vec4 b)
{
    return sqrt(dist32(a,b));
}

float dist22(vec2 a, vec2 b)
{
    vec2 d = b-a;
    return (d.x*d.x + d.y*d.y);
}


float dist2(vec2 a, vec2 b)
{
    return sqrt(dist22(a,b));
}


float plasma(vec2 v_coords) {
    float u_k = 0.1;
    float v = 0.0;
    vec2 c = v_coords * u_k - u_k/2.0;
    v += sin((c.x+time));
    v += sin((c.y+time)/2.0);
    v += sin((c.x+c.y+time)/2.0);
    c += u_k/2.0 * vec2(sin(time/3.0), cos(time/2.0));
    v += sin(sqrt(c.x*c.x+c.y*c.y+1.0)+time);
    v = v/2.0;
    return v;
}

// Change this function for extra juicy
// Should return a value between -1 and 1
float jitterFunc(vec2 coord)
{
    //return (sin(((coord.x-coord.y)*M_PI)/10.0)>0?1:-1)+rand(coord+rseed)-rand(coord+1);
    return (sin(((coord.x-coord.y)*M_PI)/2.0))+(rseed-0.5)*0.05;
    //return (rseed-0.5)*0.05;
    //return rand(coord+rseed)-rand(coord+1000+rseed);
    //return 0.001;
}


// Gets the index of the closest colour to tested colour.
int getClosest(vec4 c, vec2 coord){
    int res; // Result
    float mindist = 10000; // rbg values have a maximum distance of sqrt(3) so this should be big enough
    int i;
    for (i = 0; i < 16; ++i)
    {
        float dist = dist3(c, colors[i]);       // Use dist32() for better performance, but dodgy jittering
        if (dist<mindist+ditherAmt*jitterFunc(coord)) // dither and jitter work together to break nasty lines
        {
            mindist = dist;
            res = i;
        }
    }
    return res;
}

vec4 effect( vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords )
{
    vec4 c = Texel(texture, texture_coords); // Get the ACTUAL colour
    float distFromLight = (dist2(vec2(lightX,200-lightY),vec2(screen_coords.x,screen_coords.y)))*(lightmult/400);
    c *= ( 1 - distFromLight );
    //int i = getClosest(c, screen_coords); // Find the index of the closest colour
    return vec4(c.r,c.g,c.b,1)*color; // Return said closest colour
}