sampler samp0: register(s0);
sampler samp1: register(s1);

float4 p6 : register(c6); //x1
uniform float4x4 ModelViewMatrix : register(c10); //x4
float4 p0 : register(c0);
float4 p1 : register(c1);
float4 p2 : register(c2);
float4 diffuseColor : register(c16); //Kolor zaznaczenia

//(fog_end - camera)/(fog_end - fog_start)
// fogFactors.x = -1/(fog_end - fog_start)
// fogFactors.y = fog_end/(fog_end - fog_start)
// fogFactors.z = -1/(fog_end - fog_start)
// fogFactors.w = fog_end/(fog_end - fog_start)
float4 fogFactors : register(c19); //x2
float4 p23 : register(c23); //x1
float4 p24 : register(c24);
float4 p25 : register(c25); //x1
float4 p26 : register(c26); //x1
float4 p27 : register(c27); //x1
float4 p29 : register(c29); //x1
float4 p30 : register(c30); //x1
float4 p31 : register(c31); //x1
float4 p32 : register(c32); //x1
float4 p34 : register(c34);
float4 p35 : register(c35);
float4 p36 : register(c36);
float4 p38 : register(c38); //x1
float4 p39 : register(c39); //x1
//c9 x1
//c14 x1
//c15 x1
//c21 x1
//c31 x1
//c24 x1
//c35 x1

struct VS_INPUT
{
    float4 vPosition : POSITION;
    float4 vNormal : NORMAL0;
	float4 vNormal1 : NORMAL1;
    float2 vTex0 : TEXCOORD0;
	float4 vTangent: TANGENT0;
	float4 vTangent1: TANGENT1;
	float2 vTex1 : TEXCOORD1;
};

struct VS_OUTPUT
{
    float4 vPosition : POSITION;
	float fog : FOG;
	//Anisotropic lighting directions map
	float2 anisoTexCoord : TEXCOORD0;
	//Light tangent
	float3 Ltan: TEXCOORD1;
	//View tangent
	float3 Vtan: TEXCOORD2;
	//water texture
	float2 waterTexCoord: TEXCOORD3;
	float4 vDiffuse : COLOR0;
	//Fog of war, alpha
	float4 color : COLOR1;
};

VS_OUTPUT  main(VS_INPUT input) {
	VS_OUTPUT output;
	float4 position = mul(input.vPosition, ModelViewMatrix); 
    output.vPosition = position;

	//(Fog_end - camera)/(Fog_end - fog_start)
    float dFog = fogFactors.x * position.w + fogFactors.y;
    float hFog = fogFactors.z * input.vPosition.z + fogFactors.w;
    float fog = max(min(dFog, hFog), p0.x) + p1.x;
	
	float fogOfWar = (input.vTangent1.w * p30.x) + (input.vTangent.w * p30.y);
	output.fog =fog - fogOfWar;
	
	float2 texPos = input.vTex0.xy * p6.xx * p32.xy + p31.xy;
	output.anisoTexCoord  = texPos;
	output.waterTexCoord  = texPos;
	
	float camThing = 1/position.w;
	float4 camVec = position * camThing;
	camVec.xy = p2.x * camVec.xyyy + p2.x;
	output.Ltan  =camVec.xxxw * p35;
	output.Vtan  =camVec.yyyw * p36;
	
	output.vDiffuse.xyz = input.vNormal1; //Compilation error fix
	output.vDiffuse.w = input.vNormal.w * p34.z; //Transparency
	output.color.xyz = input.vNormal1; //Compilation error fix
	output.color.w = fogOfWar;
	
	return output;
}