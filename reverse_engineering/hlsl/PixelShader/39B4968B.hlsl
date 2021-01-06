//3 phase for terrain

 /*   
    ps_1_1
    tex t0
    mul r0, t0, c0
    mul r0.xyz, r0, v0
 */

sampler samp0: register(s0);
float4 p0 : register(c0);

float4 main(float2 tex0 : TEXCOORD0, //tekstura podstawowa
            float4 color0 : COLOR0) : COLOR {
    float4 texPix0 = tex2D(samp0, tex0);
	float4 result;
    result = texPix0 * p0;
    result.xyz = result * color0;
    return result;
}