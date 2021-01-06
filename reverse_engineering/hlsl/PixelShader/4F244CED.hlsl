//emblematy miast
/*  
    ps_1_1
    tex t0
    mul_x4_sat r0.xyz, v1, t0
  + mul r0.w, t0.w, v0.w
*/

sampler samp0: register(s0);
float4 p0 : register(c0);

float4 main(float2 tex0 : TEXCOORD0, 
            float4 color0 : COLOR0,
            float4 color1 : COLOR1) : COLOR {
  float4 texPix0 = tex2D(samp0, tex0);
	float4 result;
  result.xyz = saturate(texPix0 * color1 * 4);
  result.w =  texPix0.w * color0.w;
  return result;
}
 