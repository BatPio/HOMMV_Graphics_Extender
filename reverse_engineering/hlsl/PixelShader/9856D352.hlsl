sampler samp0: register(s0);
sampler samp1: register(s1);
float4 p4 : register(c4);

float4 main( float2 tex0 : TEXCOORD0, //tekstura podstawowa
			 float2 tex1: TEXCOORD1, // s(t1).w -> mapa cieni
			 float4 tex2: TEXCOORD2, // z -> wysokość (Y)
			 float4 color0 : COLOR0, // xyz diff lifght, w mieszanie tekstur
			 float4 color1 : COLOR1,
			 float fogFactor : FOG) : COLOR { //xyz diff light dla cienia
	float4 texPix0 = tex2D(samp0, tex0);
	//float4 temp0;
	float3 shadow = saturate(texPix0 * color0 * 4);
	//float3 shadow = texPix0;
	//float3 fullSun = lerp(saturate(texPix0 * color1 * 4), shadow, //texPix0);
	float3 fullSun = lerp(saturate(texPix0 * color1 * 4), shadow, texPix0);
	
	float4 texPix1 = tex2D(samp1, tex1);
	float warunek = p4.w + saturate((texPix1.w - tex2.z) * 4); //mapa cienia
	//float warunek = tex2.y; 
	
	float3 green = {warunek, warunek, warunek};
	//shadow = green;
	
	float4 result;
	
	
	
	result.xyz = (warunek > 0.5f) ? shadow : fullSun;
	
	 // Calculate the final color using the fog effect equation.
	float4 fogColor = {0.607843f, 0.917647f, 0.941176f, 1.0f};
	result.xyz = fogFactor * result.xyz + (1.0 - fogFactor) * fogColor;

	
	//result.xyz = green;
	result.w = texPix0.w * color0.w; // mieszanie teksur
	//result.w = 1.0f;
	return result;
}