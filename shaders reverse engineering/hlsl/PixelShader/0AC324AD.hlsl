sampler anisoDirMap: register(s0);
sampler anisoLookup: register(s2);
sampler baseMap: register(s3);

float4 ps_main(
	//Anisotropic lighting directions map
	float2 anisoTexCoord : TEXCOORD0,
	//Light tangent
	float3 Ltan: TEXCOORD1,
	//View tangent
	float3 Vtan: TEXCOORD2,
	//water texture
	float4 waterTexCoord: TEXCOORD3,
	float4 oColor : COLOR,
	//Fog of war, alpha
	float4 color : COLOR1) : SV_TARGET {
	float3 anisoDir = 2 * tex2D(anisoDirMap, anisoTexCoord) - 1;
	float2 v;
	v.x = dot(anisoDir, Ltan);
	v.y = dot(anisoDir, Vtan);
	float4 aniso= tex2D(anisoLookup, v);
	float4 waterTexture = tex2D(baseMap, waterTexCoord);
	oColor.xyz = lerp(waterTexture, aniso, waterTexture.w) * color.w;
	return oColor;
}