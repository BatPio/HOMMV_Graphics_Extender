 /* 
    ps_1_1
    tex t0
    tex t1
    mov r0.xyz, t0
  + mul r0.w, v0.w, t0.w
    mul r0, r0, t1
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