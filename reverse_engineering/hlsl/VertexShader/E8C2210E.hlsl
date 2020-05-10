sampler samp0: register(s0);
sampler samp1: register(s1);

uniform float4x4 ModelViewMatrix : register(c10); //x4
float4 p0 : register(c0);
float4 p1 : register(c1);
float4 diffuseColor : register(c16); //Kolor zaznaczenia

//(fog_end - camera)/(fog_end - fog_start)
// fogFactors.x = -1/(fog_end - fog_start)
// fogFactors.y = fog_end/(fog_end - fog_start)
// fogFactors.z = -1/(fog_end - fog_start)
// fogFactors.w = fog_end/(fog_end - fog_start)
float4 fogFactors : register(c19); //x2
float4 p23 : register(c23); //x1
float4 p25 : register(c25); //x1
float4 p26 : register(c26); //x1
float4 p27 : register(c27); //x1
float4 p29 : register(c29); //x1
float4 p30 : register(c30); //x1
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
    float3 vNormal : NORMAL0;
	float3 vNormal1 : NORMAL1;
    float2 vTex0 : TEXCOORD0;
	float4 vTangent: TANGENT0;
	float4 vTangent1: TANGENT1;
	float2 vTex1 : TEXCOORD1;
};

struct VS_OUTPUT
{
    float4 vPosition : POSITION;
    float4 vDiffuse : COLOR0;
	float fog : FOG;
};

VS_OUTPUT  main(VS_INPUT input) {
	VS_OUTPUT output;
	float4 position = mul(input.vPosition, ModelViewMatrix); //To jest dobrze
    output.vPosition = position;

	//(Fog_end - camera)/(Fog_end - fog_start)
    float dFog = fogFactors.x * position.w + fogFactors.y;
    float hFog = fogFactors.z * input.vPosition.z + fogFactors.w;
    output.fog = max(min(dFog, hFog), p0.x);
	
	output.vDiffuse = (input.vTangent1.w * p30.x + input.vTangent.w * p30.y) * diffuseColor;
	
	return output;
}