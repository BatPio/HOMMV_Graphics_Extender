/*  
    ps_1_1
    tex t0
    mul_x4_sat r0.xyz, v1, t0
  + mul r0.w, t0.w, v0.w*/

//tress, buildings on terrain
//dorobić vs dla drzew bo budynki i drzewa trafiają tutaj
sampler samp0: register(s0);

float4 main( float2 tex0 : TEXCOORD0, //tekstura podstawowa
			 float4 color0 : COLOR0, // xyz diff lifght, w mieszanie tekstur
			 float4 color1 : COLOR1,
			 float fogFactor : FOG) : COLOR { //xyz diff light dla cienia
	float4 texPix0 = tex2D(samp0, tex0);
	//float4 temp0;
	float4 result;
	result.xyz = saturate(texPix0 * color1 * 4);
	//float4 light =  color0;
	//result.xyz = saturate(texPix0 * light * 4);
	result.w = texPix0.w * color0.w; // mieszanie teksur
	return result;
}