   //2 phase for trees shades, jest ok pokazuje cienie, ale nie plywa na i\nie :
   /*
    ps_1_1
    tex t0
    tex t1
    mul r0.xyz, t1, t0
  + mov r0.w, t0.w
  */
 

sampler samp0: register(s0);
sampler samp1: register(s1);

float4 main(float2 tex0 : TEXCOORD0, //tekstura podstawowa
			 float2 tex1 : TEXCOORD1) : COLOR0 {
    float4 texPix0 = tex2D(samp0, tex0);
    float4 texPix1 = tex2D(samp1, tex1);
		float4 result;
    result.xyz =  texPix1 * texPix0 ;
    result.w = texPix0.w;
    return result;
}